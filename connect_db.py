from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

load_dotenv()

def get_connection():
    DB_HOST     = os.getenv("DB_HOST", "localhost")
    DB_NAME     = os.getenv("DB_NAME")
    DB_USER     = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_PORT     = os.getenv("DB_PORT", "5432")

    engine = create_engine(
        f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )
    return engine

# Test connection
if __name__ == "__main__":
    engine = get_connection()
    print("✅ Connected successfully!")  