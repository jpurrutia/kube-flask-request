FROM python:3.11.4-slim-bullseye

# Working Directory
WORKDIR /app

# Copy source code to working directory
COPY . app.py /app/

# Install packages from requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]