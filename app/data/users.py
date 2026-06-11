from app.core.security import hash_password



# ============
# GUIDE DROIT 
# ============

# ADMIN → tout
# MANAGER → lecture + certaines modifs
# RH → gestion RH complète
# UTILISATEUR → lecture seule



# ===============================
# UTILISATEURS DE L'APPLICATION
# ===============================



users_db = {
    "ibrahima.alata@conserto.pro": {
        "username": "ibrahima.alata@conserto.pro",
        "hashed_password": hash_password("admin"),
        "role": "ADMIN"
    },

    "romain.mondon@conserto.pro": {
        "username": "romain.mondon@conserto.pro",
        "hashed_password": hash_password("Manager123@"),
        "role": "MANAGER"
    },

    "philippe.gris@conserto.pro": {
        "username": "philippe.gris@conserto.pro",
        # "hashed_password": hash_password("Utilisateur123@"),
        "hashed_password": hash_password("admin"),
        "role": "UTILISATEUR"
    },

    "justine.regnault@conserto.pro": {
        "username": "justine.regnault@conserto.pro",
        "hashed_password": hash_password("RhNiort123@"),
        "role": "RH"
    },

    "lea.tores@conserto.pro": {
        "username": "lea.tores@conserto.pro",
        "hashed_password": hash_password("RhNiortBordeaux123@"),
        "role": "RH"
    },

    "laurie.avigon@conserto.pro": {
        "username": "laurie.avigon@conserto.pro",
        "hashed_password": hash_password("RhBordeaux123@"),
        "role": "RH"
    }
}