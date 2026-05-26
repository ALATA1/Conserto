from sqlalchemy import Column, Integer, String
from app.database.base import Base


class Competence(Base):
    __tablename__ = "competences"

    id = Column(Integer, primary_key=True, index=True)
    nom = Column(String, unique=True, index=True)
    categorie = Column(String)  # ex: Backend, Frontend, DevOps