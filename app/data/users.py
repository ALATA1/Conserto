from app.api.auth import hash_password




# ===============================
# UTILISATEURS DE L'APPLICATION
# ===============================


users_db = {
    "ibrahima.alata@conserto.pro": {
        "username": "ibrahima.alata@conserto.pro",
        "hashed_password": hash_password("admin"),
        "role": "ADMIN"
    },

    "alice.martin@conserto.pro": {
        "username": "alice.martin@conserto.pro",
        "hashed_password": hash_password("admin123"),
        "role": "MANAGER"
    },

    "helene.martin@conserto.pro": {
        "username": "helene.martin@conserto.pro",
        "hashed_password": hash_password("MonPassword123"),
        "role": "RH"
    }
}