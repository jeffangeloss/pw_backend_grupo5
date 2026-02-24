import re

PASSWORD_MIN_LENGTH = 8
PASSWORD_POLICY_ERROR = "La contrasena debe tener minimo 8 caracteres y un simbolo"
PASSWORD_SYMBOL_REGEX = re.compile(r"[^A-Za-z0-9]")


def password_meets_policy(password: str) -> bool:
    if not isinstance(password, str):
        return False
    return len(password) >= PASSWORD_MIN_LENGTH and bool(PASSWORD_SYMBOL_REGEX.search(password))


def ensure_password_policy(password: str) -> str:
    if not password_meets_policy(password):
        raise ValueError(PASSWORD_POLICY_ERROR)
    return password
