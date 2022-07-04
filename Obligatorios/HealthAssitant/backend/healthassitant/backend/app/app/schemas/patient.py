from datetime import datetime
from pydantic import BaseModel

from app.models.patient import Gender


# Shared properties
class PatientBase(BaseModel):
    code: str
    full_name: str
    gender: Gender
    birth_date: datetime
    image: str


# Properties to receive on item creation
class PatientCreate(PatientBase):
    pass


# Properties to receive on item update
class PatientUpdate(PatientBase):
    pass


# Properties shared by models stored in DB
class PatientInDBBase(PatientBase):
    id: int
    owner_id: int

    class Config:
        orm_mode = True


# Properties to return to client
class Patient(PatientInDBBase):
    pass


# Properties properties stored in DB
class PatientInDB(PatientInDBBase):
    pass
