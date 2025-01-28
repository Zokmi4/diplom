pipeline {
    agent { label 'agent1' }

    stages {
        stage('Clone and Update Repository') {
            steps {
                script {
                    // Клонирование репозитория
                    git branch: 'main', credentialsId: '2', url: 'https://github.com/Zokmi4/diplom.git'

                    // Обновление репозитория с помощью git fetch
                    sh 'git fetch --all'  // Загружает все изменения, но не сливает их

                    // Или можно использовать git pull, чтобы сразу применить изменения
                    // sh 'git pull origin main'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('calc/') {
                        // Выводим текущую директорию и содержимое для диагностики
                        sh 'echo "Текущая директория:"'
                        sh 'pwd'
                        sh 'echo "Содержимое директории:"'
                        sh 'ls -l'

                        // Проверка наличия Dockerfile
                        sh 'find . -name Dockerfile'

                        // Явно указываем путь к Dockerfile и контекст сборки
                        sh 'docker build -f Dockerfile -t zokmi4/diplom:latest .'
                        sh "docker tag zokmi4/diplom:latest zokmi4/diplom:${env.BUILD_ID}"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '3', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        dir('calc/') {
                            sh 'echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin'
                            sh "docker push zokmi4/diplom:latest"
                            sh "docker push zokmi4/diplom:${env.BUILD_ID}"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    dir('calc/') {
                        sh """
echo "Запуск контейнера с тегом: zokmi4/diplom:${env.BUILD_ID}"
docker run -d --rm -p 8080:8080 zokmi4/diplom:${env.BUILD_ID}
"""
                    }
                }
            }
        }
    }

post {
    always {
        script {
            // Получаем список контейнеров для удаления
            def containers = sh(script: 'docker ps -aq', returnStdout: true).trim()

            // Проверяем, есть ли контейнеры для удаления
            if (containers) {
                // Удаляем контейнеры, если они есть
                sh "docker rm -f ${containers}"
            } else {
                echo 'Нет контейнеров для удаления.'
            }
        }
        emailext (
            to: 'mazay.cod@gmail.com',
            subject: "Jenkins Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) завершился",
            body: "Статус сборки: ${currentBuild.currentResult}\n\nСсылка на сборку: ${env.BUILD_URL}",
            attachLog: true
        )
    }
}
}
