from typing import Any, List
import datetime

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import crud, models, schemas
from app.api import deps

router = APIRouter()


@router.get("/", response_model=List[schemas.Patient])
def read_patients(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Retrieve patients.
    """
    patients = crud.patient.get_multi_by_owner(
        db=db, owner_id=current_user.id, skip=skip, limit=limit
    )
    return patients


@router.post("/", response_model=schemas.Patient)
def create_patient(
    *,
    db: Session = Depends(deps.get_db),
    patient_in: schemas.PatientCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Create new patient.
    """
    patient = crud.patient.create_with_owner(
        db=db, obj_in=patient_in, owner_id=current_user.id
    )
    return patient


@router.put("/{id}", response_model=schemas.Patient)
def update_patient(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    patient_in: schemas.PatientUpdate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Update an patient.
    """
    patient = crud.patient.get(db=db, id=id)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    if not crud.user.is_superuser(current_user) and (
        patient.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    patient = crud.patient.update(db=db, db_obj=patient, obj_in=patient_in)
    return patient


@router.get("/{id}", response_model=schemas.Patient)
def read_patient(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Get patient by ID.
    """
    patient = crud.patient.get(db=db, id=id)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    if not crud.user.is_superuser(current_user) and (
        patient.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    return patient


@router.get("/{id}/cases", response_model=List[schemas.Case])
def read_patient_cases(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    skip: int = 0,
    limit: int = 100,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    patient = crud.patient.get(db=db, id=id)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    if not crud.user.is_superuser(current_user) and (
        patient.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")

    cases = crud.case.get_multi_by_owner(
        db=db, owner_id=patient.id, skip=skip, limit=limit
    )
    return cases


@router.post("/{id}/cases", response_model=schemas.Case)
def get_or_create_case(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    skip: int = 0,
    limit: int = 100,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    patient = crud.patient.get(db=db, id=id)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    if not crud.user.is_superuser(current_user) and (
        patient.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")

    cases = crud.case.get_multi_by_owner(
        db=db, owner_id=patient.id, skip=skip, limit=limit
    )
    for case in cases:
        if case.end_date is None:
            return case
    now_date = datetime.datetime.now(datetime.timezone.utc)
    case = crud.case.create_with_owner(
        db=db,
        obj_in=schemas.CaseCreate(start_date=now_date.strftime('%Y-%m-%dT%H:%M:%S')+now_date.strftime('%z')[0:3]+":"+now_date.strftime('%z')[3:]),
        owner_id=patient.id,
    )
    return case


@router.put("/{patient_id}/cases/{case_id}", response_model=schemas.Case)
def close_case(
    *,
    db: Session = Depends(deps.get_db),
    patient_id: int,
    case_id: int,
    case_in: schemas.CaseUpdate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    print("looking for patient")
    patient = crud.patient.get(db=db, id=patient_id)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    if not crud.user.is_superuser(current_user) and (
        patient.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    print("patient found")
    case = crud.case.get(db=db, id=case_id)
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")
    if case.owner_id != patient.id:
        raise HTTPException(status_code=400, detail="Not enough permissions")
    print("case found")

    case = crud.case.update(
        db=db,
        db_obj=case,
        obj_in=schemas.CaseUpdate(
            end_date=case_in.end_date,
            diagnostic=case_in.diagnostic
        ),
    )
    return crud.case.get(db=db, id=case_id)


@router.post("/{patient_id}/cases/{case_id}/history", response_model=schemas.History)
def case_add_history(
    *,
    db: Session = Depends(deps.get_db),
    patient_id: int,
    case_id: int,
    history_in: schemas.HistoryCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    patient = crud.patient.get(db=db, id=patient_id)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    if not crud.user.is_superuser(current_user) and (
        patient.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")

    case = crud.case.get(db=db, id=case_id)
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")
    if case.owner_id != patient.id:
        raise HTTPException(status_code=400, detail="Not enough permissions")

    history = crud.history.create_with_owner(db=db, obj_in=history_in, owner_id=case.id)
    return history


@router.delete("/{id}", response_model=schemas.Patient)
def delete_patient(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Delete an patient.
    """
    patient = crud.patient.get(db=db, id=id)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    if not crud.user.is_superuser(current_user) and (
        patient.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    patient = crud.patient.remove(db=db, id=id)
    return patient
