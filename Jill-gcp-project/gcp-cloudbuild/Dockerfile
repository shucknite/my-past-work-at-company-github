# Dockerfile
FROM python:3.13.2-slim

WORKDIR /app

COPY app/ /app

RUN pip install flask

EXPOSE 8080

CMD ["python", "main.py"]
