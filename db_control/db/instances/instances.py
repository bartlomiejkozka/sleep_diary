from db.settings import *
import regex as re
import bcrypt
from datetime import datetime, timedelta

class UserData:
    """
    This class is used to store the user data. It is used to create a new user in the database.
    It handles the validation and hashing of the user data.
    Also notes the time of creation of the user.
    """

    def __init__(self, user_payload: dict):
        # check the inputs
        try:
            self.firstname = self._validate_firstname(user_payload.get("firstname"))
            self.lastname = self._validate_lastname(user_payload.get("lastname"))
            self.username = self._validate_username(user_payload.get("username"))
            self.email = self._validate_email(user_payload.get("email"))
            self.password = self._validate_password(user_payload.get("password"))
        except ExceptionUserData as exception_ue:   # catching every other exception in order to raise a custom one
            raise ExceptionUserData(exception_ue.message, message="Error in UserData input validation.")

        try:
            self.password_hash= self._hash_password()
            self.time_created = generate_time_created()
        except ExceptionUserData as exception_utils:
            raise ExceptionUserData(exception_utils.message, message="Error in UserData utility functions.")


    def _validate_firstname(self, firstname: str) -> str:
        if len(firstname) > MAX_NAME_LENGTH:
            raise ExceptionUserData(message="Firstname too long.")
        if not firstname.isalpha():
            raise ExceptionUserData(message="Firstname not valid.")
        return firstname

    
    def _validate_lastname(self, lastname: str) -> str:
        if len(lastname) > MAX_NAME_LENGTH:
            raise ExceptionUserData(message="Lastname too long.")
        if not lastname.isalpha():
            raise ExceptionUserData(message="Lastname not valid.")
        return lastname

        
    def _validate_username(self, username: str) -> str:
        if re.match(USERNAME_REGEX, username) is None:
            raise ExceptionUserData(message="Username not valid.")
        return username
        

    def _validate_email(self, email: str) -> str:
        if re.match(EMAIL_REGEX, email) is None:
            raise ExceptionUserData(message="Email not valid.")
        return email

    def _validate_password(self, password: str) -> str:
        if re.match(PASSWORD_REGEX, password) is None:
            raise ExceptionUserData(message="Password not valid.")
        return password

    def _hash_password(self) -> str:
  
        bytes = self.password.encode('utf-8')
        salt = bcrypt.gensalt()
        hashed_password = bcrypt.hashpw(bytes, salt) 

        return hashed_password.decode("utf-8")

    def _generate_time_created(self) -> int:
        return datetime.now().strftime("%Y%m%d%H%M%S")
    

    def __str__(self):
        return '{"firstname": %s, "lastname": %s, "username": %s, "email": %s, "password": %s, "time_created": %s}' % (self.firstname, self.lastname, self.username, self.email, self.password, self.time_created)

    def json(self):
        return {
            "username": self.username,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "email": self.email
        }
    

class DreamData:

    def __init__(self, dream_payload: dict):
        self.content_original = self._validate_content_original(dream_payload.get("content_original"))
        self.content_translated = self._validate_content_translated(dream_payload.get("content_translated"))
        self.user_rate = self._validate_user_rate(dream_payload.get("user_rate"))
        self.img_b64 = self._validate_img_b64(dream_payload.get("img_b64"))
        self.time_created = generate_time_created()

    def _validate_content_original(self, content_original: str) -> str:
        return content_original

    def _validate_content_translated(self, content_translated: str) -> str:
        return content_translated

    def _validate_user_rate(self, user_rate: int) -> int:
        if user_rate < 0 or user_rate > 10:
            raise ExceptionDreamData(message="User rate not valid.")
        return user_rate

    def _validate_img_b64(self, img_b64: str) -> str:
        return img_b64
    
    def json(self):
        return {
            "content_original": self.content_original,
            "content_translated": self.content_translated,
            "user_rate": self.user_rate,
            "img_b64": self.img_b64,
            "time_created": self.time_created
        }




class ExceptionUserData(Exception):
    
    def __init__(self, *args, message: str):
        self.message = message
        self.args = args
        
    def __str__(self):
        return "UserData input not valid: \n" + self.message + "\n" + str(self.args)
    


class ExceptionDreamData(ExceptionUserData):

    def __init__(self, *args, message: str):
        super().__init__(*args, message=message)

    def __str__(self):
        return "DreamData input not valid: \n" + self.message + "\n" + str(self.args)

def check_password(password: str, hash: str) -> bool:
    bytes = password.encode('utf-8')
    hash = hash.encode("utf-8")
    return bcrypt.checkpw(bytes, hash)

def generate_time_created():
    return (datetime.now()).strftime("%Y-%m-%d")
    




    




    