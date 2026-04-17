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
                withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${APP_NAME}:${BUILD_NUMBER}"
                }
            }
        }
        stage('Update Manifest') {
            steps {
                // This script updates the image tag in your second Git repo
                sh """
                git clone https://github.com/your-user/netflix-gitops-manifests.git
                cd netflix-gitops-manifests
                sed -i 's|image: .*|image: ${DOCKER_HUB_USER}/${APP_NAME}:${BUILD_NUMBER}|' deployment.yaml
                git add deployment.yaml
                git commit -m 'Update image to version ${BUILD_NUMBER}'
                git push origin main
                """
            }
        }
    }
}
