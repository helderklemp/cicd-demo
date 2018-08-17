pipeline {
    agent any 
    tools {
        maven 'Maven' 
    }
    stages {
        //stage('Commit Stage') {
            //stages {
                stage('Project Build') {
                    steps {
                        sh 'mvn clean install -DskipTests'
                    }
                }
                stage(' Unit Tests') {
                    steps {
                        sh 'mvn test'
                    }
                }
            //}
        //}
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
            }
        }
    }
}