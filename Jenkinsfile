pipeline {
   agent none
   stages {
        stage('Project Build') {
            agent {
               docker {
                    image 'maven:3-alpine'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }
        stage('Build Image2') {
            agent any
            steps {
                //def customImage = docker.biuld("my-image")
                echo "Build Dcker image"
                sh 'docker build --build-arg JAR_FILE=target/cicd-demo-0.0.1-SNAPSHOT.jar -t helderklemp/cicd-demo .'
            }
        }
        stage(' Unit Tests') {
            steps {
                sh 'mvn test'
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
                sh 'docker build --build-arg JAR_FILE=target/cicd-demo-0.0.1-SNAPSHOT.jar -t helderklemp/cicd-demo .'
            }
        }
    }
}