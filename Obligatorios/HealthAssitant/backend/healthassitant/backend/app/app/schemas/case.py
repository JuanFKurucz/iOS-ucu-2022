from typing import Optional, List

from datetime import datetime
from pydantic import BaseModel
from app.schemas.history import History

from app.models.case import Diagnostic

# Shared properties
class CaseBase(BaseModel):
    pass


# Properties to receive on item creation
class CaseCreate(CaseBase):
    start_date: datetime


# Properties to receive on item update
class CaseUpdate(CaseBase):
    end_date: datetime
    diagnostic: Diagnostic


# Properties shared by models stored in DB
class CaseInDBBase(CaseBase):
    start_date: datetime
    end_date: Optional[datetime] = None
    diagnostic: Optional[Diagnostic] = None
    history: List[History] = []
    id: int
    owner_id: int

    class Config:
        orm_mode = True


# Properties to return to client
class Case(CaseInDBBase):
    pass


# Properties properties stored in DB
class CaseInDB(CaseInDBBase):
    pass
