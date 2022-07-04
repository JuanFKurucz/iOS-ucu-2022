from typing import List
from pydantic import BaseModel

from app.models.case import Diagnostic

# Shared properties
class Prediction(BaseModel):
    diagnostic: Diagnostic