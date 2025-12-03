pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = "harshitavyas719"
        IMAGE_NAME = "tutorials"
    }

    stages {

        stage('Clone Repo') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:latest .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-pass', variable: 'DOCKER_PASS')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@<EC2-PUBLIC-IP> '
                            docker pull $DOCKERHUB_USERNAME/$IMAGE_NAME:latest &&
                            docker stop tutorials || true &&
                            docker rm tutorials || true &&
                            docker run -d -p 80:80 --name tutorials $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                        '
                    '''
                }
            }
        }
    }
}
