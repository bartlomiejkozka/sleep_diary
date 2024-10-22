import os
from flask import Flask, request, jsonify
import sqlalchemy
from db_init.db_init import Users, Dreams, dream_to_json
from db.instances.instances import UserData, DreamData, ExceptionUserData, ExceptionDreamData, check_password
from datetime import datetime, timedelta

app = Flask(__name__)

POSTGRES_ENDPOINT = os.getenv("POSTGRES_ENDPOINT")
LOCAL_ENDPOINT = os.getenv("LOCAL_ENDPOINT")


def get_streak(dream_dates: list) -> int:
        if not dream_dates:
            return 0

        dream_dates = [datetime.strptime(date, "%Y-%m-%d") for date in dream_dates]
        dream_dates.sort()

        if not datetime.strptime(datetime.now().strftime("%Y-%m-%d"), "%Y-%m-%d") in dream_dates:
            print(datetime.strptime(datetime.now().strftime("%Y-%m-%d"), "%Y-%m-%d"))
            print(dream_dates)
            return 0

        streak = 1

        for i in range(1, len(dream_dates)):
            difference = dream_dates[i] - dream_dates[i - 1]
            if difference == timedelta(days=1):
                streak += 1
            elif difference == timedelta(days=0):
                continue
            else:
                return streak
        return streak


def db_connection():
    engine = sqlalchemy.create_engine(POSTGRES_ENDPOINT)
    Session = sqlalchemy.orm.sessionmaker(bind=engine)
    session = Session()
    return session


@app.route("/users", methods=["GET", "POST"])
def users():
    if request.method == "GET": # returning if the user is valid and password is correct
        try:
            user_username= request.args.get("username")
            user_password = request.args.get("password")
            db_session = db_connection()
            user = db_session.query(Users).filter(Users.username == user_username).first()

            all_dreams = db_session.query(Dreams).filter(Dreams.user_id == user.id).all()
            dream_dates = [dream.time_created for dream in all_dreams]
            print(dream_dates)
            streak = get_streak(dream_dates)

            if check_password(user_password, user.password_hashed): # compares bcrypted password with the one in the database
                # correct return
                return jsonify({"username": user.username, "firstname": user.firstname, "lastname": user.lastname, "email": user.email, "streak": streak}), 200
        except Exception as exception:
            return jsonify({"message": "Invalid username or password.", "exception": str(exception)}), 400
        return jsonify({"message": f"GET /users {user.username}"}), 400

    elif request.method == "POST":  # creating a new user
        user_params = request.json
        try:
            user_data = UserData(user_params)   # validation and data transformation
        
            new_user = Users( # new user object
                username=user_data.username,
                firstname=user_data.firstname,
                lastname=user_data.lastname,
                email=user_data.email,
                password_hashed=user_data.password_hash,
                time_created=user_data.time_created
            ) 
            try:
                db_session = db_connection()
                db_session.add(new_user)    # adding the user
                db_session.commit()

                return jsonify(user_data.json()), 201
            except Exception as exception_connection:
                print(exception_connection)
                return jsonify({"message": "Database connection error."}), 500
            finally:
                db_session.close()
        except ExceptionUserData as exception_ue:
            print(exception_ue)
            return jsonify({"message": exception_ue.message}), 400



@app.route("/dreams", methods=["GET", "POST"])
def dreams():
    if request.method == "GET":
        username = request.args.get("username")
        time_created = request.args.get("time_created")
        if not username:
            raise ExceptionDreamData("keyword missing: username", message="Username not provided.")
        
        db_session = db_connection()
        user_id = db_session.query(Users).filter(Users.username == username).first().id
        dream = db_session.query(Dreams).filter(Dreams.user_id == user_id).filter(Dreams.time_created == time_created).first()
        return jsonify(dream_to_json(dream)), 200

    elif request.method == "POST":
        dream_params = request.json
        try:
            dream_data = DreamData(dream_params)
            try:
                username = dream_params.get("username")
                if not username:
                    raise ExceptionDreamData("keyword missing: username", message="Username not provided.")
                db_session = db_connection()
                user_id = db_session.query(Users).filter(Users.username == username).first().id
            except Exception as exception_connection_id:
                print(exception_connection_id)
                return jsonify({"message": "Database connection error."}), 500

        
            new_dream = Dreams(
                user_id=user_id,
                content_original=dream_data.content_original,
                content_translated=dream_data.content_translated,
                user_rate=dream_data.user_rate,
                img_b64=dream_data.img_b64,
                time_created=dream_data.time_created
            )
            try:
                db_session.add(new_dream)
                db_session.commit()

                return jsonify(dream_data.json()), 201
            except Exception as exception_connection:
                print(exception_connection)
                return jsonify({"message": "Database add Dream error."}), 500
            finally:
                db_session.close()
        except ExceptionDreamData as exception_de:
            print(exception_de)
            return jsonify({"message": exception_de.message}), 400