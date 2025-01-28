pipeline {
    agent { label 'agent1' }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: '2', url: 'https://github.com/Zokmi4/diplom.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('diplom/calc/') {
                        // Выводим текущую директорию и содержимое для диагностики
                        sh 'echo "Текущая директория:"'
                        sh 'pwd'
                        sh 'echo "Содержимое директории:"'
                        sh 'ls -l'

                        // Проверка наличия Dockerfile
                        sh 'find . -name Dockerfile'

                        // Явно указываем путь к Dockerfile и контекст сборки
                        sh 'docker build -f Dockerfile -t zokmi4/my-fastapi-calc:latest .'
                        sh "docker tag zokmi4/my-fastapi-calc:latest zokmi4/my-fastapi-calc:${env.BUILD_ID}"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '3', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        dir('diplom/calc/') {
                            sh 'echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin'
                            sh "docker push zokmi4/my-fastapi-calc:latest"
                            sh "docker push zokmi4/my-fastapi-calc:${env.BUILD_ID}"
                        }
                    }
                }
            }
        }
    }
}
