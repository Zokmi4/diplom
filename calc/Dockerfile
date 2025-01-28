# Указываем базовый образ
FROM python:3.10

# Устанавливаем зависимости
WORKDIR /app
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install python-multipart

# Устанавливаем Nginx и копируем конфигурационный файл
RUN apt-get update && apt-get install -y nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Копируем файлы приложения в контейнер
COPY . /app

# Открываем порты и запускаем Nginx вместе с приложением
CMD service nginx start && uvicorn main:app --host 0.0.0.0 --port 8080
