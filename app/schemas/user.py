from pydantic import BaseModel
from typing import Optional

class UserCreate(BaseModel):
    email: str
    password: str
    role: Optional[str] = "user"


class UserOut(BaseModel):
    id: int
    email: str
    role: str

    class Config:
        from_attributes = True