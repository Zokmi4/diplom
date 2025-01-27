from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from jinja2 import Environment, FileSystemLoader

app = FastAPI()

# Подключаем статические файлы
app.mount("/static", StaticFiles(directory="static"), name="static")

# Инициализация Jinja2
env = Environment(loader=FileSystemLoader("templates"))

# Пример списка котиков
cats = [
    {"url": "https://placekitten.com/400/300"},
    {"url": "https://placekitten.com/401/300"},
    {"url": "https://placekitten.com/402/300"},
    {"url": "https://placekitten.com/403/300"}
]

@app.get("/", response_class=HTMLResponse)
async def read_root():
    template = env.get_template("index.html")
    return template.render(cats=cats)

# Запуск сервера
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
