from datetime import datetime
from pydantic import BaseModel

from app.models.history import Symptom

# Shared properties
class HistoryBase(BaseModel):
    date: datetime
    symptom: Symptom


# Properties to receive on item creation
class HistoryCreate(HistoryBase):
    pass


# Properties to receive on item update
class HistoryUpdate(HistoryBase):
    pass


# Properties shared by models stored in DB
class HistoryInDBBase(HistoryBase):
    id: int
    owner_id: int

    class Config:
        orm_mode = True


# Properties to return to client
class History(HistoryInDBBase):
    pass


# Properties properties stored in DB
class HistoryInDB(HistoryInDBBase):
    pass
