# Автоматизация деплоя с использованием Ansible, Jenkins и Kubernetes

## Окружение

Используются 3 виртуальные машины на базе Google Cloud:

- **34.56.209.145** (Dev-server): Docker, Docker Compose, Jenkins Agent 1
- **34.134.198.174** (Test-server): Jenkins Server
- **34.41.24.58** (Prod-server): Docker, Docker Compose, k3s, Helm, Jenkins Agent 2

## Установка компонентов с помощью Ansible

### Установка Основной инфраструктуры (docker, docker-compose, jenkins,k3s, helm)

```bash
ansible-playbook -i hosts playbook.yml
```

Jenkins будет доступен по адресу: **[http://34.134.198.174:8080](http://34.134.198.174:8080)**

### Установка системы мониторинга (Grafana + Prometheus + Alertmanager):

```bash
ansible-playbook -i hosts graf+prom+alert.yml
```

### Установка Node Exporter на все 3 машины:

```bash
ansible-playbook -i hosts node_ex.yml
```

### Установка rsyslog для логирования:

```bash
ansible-playbook -i hosts rsyslog.yml
```

## Настройка Jenkins и агентов

Агенты устанавливаются вручную:

- **Agent 1** (Dev-server) — отвечает за сборку сервиса в Docker и отправку его в Docker Hub.
- **Agent 2** (Prod-server) — отвечает за скачивание образа из Docker Hub и деплой сервиса в k3s.

## CI/CD Pipeline в Jenkins

### **Pipeline Workflow:**

1. **Первая job:**

   - Webhook срабатывает при изменении кода в репозитории.
   - Jenkins клонирует ветку с приложением на DEV сервер.
   - Собирается образ приложения с использованием Dockerfile.
   - Образ отправляется в Docker Hub с тегами `latest` и номером сборки.

2. **Вторая job:**

   - Запускается через 15 секунд после завершения первой job.
   - Образ загружается из Docker Hub.
   - Деплой сервиса в k3s (Prod-server) с использованием Helm Chart.

## Доступ к приложению

Приложение доступно по адресу: **[http://34.134.198.174.nip.io/](http://34.134.198.174.nip.io/)**

