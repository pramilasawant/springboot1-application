@Library('shared-lib') _

pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhubpwd')
        SLACK_CREDENTIALS = credentials('slackpwd')
    }

    stages {
        stage('Checkout Repositories') {
            parallel {
                stage('Checkout Java Application') {
                    steps {
                        dir('java-app') {
                            git 'https://github.com/pramilasawant/springboot1-application.git'
                        }
                    }
                }
                stage('Checkout Python Application') {
                    steps {
                        dir('python-app') {
                            git 'https://github.com/pramilasawant/phython-application.git'
                        }
                    }
                }
            }
        }

        stage('Build and Deploy') {
            parallel {
                stage('Build and Push Java Application') {
                    steps {
                        script {
                            dir('java-app') {
                                sh 'mvn clean install'  // Ensure the Maven build is successful
                                sh 'docker build -t pramila188/testhello:latest .'
                                docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                                    sh 'docker push pramila188/testhello:latest'
                                }
                            }
                        }
                    }
                }
                stage('Build and Push Python Application') {
                    steps {
                        script {
                            dir('python-app') {
                                sh 'docker build -t pramila188/python-app:latest .'
                                docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                                    sh 'docker push pramila188/python-app:latest'
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            slackSend(
                channel: '#build-failures',
                color: '#FF0000',
                message: "Build failed in ${env.JOB_NAME} - ${env.BUILD_NUMBER}. Check Jenkins for details.",
                tokenCredentialId: 'slackpwd'
            )
        }
    }
}
