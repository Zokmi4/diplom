Автоматизация и практический навык использования инструментов Ansible, Jenkins, Kubernetes
Окружение
Используем 3 виртуальные машины на базе Google Cloud 
1.	34.56.209.145  (dev-server): Docker, Jenkins agent1
2.	34.134.198.174 (test-server): Jenkins server
3.	34.41.24.58 (prod-server): Kubernetes (k3s), Helm, Jenkins agent2
С помощью Ansible устанавливаем на машинах:
Dev – Docker и Docker Compose
Prod – Docker и Docker Compose, k3s + helm 
Test – Jenkins 
Команда: ansible-playbook –i hosts playbook.yml
Jenkins будет доступен по адресу 34.134.198.174:8080
Настраиваем Jenkins и устанавливаем в ручную агентов 1 и 2 на dev и prod машине. 
Agent 1 – отвечает за сборку сервиса в докере и отправки его в Docker Hub
Agent 2 – отвечает за скачивание из Docker Hub образа и деплой сервиса в k3s 

Далее устанавливаем систему мониторинга: Grafana + Prometheus+Alertmanager
Команда: ansible-playbook –i hosts graf+prom+alert.yml
Так же устанавливаем Node Exporter на все 3 машины
Команда: ansible-playbook –i hosts node_ex.yml
Для логирования используем rsyslog 
Команда: ansible-playbook –i hosts rsyslog.yml
