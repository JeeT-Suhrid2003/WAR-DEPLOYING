pipeline {
    agent any

    stages {
        stage('Checkout GitLab Repo') {
            steps {
                git branch: 'master',
                    credentialsId: 'gitlab-http-creds',
                    url: 'https://gitlab.tejgroup.in/jeet/my-test-app.git'
            }
        }

        stage('Build WAR Package') {
            steps {
                sh '''
                    # Create the .war file inside the Jenkins container workspace
                    jar -cvf testapp.war index.html WEB-INF
                '''
            }
        }

        stage('Deploy .WAR to Tomcat on Server B') {
            steps {
                sshagent(['server-deployer-ssh-testing']) {
                    sh '''
                        # Copy the compiled .war file from Jenkins container to Server B's Tomcat directory
                        scp -o StrictHostKeyChecking=no testapp.war ubuntu@10.10.50.93:/opt/tomcat/webapps/
                    '''
                }
            }
        }
    }
    
    post {
        always {
            script {
                withEnv([
                    "BUILD_STATUS=${currentBuild.currentResult}",
                    "BUILD_DURATION=${currentBuild.durationString}"
                ]) {
                    withCredentials([string(credentialsId: 'power-automate-webhook-jeet', variable: 'WEBHOOK_URL')]) {
                        sh """
                            curl -X POST -H "Content-Type: application/json" -d '{
                                "job_name": "${env.JOB_NAME}",
                                "build_number": "${env.BUILD_NUMBER}",
                                "build_url": "${env.BUILD_URL}",
                                "status": "${env.BUILD_STATUS}",
                                "duration": "${env.BUILD_DURATION}"
                            }' "\$WEBHOOK_URL"
                        """
                    }
                }
            }

            // Clean up workspace inside the Jenkins container
            cleanWs()
        }
    }
}