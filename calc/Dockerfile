FROM python:3.10

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app


EXPOSE 8080

# Запускаем Uvicorn
CMD ["uvicorn", "main:app", "--host", "10.128.0.23", "--port", "8080"]
