# 2FA TOTP (ESP32 demo) - Guia de despliegue seguro

## 1) Variables de entorno (Render)
Configurar en el backend:

- `TOTP_SECRET_GLOBAL=<BASE32_COMPARTIDO_CON_ESP32>`
- `DEVICE_SERIAL=ESP32-DEMO-001`
- `JWT_SECRET=<secreto_largo>` (compat: tambien funciona `JWT_SECRET_KEY`)
- `TWO_FACTOR_REQUIRED=true` (demo: exige 2FA siempre tras password OK)

Opcionales:
- `TOTP_DIGITS=6`
- `TOTP_PERIOD_SECONDS=60`
- `TOTP_VALID_WINDOW=1`
- `TWO_FACTOR_TMP_TOKEN_EXPIRE_MINUTES=5`
- `TWO_FACTOR_MAX_ATTEMPTS=5`
- `DEVICE_NOTIFY_PATTERN=TRIPLE`

## 2) Backup antes de migrar (obligatorio recomendado)
Si no hay staging DB, hacer backup de produccion antes del `upgrade`:

```powershell
$env:DATABASE_URL="postgresql://..."
pg_dump --format=custom --file .\backup_pre_2fa_esp32.dump $env:DATABASE_URL
```

## 3) Migracion (append-only)
Esta version agrega:
- `token_device`
- `auth_challenge`
- columna `access_log.detail`
- nuevos valores enum `access_event_type`:
  - `LOGIN_PWD_OK`
  - `2FA_SUCCESS`
  - `2FA_FAIL`

Aplicar:

```powershell
venv\Scripts\alembic.exe upgrade head
```

Rollback tecnico (sin borrar valores ENUM nuevos):

```powershell
venv\Scripts\alembic.exe downgrade e2c4b1f9a8d0
```

## 4) Flujo API de login 2FA
### Paso 1: password
`POST /login` (alias: `POST /auth/login`)

Respuesta esperada cuando 2FA esta activo:

```json
{
  "requires_2fa": true,
  "tmp_token": "....",
  "challenge_id": "...."
}
```

### Paso 2: TOTP
`POST /auth/2fa/verify`

Body:

```json
{
  "tmp_token": "....",
  "code": "123456"
}
```

Si es correcto, devuelve token final (JWT normal, stage FULL).
Si falla, responde `401` con: `Codigo incorrecto o expirado`.

## 5) Pruebas manuales con curl
### Login paso 1
```bash
curl -X POST "https://pw-backend-grupo5.onrender.com/login" \
  -H "Content-Type: application/json" \
  -d '{"correo":"usuario@demo.com","password":"TuPassword123!"}'
```

### Verificar 2FA
```bash
curl -X POST "https://pw-backend-grupo5.onrender.com/auth/2fa/verify" \
  -H "Content-Type: application/json" \
  -d '{"tmp_token":"<TMP_TOKEN>","code":"123456"}'
```

### Polling dispositivo
```bash
curl "https://pw-backend-grupo5.onrender.com/device/notify?serial=ESP32-DEMO-001"
curl -X POST "https://pw-backend-grupo5.onrender.com/device/notify/ack?serial=ESP32-DEMO-001"
curl -X POST "https://pw-backend-grupo5.onrender.com/device/ping?serial=ESP32-DEMO-001"
```

## 6) Frontend esperado
En `prograWeb-grupo5`:
- Login detecta `requires_2fa`
- Guarda `tmp_token` temporal y redirige a `/#/two-factor`
- Solo despues de verificar 2FA guarda `DATOS_LOGIN`/`TOKEN` final.

## 7) Minimizar riesgo en produccion (sin staging DB)
1. Backup DB.
2. Deploy backend con variables listas.
3. Ejecutar migracion.
4. Smoke tests (`/login`, `/auth/2fa/verify`, `/device/notify`).
5. Deploy frontend.
6. Validar login real con un usuario de prueba antes de abrir al equipo.
