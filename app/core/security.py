from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext

# =========================
# CONFIG JWT
# =========================
SECRET_KEY = "conserto-secret-key-change-me"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# =========================
# FAKE USER (pour commencer)
# =========================
fake_user = {
    "username": "admin",
    "password": pwd_context.hash("admin123")
}

# =========================
# HASH PASSWORD
# =========================
def verify_password(plain, hashed):
    return pwd_context.verify(plain, hashed)

# =========================
# CREATE TOKEN
# =========================
def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})

    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# =========================
# DECODE TOKEN
# =========================
def decode_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        return None