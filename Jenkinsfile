pipeline {
    agent any

    stages {
        stage('Prepare Environment') {
            steps {
                echo 'Copying shared .env configuration...'
                sh 'cp /opt/nwdaf-config/.env .env'
            }
        }

        stage('Deploy Infrastructure') {
            steps {
                echo 'Switching to deploy context...'
                sh 'docker context use deploy'

                echo 'Stopping existing services...'
                sh 'docker compose down --remove-orphans'

                echo 'Building services with no cache...'
                sh 'docker compose build --no-cache'

                echo 'Starting services...'
                sh 'docker compose up -d'

                echo 'Waiting for services to stabilize...'
                sh 'sleep 15'

                echo 'Restarting all containers...'
                sh 'docker restart $(docker ps -aq)'

                echo 'Switching back to default context...'
                sh 'docker context use default'
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Checking container status...'
                sh 'docker context use deploy'
                sh 'docker compose ps'
                sh 'docker context use default'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up .env file...'
            sh 'rm -f .env'
            echo 'Ensuring default context is active...'
            sh 'docker context use default || true'
        }
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed. Check logs above.'
            sh 'docker context use default || true'
        }
    }
}
