pipeline {
    agent any 
    tools {
        maven 'Maven' 
    }
    stages {
        stage('Project Build') {
            
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }
        stage(' Unit Tests') {
            steps {
                echo 'mvn test'
           
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
                    asteps {
                        echo "On Branch B"
                    }
                }
        }
    }
}