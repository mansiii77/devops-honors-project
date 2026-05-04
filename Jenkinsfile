pipeline {
    agent any

    options {
        timestamps()
    }

    triggers {
        githubPush()
    }

    environment {
        APP_DIR = '/home/ec2-user/app'
        EC2_USER = 'ec2-user'
        EC2_HOST = credentials('ec2-host')
        SSH_CRED_ID = 'ec2-ssh-key'
        SERVICE_NAME = 'devops-honors'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn -B test'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(credentials: [env.SSH_CRED_ID]) {
                    sh '''
                        set -e
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "mkdir -p ${APP_DIR}"
                        scp -o StrictHostKeyChecking=no target/*.jar ${EC2_USER}@${EC2_HOST}:${APP_DIR}/app.jar
                        scp -o StrictHostKeyChecking=no scripts/devops-honors.service ${EC2_USER}@${EC2_HOST}:/tmp/devops-honors.service
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "sudo mv /tmp/devops-honors.service /etc/systemd/system/devops-honors.service && sudo systemctl daemon-reload && sudo systemctl enable ${SERVICE_NAME}"
                    '''
                }
            }
        }

        stage('Start Service') {
            steps {
                sshagent(credentials: [env.SSH_CRED_ID]) {
                    sh '''
                        set -e
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "sudo systemctl restart ${SERVICE_NAME}"
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "sudo systemctl status ${SERVICE_NAME} --no-pager"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}
