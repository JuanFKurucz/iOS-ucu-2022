from typing import Any, List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import crud, models, schemas
from app.api import deps

router = APIRouter()


@router.get("/", response_model=List[schemas.Case])
def read_cases(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Retrieve cases.
    """
    cases = crud.case.get_multi_by_owner(
        db=db, owner_id=current_user.id, skip=skip, limit=limit
    )
    return cases


@router.post("/", response_model=schemas.Case)
def create_case(
    *,
    db: Session = Depends(deps.get_db),
    case_in: schemas.CaseCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Create new case.
    """
    case = crud.case.create_with_owner(db=db, obj_in=case_in, owner_id=current_user.id)
    return case


@router.put("/{id}", response_model=schemas.Case)
def update_case(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    case_in: schemas.CaseUpdate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Update an case.
    """
    case = crud.case.get(db=db, id=id)
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")
    if not crud.user.is_superuser(current_user) and (case.owner_id != current_user.id):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    case = crud.case.update(db=db, db_obj=case, obj_in=case_in)
    return case


@router.get("/{id}", response_model=schemas.Case)
def read_case(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Get case by ID.
    """
    case = crud.case.get(db=db, id=id)
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")
    if not crud.user.is_superuser(current_user) and (case.owner_id != current_user.id):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    return case


@router.get("/current", response_model=schemas.Case)
def current_case(
    *,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Get case by ID.
    """
    case = crud.case.get(db=db, id=id)
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")
    if not crud.user.is_superuser(current_user) and (case.owner_id != current_user.id):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    return case


@router.delete("/{id}", response_model=schemas.Case)
def delete_case(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Delete an case.
    """
    case = crud.case.get(db=db, id=id)
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")
    if not crud.user.is_superuser(current_user) and (case.owner_id != current_user.id):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    case = crud.case.remove(db=db, id=id)
    return case
