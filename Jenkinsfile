pipeline {
    agent { label 'agent1' }

    stages {
        // Стадия клонирования и обновления репозитория
        stage('Clone and Update Repository') {
            steps {
                script {
                    // Клонируем репозиторий с указанием ветки и учетных данных
                    git branch: 'main', credentialsId: '2', url: 'https://github.com/Zokmi4/diplom.git'

                    // Обновляем репозиторий, загружаем все изменения
                    sh 'git fetch --all'
                    
                    // Можно использовать git pull, если нужно сразу применить изменения:
                    // sh 'git pull origin main'
                }
            }
        }

        // Стадия сборки Docker-образа
        stage('Build Docker Image') {
            steps {
                script {
                    dir('calc/') {
                        // Диагностика: выводим текущую директорию и содержимое
                        sh 'echo "Текущая директория:"'
                        sh 'pwd'
                        sh 'echo "Содержимое директории:"'
                        sh 'ls -l'

                        // Проверяем наличие Dockerfile в текущей директории
                        sh 'find . -name Dockerfile'

                        // Сборка Docker-образа с указанием Dockerfile и контекста сборки
                        sh 'docker build -f Dockerfile -t zokmi4/diplom:latest .'

                        // Тегируем собранный образ для текущей сборки
                        sh "docker tag zokmi4/diplom:latest zokmi4/diplom:${env.BUILD_ID}"
                    }
                }
            }
        }

        // Стадия пуша образа на Docker Hub
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '3', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        dir('calc/') {
                            // Входим в Docker Hub
                            sh 'echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin'

                            // Пушим Docker-образ с тегом latest и с тегом для текущей сборки
                            sh "docker push zokmi4/diplom:latest"
                            sh "docker push zokmi4/diplom:${env.BUILD_ID}"
                        }
                    }
                }
            }
        }

        // Стадия деплоя контейнера
        stage('Deploy') {
            steps {
                script {
                    dir('final/app') {
                        // Запускаем контейнер с тегом текущей сборки
                        sh """
                        echo "Запуск контейнера с тегом: zokmi4/diplom:${env.BUILD_ID}"
                        docker run -d --rm -p 8080:8080 zokmi4/diplom:${env.BUILD_ID}
                        """
                    }
                }
            }
        }
    }

    // Пост-обработка
    post {
        always {
            script {
                // Получаем список контейнеров для удаления
                def containers = sh(script: 'docker ps -aq', returnStdout: true).trim()
                
                // Если контейнеры есть, удаляем их
                if (containers) {
                    sh "docker rm -f ${containers}"
                } else {
                    echo 'Нет контейнеров для удаления.'
                }
            }

            // Отправка уведомления по email
            emailext (
                to: 'mazay.cod@gmail.com',
                subject: "Jenkins Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) завершился",
                body: "Статус сборки: ${currentBuild.currentResult}\n\nСсылка на сборку: ${env.BUILD_URL}",
                attachLog: true
            )
        }
    }
}
