#!/usr/bin/env groovy

pipeline {
    environment{
       FEATURE_NAME = BRANCH_NAME.replaceAll('[\\(\\)_/]','-').toLowerCase()
       REGISTRY_PASSWORD = credentials('REGISTRY_PASSWORD')
       REGISTRY_USERNAME = credentials('REGISTRY_USERNAME')
       POSTGRES_PASSWORD = credentials('POSTGRES_PASSWORD')
       APP_NAME = "cicd-demo"
    }
    agent any 
    stages {
        stage('Docker Build & Push') {
            steps {
                sh "make dockerLogin build dockerBuild dockerPush"
            }

        }
		// not in parallel due to race condition with .env
        stage('Docker Scan') {
            steps {
                sh "make dockerScan"
            }
            post {
                cleanup {
                    sh "docker-compose down -v"
                }
            }
        }
        
        stage('Parallel Tests') {
            failFast true            
            parallel {                  
                stage('Static Code Analysis') {
                    when {
                        anyOf { branch 'master'; branch 'release'}
                    }    
                    steps {
                        sh "make publishSonar"                        
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh "make integrationTest"
                    }
                }
            }
        }
        stage('Push Latest Tag') {
            when { branch 'master' }
            steps {
                sh "make dockerPushLatest"
            }
        }

        stage('Deploy To dev') {
            environment { 
                ENV = "dev"
                APP_DNS = util.selectAppUrl(ENV, FEATURE_NAME, APP_NAME)
                KUBE_SERVER = credentials("KUBE_API_SERVER")
                KUBE_TOKEN = credentials("KUBE_DEV_TOKEN")
            }
            steps {
                sh "make kubeLogin deploy"
            }
        }
        
        stage('Deploy To qa') {
            when { expression { BRANCH_NAME ==~ /(master|release-[0-9]+$)/ }} // Only Master and Release branches 
            environment { 
                ENV = "qa"
                APP_DNS = util.selectAppUrl(ENV, FEATURE_NAME, APP_NAME)
                KUBE_SERVER = credentials("KUBE_API_SERVER")
                KUBE_TOKEN = credentials("KUBE_QA_TOKEN")
            }
            steps {
                sh "make kubeLogin deploy"
            }
        }
        
    }
    post {
        always {
            script {
                if(BRANCH_NAME ==~ /(master|release-[0-9]+$)/ ){
                     util.notifySlack(currentBuild.result)
                 }
            }
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            junit 'target/surefire-reports/*.xml'
        }
    }
}
