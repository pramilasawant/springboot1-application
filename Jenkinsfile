pipeline {
    agent any

    parameters {
        string(name: 'JAVA_REPO_URL', defaultValue: 'https://github.com/pramilasawant/springboot1-application.git', description: 'Java Application Git Repository URL')
        string(name: 'JAVA_BRANCH', defaultValue: 'main', description: 'Java Application Git Branch')
        string(name: 'PYTHON_REPO_URL', defaultValue: 'https://github.com/pramilasawant/phython-application.git', description: 'Python Application Git Repository URL')
        string(name: 'PYTHON_BRANCH', defaultValue: 'main', description: 'Python Application Git Branch')
        string(name: 'JAVA_IMAGE', defaultValue: 'pramila188/testhello', description: 'Java Docker Image Name')
        string(name: 'PYTHON_IMAGE', defaultValue: 'pramila188/python-app', description: 'Python Docker Image Name')
        string(name: 'JAVA_NAMESPACE', defaultValue: 'test1', description: 'Java Kubernetes Namespace')
        string(name: 'PYTHON_NAMESPACE', defaultValue: 'python', description: 'Python Kubernetes Namespace')
    }

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub'
        SLACK_CREDENTIALS_ID = 'slackpwd'
    }

    stages {
        stage('Checkout Java Application') {
            steps {
                git branch: params.JAVA_BRANCH, url: params.JAVA_REPO_URL
            }
        }
        
        stage('Build Java Application') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Java Docker Image') {
            steps {
                script {
                    docker.build(params.JAVA_IMAGE)
                }
            }
        }

        stage('Push Java Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_CREDENTIALS_ID) {
                        docker.image(params.JAVA_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy Java Application') {
            steps {
                sh "helm upgrade --install java-app ./helm/java-app --namespace ${params.JAVA_NAMESPACE} --set image.repository=${params.JAVA_IMAGE}"
            }
        }

        stage('Checkout Python Application') {
            steps {
                git branch: params.PYTHON_BRANCH, url: params.PYTHON_REPO_URL
            }
        }
        
        stage('Build Python Application') {
            steps {
                sh 'python setup.py install'
            }
        }

        stage('Build Python Docker Image') {
            steps {
                script {
                    docker.build(params.PYTHON_IMAGE)
                }
            }
        }

        stage('Push Python Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_CREDENTIALS_ID) {
                        docker.image(params.PYTHON_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy Python Application') {
            steps {
                sh "helm upgrade --install python-app ./helm/python-app --namespace ${params.PYTHON_NAMESPACE} --set image.repository=${params.PYTHON_IMAGE}"
            }
        }
    }

    post {
        always {
            slackSend (channel: '#build-notifications', color: 'good', message: "Build and deployment completed successfully.")
        }
        failure {
            slackSend (channel: '#build-notifications', color: 'danger', message: "Build and deployment failed.")
        }
    }
}
