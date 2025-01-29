FROM python:3.10

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app


EXPOSE 8000

# Запускаем Uvicorn
CMD ["uvicorn", "main:app", "--host", "34.134.298.174", "--port", "8000"]
