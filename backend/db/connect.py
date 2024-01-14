from backend.env import config
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

db_config = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'password',
    'database': 'Test'
}

FLIGHT_PRICES_DATABASE_URL = f"mariadb+mariadbconnector://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['database']}"
DATABASE_URL = config("FLIGHT_PRICES_DATABASE_URL", cast=str, default=None)
DATABASE_URL is not None

engine = create_engine(str(DATABASE_URL))
SessionLocal = sessionmaker(bind=engine)

def get_db_session():
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()
