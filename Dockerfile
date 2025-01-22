# Base image for the operating system
FROM python:3.8

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy all files from the local directory to the container
COPY . .

# Install required Python libraries
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the application will listen on
EXPOSE 5000

# Command to run the application
CMD ["python", "./app.py"]
