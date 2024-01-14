from backend.env import config
import requests

def get_mindsdb_session():
    session = 'http://127.0.0.1:47334'
    try:
        yield session
    finally:
        session.close()
