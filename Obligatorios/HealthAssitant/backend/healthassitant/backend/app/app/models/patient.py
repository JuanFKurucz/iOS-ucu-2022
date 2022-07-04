import enum

from sqlalchemy import Column, Integer, String, Enum, String, ForeignKey
from sqlalchemy.orm import relationship

from app.db.base_class import Base


class Gender(int, enum.Enum):
    Male = 1
    Female = 2


class Patient(Base):
    id = Column(Integer, primary_key=True, index=True)
    code = Column(String, index=True)
    full_name = Column(String, index=True)
    gender = Column(Enum(Gender))
    birth_date = Column(String)
    cases = relationship("Case", back_populates="owner")
    owner_id = Column(Integer, ForeignKey("user.id"))
    owner = relationship("User", back_populates="patients")
