import enum

from sqlalchemy import Column, Integer, Enum, String, ForeignKey
from sqlalchemy.orm import relationship

from app.db.base_class import Base


class Diagnostic(int, enum.Enum):
    COVID19 = 1
    Influenza = 2
    CommonCold = 3
    Tuberculosis = 4
    LungCancer = 5
    COVIDPneumonia = 6
    PneumoniaOther = 7
    BrainTumor = 8


class Case(Base):
    id = Column(Integer, primary_key=True, index=True)
    start_date = Column(String)
    end_date = Column(String)
    diagnostic = Column(Enum(Diagnostic))
    history = relationship("History", back_populates="owner")
    owner_id = Column(Integer, ForeignKey("patient.id"))
    owner = relationship("Patient", back_populates="cases")
