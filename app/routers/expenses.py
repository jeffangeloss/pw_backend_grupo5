from fastapi import Depends, HTTPException, APIRouter
from sqlalchemy.orm import Session
from datetime import datetime

from ..models import Expense, User
from ..database import get_db
from ..schemas import expenseUpdate
from ..main import get_current_user

router = APIRouter(
    prefix="/expenses",
    tags = ["Expenses"]
)

## endpoint CREATE (REQ 12)

## endpoint RETRIEVE ALL + OPTIONAL QUERY PARAMS (REQ 13 y REQ 17)
@router.get("/")
async def get_expenses(
    current_user : User,
    ## deben implementarse mas filtros opcionales
    db : Session = Depends(get_db)
    
):
    db_query = db.query(Expense).filter(Expense.user_id == current_user.id)

    ## aplicar filtros al query de manera correspondiente 

    ## ordenar de mas reciente a mas antiguo
    db_query = db_query.order_by(Expense.expense_date.desc())

    expenses_list = db_query.all()

    return {
        "msg" : "",
        "data": expenses_list
    }

## endpoint UPDATE (REQ 14)

@router.put("/{expense_id}")
async def update_expense(
    expense_id: str,
    payload: expenseUpdate,
    db: Session = Depends(get_db),
    current_user: Session = Depends(get_current_user)
):
    expense = (
        db.query(Expense)
        .filter(
            Expense.id == expense_id,
            Expense.user_id == current_user.id
        ).first()
    )
    
    if not expense:
        raise HTTPException(
            status_code=404,
            detail="Egreso no encontrado"
        )
    
    if payload.amount != None:
        expense.amount = payload.amount
    
    if payload.category_id != None:
        expense.category_id = payload.category_id

    if payload.expense_date != None:
        expense.expense_date = payload.expense_date

    if payload.description != None:
        expense.description = payload.description
        
    expense.updated_at = datetime.utcnow()
    
    db.commit()
    db.refresh(expense)
    
    return {
        "msg" : "Egreso actualizado",
        "expense_id" : expense.id
    }

## endpoint DELETE (REQ 15)