from pydantic import BaseModel
from typing import List

class CollaborateurCreate(BaseModel):
    nom: str
    prenom: str
    profil: str
    agence: str
    competence: str
    niveau: int
    appetence: int


class CollaborateurOut(CollaborateurCreate):
    id: int

    class Config:
        from_attributes = True