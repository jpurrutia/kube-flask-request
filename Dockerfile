# Base Image
FROM python:3.11.4-slim-bullseye

# Metadata as described above
LABEL maintainer="JP Urrutia"
LABEL description="Python Flask API"

# Create directories
RUN mkdir -p /mlb-schedule/src

# Set the working directory
WORKDIR /mlb-schedule/src

# Copy requirements and install them
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application
COPY . .

# Environment variable
ENV APP_ENV development

# Expose port
EXPOSE 8080

# Command to run your application
CMD ["python", "app.py"]
