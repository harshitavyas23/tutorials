pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = "harshitavyas23"
        DOCKER_CONFIG = "/Users/harshita.vyas/.docker"
        IMAGE_NAME = "tutorials"
        EC2_USER = "ec2-user"
        EC2_IP = "44.250.234.209" // replace with your instance public IP
        DOCKER_CMD = "/opt/homebrew/bin/docker" // full path to Docker
    }

    stages {

        stage('Clone Repo') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/harshitavyas23/tutorials'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "${DOCKER_CMD} build -t ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-pass', variable: 'DOCKER_PASS')]) {
                    sh "echo \"\$DOCKER_PASS\" | ${DOCKER_CMD} login -u ${DOCKERHUB_USERNAME} --password-stdin"
                }
            }
        }

        stage('Push Image') {
            steps {
                sh "${DOCKER_CMD} push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '
                            docker pull ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest &&
                            docker stop ${IMAGE_NAME} || true &&
                            docker rm ${IMAGE_NAME} || true &&
                            docker run -d -p 80:80 --name ${IMAGE_NAME} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest
                        '
                    """
                }
            }
        }
    }
}

