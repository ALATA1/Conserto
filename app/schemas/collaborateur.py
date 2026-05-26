from pydantic import BaseModel
from typing import List


class CollaborateurCreate(BaseModel):
    nom: str
    prenom: str
    profil: str
    agence: str
    competence: List[str]
    niveau: int
    appetence: int