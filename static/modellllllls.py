from sqlalchemy import Column, Integer, String
from app.database.database import Base

class Collaborateur(Base):

    __tablename__ = "collaborateurs"

    id = Column(Integer, primary_key=True, index=True)

    nom = Column(String, nullable=False)
    prenom = Column(String, nullable=False)

    profil = Column(String, nullable=False)

    agence = Column(String, nullable=False)

    competence = Column(String, nullable=False)

    niveau = Column(Integer, nullable=False)

    niveau_attendu = Column(Integer, nullable=False)