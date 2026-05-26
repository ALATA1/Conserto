# app/core/config.py

import os

SECRET_KEY = os.getenv("SECRET_KEY", "conserto_secret_key")
ALGORITHM = "HS256"

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./skills.db")

APP_NAME = "Conserto Skills"