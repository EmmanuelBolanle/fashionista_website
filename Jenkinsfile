pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'fashion_website_image'
        ECR_REPO = '597088050329.dkr.ecr.us-east-2.amazonaws.com/fashion_website_image'
        AWS_REGION = 'us-east-2'
        EMAIL_RECIPIENTS = 'ebolanle@gmail.com'
        IMAGE_TAG = "${DOCKER_IMAGE}:${BUILD_NUMBER}"
        SONAR_HOST_URL = credentials('sonar_host_url')
        SONAR_TOKEN = credentials('sonar_access')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/EmmanuelBolanle/fashionista_website.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Create and set permissions for npm cache directory
                    sh '''
                        mkdir -p /home/node/.npm
                        chown -R $(id -u):$(id -g) /home/node/.npm
                        npm config set cache /home/node/.npm --userconfig /home/node/.npmrc --unsafe-perm
                        npm install
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                }
            }
        }

        stage('Scan Docker Image') {
            steps {
                script {
                    sh """
                    docker run --rm -e SONAR_TOKEN=${SONAR_TOKEN} \
                        -v ${WORKSPACE}:/usr/src --network host \
                        sonarsource/sonar-scanner-cli \
                        -Dsonar.projectKey=fashionista_website \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONAR_HOST_URL}
                    """
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    withAWS(credentials: 'aws_credential', region: "${AWS_REGION}") {
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}"
                        sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${ECR_REPO}:${BUILD_NUMBER}"
                        sh "docker push ${ECR_REPO}:${BUILD_NUMBER}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            emailext(
                to: "${EMAIL_RECIPIENTS}",
                subject: "Build Succeeded: ${DOCKER_IMAGE} - ${BUILD_NUMBER}",
                body: """\
The build was successful!

Build Details:
- Docker Image: ${DOCKER_IMAGE}
- Build Number: ${BUILD_NUMBER}
- Build URL: ${BUILD_URL}

Check the details at the above URL.
"""
            )
        }
        failure {
            emailext(
                to: "${EMAIL_RECIPIENTS}",
                subject: "Build Failed: ${DOCKER_IMAGE} - ${BUILD_NUMBER}",
                body: """\
The build failed.

Build Details:
- Docker Image: ${DOCKER_IMAGE}
- Build Number: ${BUILD_NUMBER}
- Build URL: ${BUILD_URL}

Check the details at the above URL.
"""
            )
        }
    }
}


