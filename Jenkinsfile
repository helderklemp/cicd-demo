pipeline {
   environment{
       registry = "helderklemp/cicd-demo"
       registryCredential = "dockerhub"
       dockerImage = ''
   }
   agent any
   tools { 
        maven 'Maven' 
    }
   stages {
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
                }
                
            }
        }
        stage('Push Image') {
            steps {
                echo "Pushing image to DockerHub"
                script{
                    docker.withRegistry ('', registryCredential){
                        dockerImage.push()
                        dockerImage.push("latest")
                    }
                     
                }
            }
        }
        // stage('Deploy to Dev') {
        //     steps {
        //         sh "kubectl -f k8s/deployment.yml apply"
        //     }
        // }
    }
    
}
