import os
from sqlalchemy import Column, Integer, String, Date, ForeignKey, create_engine
from sqlalchemy.orm import declarative_base, sessionmaker, relationship
import psycopg2
from dotenv import load_dotenv

load_dotenv()

MAX_NAME_LENGTH = 32
POSTGRES_ENDPOINT = os.getenv("POSTGRES_ENDPOINT")
LOCAL_ENDPOINT = os.getenv("LOCAL_ENDPOINT")

Base = declarative_base()

class Users(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    username = Column(String(MAX_NAME_LENGTH), nullable=False, unique=True)
    firstname = Column(String(MAX_NAME_LENGTH), nullable=False)
    lastname = Column(String(MAX_NAME_LENGTH), nullable=False)
    email = Column(String(), nullable=False, unique=True)
    password_hashed = Column(String(), nullable=False)
    profile_b64 = Column(String(), nullable=True)
    time_created = Column(String(10), nullable=False)

    dreams = relationship("Dreams", back_populates="users")


class Dreams(Base):
    __tablename__ = "dreams"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    content_original = Column(String(), nullable=False)
    content_translated = Column(String(), nullable=False)
    user_rate = Column(Integer, nullable=False)
    img_b64 = Column(String(), nullable=False)
    time_created = Column(String(10), nullable=False)

    users = relationship("Users", back_populates="dreams")


def create_database(name: str = "DreamsDB"):
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="password",
        host="localhost",
        port="5432"
    )
    conn.autocommit = True
    cursor = conn.cursor()
    cursor.execute(f'CREATE DATABASE "{name}"')
    cursor.close()
    conn.close()


def dream_to_json(dream: Dreams) -> dict:
    return {
        "content_original": dream.content_original,
        "content_translated": dream.content_translated,
        "user_rate": dream.user_rate,
        "img_b64": dream.img_b64,
        "time_created": dream.time_created
    }


if __name__ == "__main__":
    engine = create_engine(POSTGRES_ENDPOINT)
    #create_database()
    Base.metadata.create_all(engine)
    #Base.metadata.drop_all(engine, tables=[Users.__table__, Dreams.__table__])
    #session = sessionmaker(bind=engine)()
    # users = session.query(Users).filter(Users.password_hashed == "password").all()
    # for user in users:
    #     session.delete(user)
    # session.add(user1)
    # session.commit()
    # session.close()




# get the date and return the dream
# streak