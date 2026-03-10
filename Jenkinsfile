pipeline {
    agent any

    stages {
        stage('Prepare Environment') {
            steps {
                sh 'cp /var/lib/jenkins/.env .env'
                sh 'ls -la .env'   // just to confirm the file is there
            }
        }

        stage('Deploy Infrastructure') {
            steps {
                sh '''
                    set +e

                    docker --context deploy compose down --remove-orphans --volumes || true

                    docker --context deploy compose \
                        --env-file .env \
                        build --no-cache --parallel

                    docker --context deploy compose \
                        --env-file .env \
                        up --detach --remove-orphans


                    echo "Deployment triggered successfully on remote host"
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    echo "Waiting 10 seconds for containers to stabilize..."
                    sleep 10

                    echo "=== Running containers on deploy host ==="
                    docker --context deploy compose ps

                    echo "=== Container logs (last 20 lines each) ==="
                    docker --context deploy compose logs --tail=20 || true
                '''
            }
        }


    }

    post {
        always {
            sh 'rm -f .env'
            echo 'Cleaned up .env file'
        }
        success {
            sh '''
                echo "Restarting other containers not managed by docker-compose..."
                COMPOSE_IDS=$(docker --context deploy ps -q --filter "label=com.docker.compose.project")
                ALL_IDS=$(docker --context deploy ps -q)
                RESTART_IDS=$(echo "$ALL_IDS" | grep -vxF "$COMPOSE_IDS" || true)
                echo "$RESTART_IDS" | xargs -r docker --context deploy restart
            '''
            echo 'Deployment completed successfully and verified!'
        }
        failure {
            echo 'Deployment failed – check the logs above for details.'
        }
    }
}
