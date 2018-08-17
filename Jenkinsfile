pipeline {
    agent none 
    stages {
        stage('Example Build') {
            agent none 
            steps {
                echo 'Hello, Maven'
                sh 'mvn --version'
            }
        }
        stage('Example Test') {
            agent none 
            steps {
                echo 'Hello, JDK'
                sh 'java -version'
            }
        }
    }
}