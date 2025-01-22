from flask import Flask, render_template
from sqlalchemy import create_engine, text
import os
import random
from dotenv import load_dotenv

# Load environment variables from the .env file
load_dotenv()

app = Flask(__name__)

# Read environment variables
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST", "mysql")  # Default to "mysql" if not set
DB_PORT = os.getenv("DB_PORT", "3306")   # Default to "3306" if not set
DB_NAME = os.getenv("DB_NAME", "mydatabase")  # Default to "mydatabase" if not set

# MySQL connection string
DB_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(DB_URL)


@app.route("/")
def index():
    with engine.connect() as connection:
        # Retrieve all image URLs from the database
        result = connection.execute(text("SELECT image_url FROM images"))
        images = [row["image_url"] for row in result]

        # Select a random image from the list
        url = random.choice(images)

        # Update the visitor count in the database
        connection.execute(text("UPDATE visit_count SET count = count + 1"))

        # Retrieve the updated visitor count
        result = connection.execute(text("SELECT count FROM visit_count"))
        visitor_count = result.fetchone()["count"]

    return render_template("index.html", url=url, visitor_count=visitor_count)


if __name__ == "__main__":
    # Run the Flask app on 0.0.0.0 to make it accessible externally
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))