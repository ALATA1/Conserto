from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.models.collaborateur import Collaborateur
from app.schemas.collaborateur import CollaborateurCreate

router = APIRouter()

# =====================
# GET ALL
# =====================
@router.get("/")
def get_all(db: Session = Depends(get_db)):
    return db.query(Collaborateur).all()


# =====================
# GET BY ID
# =====================
@router.get("/{id}")
def get_by_id(id: int, db: Session = Depends(get_db)):

    collab = db.query(Collaborateur).filter(Collaborateur.id == id).first()

    if not collab:
        raise HTTPException(status_code=404, detail="Not found")

    return collab


# =====================
# CREATE
# =====================
@router.post("/")
def create(collab: CollaborateurCreate, db: Session = Depends(get_db)):

    new_collab = Collaborateur(**collab.dict())

    db.add(new_collab)
    db.commit()
    db.refresh(new_collab)

    return new_collab


# =====================
# UPDATE
# =====================
@router.put("/{id}")
def update(id: int, collab: CollaborateurCreate, db: Session = Depends(get_db)):

    db_collab = db.query(Collaborateur).filter(Collaborateur.id == id).first()

    if not db_collab:
        raise HTTPException(status_code=404, detail="Not found")

    for key, value in collab.dict().items():
        setattr(db_collab, key, value)

    db.commit()
    db.refresh(db_collab)

    return db_collab


# =====================
# DELETE
# =====================
@router.delete("/{id}")
def delete(id: int, db: Session = Depends(get_db)):

    db_collab = db.query(Collaborateur).filter(Collaborateur.id == id).first()

    if not db_collab:
        raise HTTPException(status_code=404, detail="Not found")

    db.delete(db_collab)
    db.commit()

    return {"message": "deleted"}