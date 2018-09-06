pipeline {
   environment{
       registry = "helderklemp/cicd-demo"
       registryCredential = "dockerhub"
       dockerImage = ''
       dockerImageLts = ''
   }
   agent any
   triggers { upstream(upstreamProjects: 'docker-java-base', threshold: hudson.model.Result.SUCCESS) }
   stages {
        stage('K8s Login') {
            steps {
                sh "cat k8s/deployment.yml"             
            }
        }
        stage('Project Build') {
            steps {
                sh 'mvn clean install'
            }
        }
           
        stage('Paralles Tests') {
            
            when {
                branch 'master'
            }
            failFast true
            parallel {
                stage('Static Code Analysis') {
                    steps {
                        echo "On Branch A"
                    }
                }
                stage('Integration Tests') {
                    steps {
                        echo "On Branch B"
                    }
                }
            }
        }
        stage('Build Image') {
            steps {
                echo "Build Dcker image"
                script{
                    dockerImage = docker.build registry + ":${BUILD_NUMBER}"
                    dockerImageLts = docker.build registry + ":latest"
                }
                
            }
        }
        stage('Push Image') {
            steps {
                echo "Pushing image to DockerHub"
                script{
                    docker.withRegistry ('', registryCredential){
                        dockerImage.push()
                        dockerImageLts.push()
                    }
                     
                }
            }
        }
        stage('Deploy to Dev') {
            steps {
                sh "kubectl -f k8s/deployment.yml apply"
            }
        }
    }
    
}
def kubeSubst(placeholder, value, file) {
  sh "sed -i.bak s/:\\\${$placeholder}/:$value/g $file"
}
