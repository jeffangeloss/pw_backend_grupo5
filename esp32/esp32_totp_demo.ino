#include <WiFi.h>
#include <HTTPClient.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <RTClib.h>
#include <mbedtls/md.h>
#include <math.h>

// Demo credentials requested by project owner.
static const char* WIFI_SSID = "jefferson";
static const char* WIFI_PASS = "123456789";

static const char* BACKEND_BASE_URL = "https://pw-backend-grupo5.onrender.com";
static const char* DEVICE_SERIAL = "ESP32-DEMO-001";
static const char* SECRET_BASE32 = "REEMPLAZAR_CON_TOTP_SECRET_GLOBAL_BASE32";

static const int TOTP_DIGITS = 6;
static const int TOTP_PERIOD = 60;
static const unsigned long POLL_INTERVAL_MS = 1500;

static const int BUZZER_PIN = 25; // Ajustar segun cableado.

LiquidCrystal_I2C lcd(0x27, 16, 2);
RTC_DS3231 rtc;

unsigned long lastPollMs = 0;
unsigned long lastRenderMs = 0;
byte blockChar[8] = {
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111
};

bool isBase32Char(char c) {
  return (c >= 'A' && c <= 'Z') || (c >= '2' && c <= '7');
}

size_t base32Decode(const char* input, uint8_t* output, size_t outputMaxLen) {
  int buffer = 0;
  int bitsLeft = 0;
  size_t outLen = 0;
  for (size_t i = 0; input[i] != '\0'; ++i) {
    char c = input[i];
    if (c == ' ' || c == '\n' || c == '\r' || c == '\t' || c == '=') continue;
    if (c >= 'a' && c <= 'z') c = c - 32;
    if (!isBase32Char(c)) continue;

    int val = 0;
    if (c >= 'A' && c <= 'Z') val = c - 'A';
    else val = 26 + (c - '2');

    buffer = (buffer << 5) | (val & 0x1F);
    bitsLeft += 5;
    if (bitsLeft >= 8) {
      bitsLeft -= 8;
      if (outLen < outputMaxLen) {
        output[outLen++] = (buffer >> bitsLeft) & 0xFF;
      } else {
        break;
      }
    }
  }
  return outLen;
}

uint32_t dynamicTruncate(const uint8_t* hmacResult) {
  int offset = hmacResult[19] & 0x0F;
  uint32_t binary =
    ((hmacResult[offset] & 0x7F) << 24) |
    ((hmacResult[offset + 1] & 0xFF) << 16) |
    ((hmacResult[offset + 2] & 0xFF) << 8) |
    (hmacResult[offset + 3] & 0xFF);
  return binary;
}

String generateTotp(const char* secretBase32, uint32_t unixTime, int digits, int periodSec) {
  uint8_t secretBytes[64];
  memset(secretBytes, 0, sizeof(secretBytes));
  size_t secretLen = base32Decode(secretBase32, secretBytes, sizeof(secretBytes));
  if (secretLen == 0) return "------";

  uint64_t counter = unixTime / periodSec;
  uint8_t counterBytes[8];
  for (int i = 7; i >= 0; --i) {
    counterBytes[i] = counter & 0xFF;
    counter >>= 8;
  }

  uint8_t hmacResult[20];
  const mbedtls_md_info_t* mdInfo = mbedtls_md_info_from_type(MBEDTLS_MD_SHA1);
  if (!mdInfo) return "------";

  if (mbedtls_md_hmac(mdInfo, secretBytes, secretLen, counterBytes, 8, hmacResult) != 0) {
    return "------";
  }

  uint32_t binCode = dynamicTruncate(hmacResult);
  uint32_t otp = binCode % (uint32_t)pow(10, digits);

  char codeBuf[10];
  snprintf(codeBuf, sizeof(codeBuf), "%0*u", digits, otp);
  return String(codeBuf);
}

void connectWifi() {
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }
}

void beepTriple() {
  for (int i = 0; i < 3; i++) {
    digitalWrite(BUZZER_PIN, HIGH);
    delay(120);
    digitalWrite(BUZZER_PIN, LOW);
    delay(120);
  }
}

String notifyUrl() {
  return String(BACKEND_BASE_URL) + "/device/notify?serial=" + String(DEVICE_SERIAL);
}

String ackUrl() {
  return String(BACKEND_BASE_URL) + "/device/notify/ack?serial=" + String(DEVICE_SERIAL);
}

String pingUrl() {
  return String(BACKEND_BASE_URL) + "/device/ping?serial=" + String(DEVICE_SERIAL);
}

void sendPing() {
  if (WiFi.status() != WL_CONNECTED) return;

  HTTPClient http;
  http.begin(pingUrl());
  http.addHeader("Content-Type", "application/json");
  http.POST("{}");
  http.end();
}

void checkNotify() {
  if (WiFi.status() != WL_CONNECTED) return;

  HTTPClient http;
  http.begin(notifyUrl());
  int status = http.GET();
  String body = status > 0 ? http.getString() : "";
  http.end();

  if (status == 200 && body.indexOf("\"beep\":true") >= 0) {
    beepTriple();

    HTTPClient ack;
    ack.begin(ackUrl());
    ack.addHeader("Content-Type", "application/json");
    ack.POST("{}");
    ack.end();
  }
}

void renderTotp() {
  DateTime now = rtc.now();
  uint32_t unixTime = now.unixtime();
  String code = generateTotp(SECRET_BASE32, unixTime, TOTP_DIGITS, TOTP_PERIOD);

  int elapsed = unixTime % TOTP_PERIOD;
  int filled = map(elapsed, 0, TOTP_PERIOD - 1, 0, 16);
  if (filled < 0) filled = 0;
  if (filled > 16) filled = 16;

  lcd.setCursor(0, 0);
  String line1 = "COD: " + code;
  while (line1.length() < 16) line1 += " ";
  lcd.print(line1.substring(0, 16));

  lcd.setCursor(0, 1);
  for (int i = 0; i < 16; i++) {
    if (i < filled) lcd.write(byte(0));
    else lcd.print(" ");
  }
}

void setup() {
  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);

  Wire.begin();
  lcd.init();
  lcd.backlight();
  lcd.createChar(0, blockChar);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Iniciando...");

  if (!rtc.begin()) {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("RTC no detectado");
  }

  connectWifi();
  sendPing();
  lcd.clear();
}

void loop() {
  unsigned long nowMs = millis();

  if (nowMs - lastRenderMs >= 1000) {
    lastRenderMs = nowMs;
    renderTotp();
  }

  if (nowMs - lastPollMs >= POLL_INTERVAL_MS) {
    lastPollMs = nowMs;
    checkNotify();
  }
}
