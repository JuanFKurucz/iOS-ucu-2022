import app.pysmile_license
import pysmile

from typing import List, Dict, Any
from fastapi import APIRouter

from app import schemas
from app.schemas import Prediction
from app.models.case import Diagnostic
from app.models.history import Symptom
import random

router = APIRouter()

VERSION = "0.1"
ENCODING = "UTF-8"
NETWORK_FILE = "covid.xdsl"

targets=[
    "COVID19",
    "Influenza",
    "CommonCold",
    "Tuberculosis",
    "LungCancer",
    "COVIDPneumonia",
    "PneumoniaOther",
    "BrainTumor"
]

@router.get("/statistics")
def statistics() -> Any:
    stats = {
        "diagnostics":{},
        "symptoms":{}
    }

    for diag in Diagnostic:
        stats["diagnostics"][diag.value] = random.randint(0,100)
    for sym in Symptom:
        stats["symptoms"][sym.value] = random.randint(0,100)

    return stats

@router.post("/", response_model=schemas.Prediction)
def predict(evidence: Dict[str,str], target: List[str] = None) -> Any:
    net = pysmile.Network()
    net.read_file(NETWORK_FILE)

    for name, value in evidence.items():
        try:
            net.set_evidence(name, value)
        except:
            return {"error":f"Evidence with id {name} does not exist"}

    net.update_beliefs()

    if target is None:
        target=targets
    
    higher_diagnosis = None
    max_prob = 0
    for t in target:
        prob = net.get_node_value(t)
        if prob[0] > max_prob:
            higher_diagnosis = Prediction(diagnostic=Diagnostic[t])
            max_prob = prob[0]

    return higher_diagnosis

