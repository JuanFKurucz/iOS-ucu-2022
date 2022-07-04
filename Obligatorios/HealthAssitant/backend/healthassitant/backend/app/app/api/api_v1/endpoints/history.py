from typing import Any, List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import crud, models, schemas
from app.api import deps

router = APIRouter()


@router.get("/", response_model=List[schemas.History])
def read_historys(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Retrieve historys.
    """
    historys = crud.history.get_multi_by_owner(
        db=db, owner_id=current_user.id, skip=skip, limit=limit
    )
    return historys


@router.post("/", response_model=schemas.History)
def create_history(
    *,
    db: Session = Depends(deps.get_db),
    history_in: schemas.HistoryCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Create new history.
    """
    history = crud.history.create_with_owner(
        db=db, obj_in=history_in, owner_id=current_user.id
    )
    return history


@router.put("/{id}", response_model=schemas.History)
def update_history(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    history_in: schemas.HistoryUpdate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Update an history.
    """
    history = crud.history.get(db=db, id=id)
    if not history:
        raise HTTPException(status_code=404, detail="History not found")
    if not crud.user.is_superuser(current_user) and (
        history.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    history = crud.history.update(db=db, db_obj=history, obj_in=history_in)
    return history


@router.get("/{id}", response_model=schemas.History)
def read_history(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Get history by ID.
    """
    history = crud.history.get(db=db, id=id)
    if not history:
        raise HTTPException(status_code=404, detail="History not found")
    if not crud.user.is_superuser(current_user) and (
        history.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    return history


@router.delete("/{id}", response_model=schemas.History)
def delete_history(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Delete an history.
    """
    history = crud.history.get(db=db, id=id)
    if not history:
        raise HTTPException(status_code=404, detail="History not found")
    if not crud.user.is_superuser(current_user) and (
        history.owner_id != current_user.id
    ):
        raise HTTPException(status_code=400, detail="Not enough permissions")
    history = crud.history.remove(db=db, id=id)
    return history
