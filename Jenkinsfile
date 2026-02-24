pipeline {
    agent any

    environment {
        KUBECONFIG = "/home/ubuntu/.kube/config"
        REPO_URL   = "https://github.com/AbdullrahmanEissa/kubernetes-mongo-express-platform.git"
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                git branch: 'main', url: "${REPO_URL}"
            }
        }

        stage('Deploy MongoDB') {
            steps {
                sh '''
                  echo "Deploying MongoDB..."
                  cd mongo
                  kubectl apply -f mongo-secret.yml
                  kubectl apply -f mongo-deployment.yml
                  kubectl apply -f mongo-service.yml
                '''
            }
        }

        stage('Deploy Mongo Express') {
            steps {
                sh '''
                  echo "Deploying Mongo Express..."
                  cd mongo-express
                  kubectl apply -f mongo-express-configmap.yml
                  kubectl apply -f mongo-express-deployment.yml
                  kubectl apply -f mongo-express-service.yml
                '''
            }
        }

        stage('Deploy Ingress') {
            steps {
                sh '''
                  echo "Deploying Ingress..."
                  kubectl apply -f ingress.yml
                '''
            }
        }

    }

    post {
        success {
            echo '✅ Deployment completed successfully'
        }
        failure {
            echo '❌ Deployment failed'
        }
    }
}
