from fastapi import FastAPI, Form
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from jinja2 import Environment, FileSystemLoader

app = FastAPI()

# Подключаем статические файлы
app.mount("/static", StaticFiles(directory="static"), name="static")

# Инициализация Jinja2
env = Environment(loader=FileSystemLoader("templates"))

@app.get("/", response_class=HTMLResponse)
async def read_root():
    template = env.get_template("index.html")
    return template.render(result="")

@app.post("/calculate", response_class=HTMLResponse)
async def calculate(a: float = Form(...), b: float = Form(...), operation: str = Form(...)):
    if operation == "add":
        result = a + b
    elif operation == "subtract":
        result = a - b
    elif operation == "multiply":
        result = a * b
    elif operation == "divide":
        if b == 0:
            result = "Error: Division by zero"
        else:
            result = a / b
    else:
        result = "Invalid operation"
    
    template = env.get_template("index.html")
    return template.render(result=result)
