from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Optional, Union

router = APIRouter()

# --------------------
# DATA TEMPORAIRE
# --------------------
collaborateurs = [
    {
        "id": 1,
        "nom": "Ibrahima",
        "prenom": "Alata",
        "profil": "Testeur Automaticien",
        "agence": "Niort",
        "competence": ["Robotframework", "Playwright"],
        "niveau": 4,
        "niveau_attendu": 5
    }
]

# --------------------
# MODELS (API CONTRACT)
# --------------------
class Collaborateur(BaseModel):
    nom: str
    prenom: str
    profil: str
    agence: str
    competence: List[str] = []
    niveau: int
    niveau_attendu: int


# --------------------
# GET ALL
# --------------------
@router.get("/")
def get_all():
    return collaborateurs


# --------------------
# GET BY ID
# --------------------
@router.get("/{id}")
def get_by_id(id: int):
    for c in collaborateurs:
        if c["id"] == id:
            return c
    raise HTTPException(status_code=404, detail="Not found")


# --------------------
# CREATE
# --------------------
@router.post("/")
def create(collab: Collaborateur):

    new_id = max([c["id"] for c in collaborateurs], default=0) + 1

    new_collab = collab.dict()
    new_collab["id"] = new_id

    collaborateurs.append(new_collab)

    return new_collab


# --------------------
# DELETE
# --------------------
@router.delete("/{id}")
def delete(id: int):

    global collaborateurs

    collaborateurs = [c for c in collaborateurs if c["id"] != id]

    return {"message": "deleted"}


# --------------------
# UPDATE
# --------------------
@router.put("/{id}")
def update(id: int, collab: Collaborateur):

    for c in collaborateurs:
        if c["id"] == id:
            c.update(collab.dict())
            return c

    raise HTTPException(status_code=404, detail="Not found")