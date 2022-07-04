from email.policy import default
import enum

from sqlalchemy import Column, Integer, Enum, String, ForeignKey, Boolean
from sqlalchemy.orm import relationship

from app.db.base_class import Base


class Symptom(int, enum.Enum):
    Fever = 1
    DryCough = 2
    Rhinorrhea = 3
    Dyspnea = 4
    Fatigue = 5
    MusclePain = 6
    ChestPain = 7
    Anosmia = 8
    Dysgeusia = 9
    KidneyFailure = 10
    Myocarditis = 11
    Hemoptisis = 12
    Headache = 13


class History(Base):
    id = Column(Integer, primary_key=True, index=True)
    date = Column(String)
    symptom = Column(Enum(Symptom))
    state = Column(Boolean,default=True)
    owner_id = Column(Integer, ForeignKey("case.id"))
    owner = relationship("Case", back_populates="history")
