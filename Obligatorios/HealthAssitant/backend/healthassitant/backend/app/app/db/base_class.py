from typing import Any

from sqlalchemy.ext.declarative import as_declarative, declared_attr


@as_declarative()
class Base:
    id: Any
    __name__: str
    # __table_args__ = { 'useexisting': True }
    __table_args__ = {"extend_existing": True}
    # Generate __tablename__ automatically
    @declared_attr
    def __tablename__(cls) -> str:
        print(cls, cls.__name__.lower())
        return cls.__name__.lower()
