pipeline {
    agent any

    environment {
        // Switch between 'CENTRAL' or 'EPHEMERAL'
        DB_TARGET_TYPE = 'CENTRAL' 
        
        // Central DB Settings (Used if DB_TARGET_TYPE is 'CENTRAL')
        CENTRAL_DB_HOST = 'your-central-db-ip' 
        CENTRAL_DB_PORT = '5432'
        CENTRAL_DB_NAME = 'atlasdemo'
        CENTRAL_DB_USER = 'postgres'
        CENTRAL_DB_PASS = 'yoursecurepassword' 
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR_USERNAME/atlas-poc.git'
            }
        }

        stage('Install Atlas CLI') {
            steps {
                sh 'curl -sSf https://atlasgo.sh | sh'
            }
        }

        stage('Deploy local DB if needed') {
            when { environment name: 'DB_TARGET_TYPE', value: 'EPHEMERAL' }
            steps {
                echo "Spinning up local ephemeral DB..."
                sh '''
                docker run -d --name jenkins-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=atlasdemo -p 5432:5432 postgres:15
                sleep 10
                '''
            }
        }

        stage('Verify Target Connection') {
            steps {
                script {
                    if (env.DB_TARGET_TYPE == 'CENTRAL') {
                        def status = sh(script: "nc -z -w5 ${CENTRAL_DB_HOST} ${CENTRAL_DB_PORT}", returnStatus: true)
                        if (status != 0) { error "Cannot reach Central Database Server!" }
                        env.FINAL_DB_URL = "postgres://${CENTRAL_DB_USER}:${CENTRAL_DB_PASS}@${CENTRAL_DB_HOST}:${CENTRAL_DB_PORT}/${CENTRAL_DB_NAME}?sslmode=disable"
                    } else {
                        env.FINAL_DB_URL = "postgres://postgres:postgres@localhost:5432/atlasdemo?sslmode=disable"
                    }
                }
            }
        }

        stage('Lint & Code Review') {
            steps {
                // Analyzes migrations for destructive statements like drop tables
                sh './atlas migrate lint --env local'
            }
        }

        stage('Apply Migrations') {
            steps {
                sh """
                ./atlas migrate apply \
                  --url "${env.FINAL_DB_URL}" \
                  --dir "file://migrations" \
                  --auto-approve
                """
            }
        }
    }

    post {
        always {
            script {
                if (env.DB_TARGET_TYPE == 'EPHEMERAL') {
                    sh 'docker rm -f jenkins-postgres || true'
                }
            }
        }
    }
}
