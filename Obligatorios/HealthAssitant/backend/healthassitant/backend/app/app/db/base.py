# Import all the models, so that Base has them before being
# imported by Alembic
from app.db.base_class import Base  # noqa
from app.models.history import History  # noqa
from app.models.case import Case  # noqa
from app.models.patient import Patient  # noqa
from app.models.user import User  # noqa
