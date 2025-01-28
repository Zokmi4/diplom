# Указываем базовый образ
FROM python:3.10

# Устанавливаем зависимости
WORKDIR /app
COPY requirements.txt .

# Устанавливаем зависимости из requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Устанавливаем python-multipart отдельно, если он отсутствует в requirements.txt
RUN pip install python-multipart

# Копируем файлы приложения в контейнер
COPY . /app

# Запускаем приложение
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
