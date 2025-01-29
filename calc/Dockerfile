FROM python:3.10
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

EXPOSE 80
EXPOSE 443

CMD ["sh", "-c", "uvicorn main:app --host 34.134.198.174 --port 8080"]
