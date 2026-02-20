from fastapi import Depends, HTTPException, APIRouter
from sqlalchemy.orm import Session

from ..models import Expense, User
from ..database import get_db

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

## endpoint DELETE (REQ 15)