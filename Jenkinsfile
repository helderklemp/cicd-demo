pipeline {
   environment{
       registry = "helderklemp/cicd-demo"
       registryCredential = "dockerhub"
       dockerImage = ''
   }
   tools{
       maven 'Maven'
   }
   agent any
   stages {
        stage('Project Build') {
            // agent {
            //    docker {
            //         image 'maven:3-alpine'
            //         args '-v $HOME/.m2:/root/.m2'
            //     }
            // }
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
                echo "Pushing image to DockerHUb"
                script{
                    docker.withRegistry ('', registryCredential){
                        dockerImage.push()
                    }
                     
                }
            }
        }
        stage('Deploy to Dev') {
            steps {
                echo "Deploying"

            }
        }
    }
}