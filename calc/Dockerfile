# Указываем базовый образ
FROM python:3.10

# Устанавливаем зависимости
WORKDIR /app
COPY requirements.txt .

# Добавьте python-multipart в requirements.txt, если его нет
RUN pip install --no-cache-dir -r requirements.txt

# Или установите python-multipart прямо
RUN pip install python-multipart

# Копируем файлы приложения в контейнер
COPY . /app

# Запускаем приложение
CMD ["uvicorn", "main:app", "--host", "34.132.154.216", "--port", "8080"
