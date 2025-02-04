pipeline {
    agent { label 'agent1' }

    stages {
        stage('Clone and Update Repository') {
            steps {
                script {
                    // Клонирование репозитория
                    git branch: 'main', credentialsId: 'git', url: 'https://github.com/Zokmi4/diplom.git'

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
    }

    post {
        always {
            script {
                try {
                    // Удаляем контейнер с именем zokmi4/diplom, если он существует
                    def containers = sh(script: 'docker ps -aqf "name=zokmi4_diplom_"', returnStdout: true).trim()
                    if (containers) {
                        sh "docker rm -f ${containers}"
                    } else {
                        echo 'Нет контейнеров для удаления.'
                    }
                } catch (Exception e) {
                    echo "Error during cleanup: ${e.message}"
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
