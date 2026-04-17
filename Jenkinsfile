pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = 'malaynew07'
        APP_NAME = 'netflix-clone'
        // This is the repo ArgoCD watches
        MANIFEST_REPO = 'https://github.com/malaynew07/netflix-gitops-manifests.git'
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Build Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USER}/${APP_NAME}:${BUILD_NUMBER} ." 
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${APP_NAME}:${BUILD_NUMBER}"
                }
            }
        }
        stage('Update Manifest') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'github-creds', passwordVariable: 'GIT_PASS', usernameVariable: 'GIT_USER')]) {
            sh """
                # Clean up any old clones first
                rm -rf netflix-gitops-manifests
                
                # Clone using the credentials in the URL
                git clone https://${GIT_USER}:${GIT_PASS}@github.com/${GIT_USER}/netflix-gitops-manifests.git
                
                cd netflix-gitops-manifests
                
                # Update the image tag in deployment.yaml
                sed -i 's|image: .*|image: ${DOCKER_HUB_USER}/netflix-clone:${env.BUILD_NUMBER}|' deployment.yaml
                
                # Commit and Push
                git config user.email "jenkins@devops.com"
                git config user.name "Jenkins-CI"
                git add deployment.yaml
                git commit -m "Update image to version ${env.BUILD_NUMBER}"
                git push origin main
            """
        }
    }
}
