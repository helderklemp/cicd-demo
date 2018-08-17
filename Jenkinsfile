pipeline {
    agent any 
    tools {
        maven 'Maven' 
    }
    stages {
        stage('Project Build') {
            
            steps {
                sh 'mvn -version'
            }
        }
        stage('Example Test') {
            steps {
                echo 'Hello, JDK'
           
            }
        }
    }
}