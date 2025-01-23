# Dockerfile
FROM python:3.14.0a1-slim

WORKDIR /app

COPY app/ /app

RUN pip install flask

EXPOSE 8080

CMD ["python", "main.py"]
