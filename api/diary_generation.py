import os
import base64
import logging
from logging.handlers import RotatingFileHandler
from pathlib import Path
from dotenv import load_dotenv
import aiohttp
import fastapi
import httpx
# from langchain_community.llms import Ollama
from langchain_openai import ChatOpenAI
from langchain_core.output_parsers.string import StrOutputParser
from langchain.prompts import PromptTemplate
from pydantic import BaseModel
from fastapi import FastAPI
# import uvicorn

MAX_BYTES = 20000
MAX_ROTATE = 5
LOGGING_LEVEL = logging.INFO
LOGGING_DIRECTORY = Path(__file__).parent / "logs"
LOGGING_DIRECTORY.mkdir(exist_ok=True)
DEFAULT_LOGGING_FILE = LOGGING_DIRECTORY / "api.logs"
# config parser
load_dotenv()
HF_KEY = os.environ["HF_KEY"]

# image generation details
API_URL = "https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-schnell"
headers = {"Authorization": HF_KEY}


class Logger:
    def __init__(self, logging_file: str | Path):
        self.logging_file = Path(logging_file)
        self.logger = logging.getLogger("API_LOGGER")
        self.logger.setLevel(LOGGING_LEVEL)
        _handler = RotatingFileHandler(self.logging_file, maxBytes=20000, backupCount=MAX_ROTATE)
        _formatter = logging.Formatter("%(asctime)s [%(levelname)s] - %(message)s", "%Y-%m-%d %H:%M:%S")
        _handler.setFormatter(_formatter)
        self.logger.addHandler(_handler)

    def log_exception(self, error: BaseException, msg: str = None):
        """
        Logs exception with an optional message

        :param error: Exception to be logged
        :type error: BaseException
        :param msg: Optional message to be logged
        :type msg: str
        :return: Nothing
        :rtype: None
        """
        self.logger.error("")
        self.logger.exception(error)
        self.logger.error(msg)
        self.logger.error("")

    def log_message(self, msg: str):
        """
        Logs info message

        :param msg: Message to be logged
        :type msg: str
        :return: Nothing
        :rtype: None
        """
        self.logger.info("")
        self.logger.info(msg)
        self.logger.info("")

    def log_error(self, msg: str):
        """
        Logs error message

        :param msg: Message to be logged
        :type msg: str
        :return: Nothing
        :rtype: None
        """
        self.logger.error("")
        self.logger.error(msg)
        self.logger.error("")


PROMPT = PromptTemplate(template="""
You will receive a dream description and a sentiment score (1-10), where 1 represents a nightmare and 10 represents a 
sweet dream. Based on this, generate a 5-sentence short story with a title.

Instructions:
- Only output the title and the story.
- The story should reflect the dream's sentiment based on the provided score.

Dream Description: {description}
Sentiment: {sentiment}
-------------
Title:
Story:
""")

# llm = Ollama(model="llama3")
llm = ChatOpenAI(model="gpt-4o")
app = FastAPI()


class DreamInput(BaseModel):
    description: str
    sentiment: int


chain = PROMPT | llm | StrOutputParser()
logger = Logger(DEFAULT_LOGGING_FILE)


async def generate_image(description: str):
    async with aiohttp.ClientSession() as session:
        async with session.post(API_URL, headers=headers, json={"inputs": description}) as response:
            if response.status == 200:
                content = await response.read()
                b64_encoded = base64.b64encode(content)
                return b64_encoded.decode('utf-8')
            else:
                logger.log_error(f"Failed to get a response. Status code: {response.status}")
                raise Exception(f"Failed to get a response. Status code: {response.status}")


@app.post("/generate_story/")
async def generate_story(input_data: DreamInput):
    logger.log_message(f"Received call from {fastapi.Request.client}")
    try:
        result = await chain.ainvoke({"description": input_data.description, "sentiment": input_data.sentiment})
        if "explicit" in result:
            logger.log_error("Explicit content in the given phrase happened")
            return fastapi.HTTPException(403, "You cannot provide explicit phrases")
        if len(result.split("\n\n")) != 2:
            logger.log_error("The given phrase was not correct")
            return fastapi.HTTPException(400, "You have to provide a correct phrase")
        title, story = result.split("\n\n")
        image = await generate_image(title)
        logger.log_message("Sending generated data to UI")

        async with httpx.AsyncClient() as client:
            # Example request to another service
            response = await client.post("http://127.0.0.1:10200/",
                                         json={"title": title, "story": story})
            if response.status_code != 200:
                logger.log_error("Failed to communicate with another service")
                raise fastapi.HTTPException(status_code=response.status_code,
                                            detail="Failed to get response from external service")

        return {"title": title, "story": story, "image": image}
    except fastapi.HTTPException as e:
        logger.log_exception(e, "HTTP exception occurred")
        raise
    except ValueError as e:
        logger.log_exception(e, "Value error occurred")
        raise fastapi.HTTPException(status_code=400, detail="Invalid input values")
    except Exception as e:
        logger.log_exception(e, "An unexpected error occurred.")
        raise fastapi.HTTPException(status_code=500, detail="There was an internal server error")
    except Exception as e:
        logger.log_exception(e)
        return fastapi.HTTPException(500, "There was an internal server error")


if __name__ == '__main__':
    logger.log_message("Starting the service")
    # uvicorn.run(app, host="127.0.0.1", port=8000)
