from typing import List

from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.history import History
from app.schemas.history import HistoryCreate, HistoryUpdate


class CRUDHistory(CRUDBase[History, HistoryCreate, HistoryUpdate]):
    def create_with_owner(
        self, db: Session, *, obj_in: HistoryCreate, owner_id: int
    ) -> History:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data, owner_id=owner_id)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def get_multi_by_owner(
        self, db: Session, *, owner_id: int, skip: int = 0, limit: int = 100
    ) -> List[History]:
        return (
            db.query(self.model)
            .filter(History.owner_id == owner_id)
            .offset(skip)
            .limit(limit)
            .all()
        )


history = CRUDHistory(History)
