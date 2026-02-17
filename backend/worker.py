from celery import Celery
import time
import os
from dotenv import load_dotenv

# ✅ Load environment variables from .env
load_dotenv()

# ✅ Get Redis URL from environment
REDIS_URL = os.getenv("REDIS_URL")

# Optional debug (you can remove later)
print("Using REDIS_URL:", REDIS_URL)

# ✅ Configure Celery using env variable (NO hardcoding)
celery = Celery(
    "worker",
    broker=REDIS_URL,
    backend=REDIS_URL,
)


@celery.task
def write_log_celery(message: str):
    time.sleep(10)
    with open("log_celery.txt", "a") as f:
        f.write(f"{message}\n")
    return f"Task completed: {message}"
