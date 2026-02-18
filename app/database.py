from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session

# USUARIO: finanzas
# CONTRASEÑA: finanzas$616
# NOMBRE_DB: finanzas_db
SQLALCHEMY_DATABASE_URL = "postgresql://finanzas:finanzas$616@localhost:5432/finanzas_db"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
session = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = session()
    try:
        yield db
    finally:
        db.close()
