from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta



SECRET_KEY = "conserto_secret_key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60




# ======================
# FONCTION UNIQUE
# ======================

def get_current_user(request):

    token = request.cookies.get("access_token")

    if not token:
        return None

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])

        return {
            "username": payload.get("sub"),
            "role": payload.get("role")
        }

    except:
        return None
    

# ======================
# PASSWORD HASHING
# ======================
pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto"
)

def hash_password(password: str):
    return pwd_context.hash(password)



def verify_password(plain_password: str, hashed_password: str):
    return pwd_context.verify(plain_password, hashed_password)



# ======================
# JWT
# ======================


def create_access_token(data: dict):
    to_encode = data.copy()

    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})

    token = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return token





# ===========
# PERMISSION
# ===========

def has_permission(role: str, action: str):
    
    permissions = {
    "ADMIN": ["read", "add", "edit", "delete", "export"],
    "RH": ["read", "add", "edit", "delete", "export"],
    "MANAGER": ["read", "edit", "export"],
    "UTILISATEUR": ["read"]
}

    return action in permissions.get(role, [])