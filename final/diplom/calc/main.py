from fastapi import FastAPI, Form, Request
from fastapi.responses import HTMLResponse
from jinja2 import Environment, FileSystemLoader

app = FastAPI()
env = Environment(loader=FileSystemLoader("templates"))

# Функция для выполнения арифметических операций
def perform_operation(a: float, b: float, operation: str) -> str:
    if operation == "add":
        return f"Результат сложения: {a + b}"
    elif operation == "subtract":
        return f"Результат вычитания: {a - b}"
    elif operation == "multiply":
        return f"Результат умножения: {a * b}"
    elif operation == "divide":
        if b == 0:
            return "Ошибка: Деление на ноль"
        else:
            return f"Результат деления: {a / b}"
    else:
        return "Неверная операция"

# Главная страница
@app.get("/", response_class=HTMLResponse)
async def read_root():
    template = env.get_template("index.html")
    return template.render(result="")

# Обработка формы
@app.post("/calculate", response_class=HTMLResponse)
async def calculate(
    a: float = Form(...),
    b: float = Form(...),
    operation: str = Form(...)
):
    result = perform_operation(a, b, operation)
    template = env.get_template("index.html")
    return template.render(result=result)
