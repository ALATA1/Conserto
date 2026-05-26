from sqlalchemy import Column, Integer, String
from app.database.base import Base


class Collaborateur(Base):
    __tablename__ = "collaborateurs"

    id = Column(Integer, primary_key=True, index=True)
    nom = Column(String)
    prenom = Column(String)
    profil = Column(String)
    agence = Column(String)
    competence = Column(String)
    niveau = Column(Integer)
    niveau_attendu = Column(Integer)