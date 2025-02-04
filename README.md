# Автоматизация деплоя с использованием Ansible, Jenkins и Kubernetes

## Окружение

Используются 3 виртуальные машины на базе Google Cloud:  
Предварительно, их можно поднять с помощью Terraform. Файл `terraform.tf` прилагается.

- **34.56.209.145** (Dev-server): Docker, Docker Compose, Jenkins Agent 1  
- **34.134.198.174** (Prod-server): Jenkins Server  
- **34.41.24.58** (Test-server): Docker, Docker Compose, k3s, Helm, Jenkins Agent 2  

![gcloud](https://github.com/Zokmi4/diplom/blob/main/images/gloud.png)

### Скачивание репозитория

Клонируем репозиторий по ссылке и переходим в директорию ansible:  
**[https://github.com/Zokmi4/diplom.git](https://github.com/Zokmi4/diplom.git)**
cd /diplom/ansible
---
### Установка основной инфраструктуры (Docker, Docker Compose, Jenkins, k3s, Helm)

```bash
ansible-playbook -i hosts playbook.yml
```

Настраиваем Jenkins, после чего он будет доступен по адресу:  
**[http://34.41.24.58:8080/](http://34.41.24.58:8080/)**  

![jenkins](https://github.com/Zokmi4/diplom/blob/main/images/jenkins.png)

---

### Установка системы мониторинга (Grafana + Prometheus + Alertmanager)

```bash
ansible-playbook -i hosts graf+prom+alert.yml
```

### Установка Node Exporter на все 3 машины

```bash
ansible-playbook -i hosts node_ex.yml
```

---

## Настройка Grafana и Prometheus

1. Подключаемся к Grafana по адресу: **[http://34.56.209.145:3000](http://34.56.209.145:3000)**  
2. Входим в систему (по умолчанию: **admin/admin**) и меняем пароль.  
3. Добавляем источник данных Prometheus:  
   - **URL:** [http://34.56.209.145:9090/](http://34.56.209.145:9090/)
   - **Save & Test**
4. Устанавливаем дашборд с ID **1860**:
   - Переходим в **Dashboards** → **Import**
   - Вводим `1860` и нажимаем **Load**
   - Выбираем источник данных Prometheus и нажимаем **Import**

Теперь у нас доступен мониторинг всех 3 машин.  

![grafana](https://github.com/Zokmi4/diplom/blob/main/images/grafana.png)

---

## Установка rsyslog для логирования

```bash
ansible-playbook -i hosts rsyslog.yml
```

Rsyslog имеет структуру клиент-сервер.  
Prod и Test сервера отправляют логи на Dev машину.  
Логи записываются в отдельный файл и в общий. Для проверки отправляем c клиента сообщения по команде:

```bash
logger -n 10.128.0.22 -P 514 -T "Любой текст"
```

![rsyslog](https://github.com/Zokmi4/diplom/blob/main/images/rsyslog.png)

---

## Настройка Jenkins и агентов

Агенты устанавливаются вручную:

- **Agent 1** (Dev-server) — отвечает за сборку сервиса в Docker и отправку его в Docker Hub.
- **Agent 2** (Prod-server) — отвечает за скачивание образа из Docker Hub и деплой сервиса в k3s.

---

## CI/CD Pipeline в Jenkins

### Pipeline Workflow:

1. **Первая job:**
   - Webhook срабатывает при изменении кода в репозитории.
   - Jenkins клонирует ветку с приложением на DEV сервер.
   - Собирается образ приложения с использованием Dockerfile.
   - Образ отправляется в Docker Hub с тегами `latest` и номером сборки.

2. **Вторая job:**
   - Запускается через 15 секунд после завершения первой job.
   - Образ загружается из Docker Hub.
   - Деплой сервиса в k3s (Prod-server) с использованием Helm Chart.

---

## Доступ к приложению

Приложение доступно по адресу:  
**[http://34.134.198.174.nip.io/](http://34.134.198.174.nip.io/)**  

![calc](https://github.com/Zokmi4/diplom/blob/main/images/calc.png)

