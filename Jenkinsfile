pipeline {
    agent any 
    tools {
        maven 'Maven' 
        docker 'Docker'
    }
    stages {
        stage('Project Build') {
            agent { docker 'maven:3-alpine' }
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