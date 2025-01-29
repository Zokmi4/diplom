FROM python:3.10
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install python-multipart

RUN apt-get update && apt-get install -y nginx openssl

COPY . /app
COPY nginx.conf /etc/nginx/nginx.conf

COPY nginx-selfsigned.crt /etc/ssl/certs/
COPY nginx-selfsigned.key /etc/ssl/private/
COPY dhparam.pem /etc/ssl/certs/

EXPOSE 80
EXPOSE 443

CMD ["sh", "-c", "service nginx start && uvicorn main:app --host 34.134.198.174 --port 8080"]
