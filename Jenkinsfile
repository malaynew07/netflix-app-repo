pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = 'malaynew07'
        APP_NAME = 'netflix-clone'
        MANIFEST_REPO = 'https://github.com/malaynew07/netflix-gitops-manifests.git'
    }
    stages {
        stage('Checkout') {
            steps { 
                checkout scm 
            }
        }
        stage('Build Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USER}/${APP_NAME}:${BUILD_NUMBER} ." 
            }
        }
        stage('Push to Docker Hub') {
            steps {
                // Ensure the credential ID 'docker-hub-creds' exists in Jenkins [cite: 92, 170]
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${APP_NAME}:${BUILD_NUMBER}"
                }
            }
        }
        stage('Update Manifest') {
            steps {
                // Ensure the credential ID 'github-creds' exists in Jenkins 
                withCredentials([usernamePassword(credentialsId: 'github-creds', passwordVariable: 'GIT_PASS', usernameVariable: 'GIT_USER')]) {
                    sh """
                        rm -rf netflix-gitops-manifests
                        git clone https://${GIT_USER}:${GIT_PASS}@github.com/${GIT_USER}/netflix-gitops-manifests.git
                        cd netflix-gitops-manifests
                        
                        # Use double quotes for the sed command to ensure variable expansion works
                        sed -i "s|image: .*|image: ${DOCKER_HUB_USER}/${APP_NAME}:${BUILD_NUMBER}|" deployment.yaml
                        
                        git config user.email "jenkins@devops.com"
                        git config user.name "Jenkins-CI"
                        git add deployment.yaml
                        git commit -m "Update image to version ${BUILD_NUMBER}"
                        git push origin main
                    """
                }
            }
        }
    } // End of Stages
} // End of Pipeline
