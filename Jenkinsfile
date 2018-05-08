#!/usr/bin/env groovy

node('master') {
    stage('build') {
        git url: 'https://github.com/samjbro/test-docker-jenkins.git'

        sh "./develop.sh up -d"

        sh "./develop.sh composer install"

        sh 'cp .env.example .env'
        sh './develop.sh art key:generate'
        sh 'sed -i "s/REDIS_HOST=.*/REDIS_HOST=redis/" .env'
        sh 'sed -i "s/CACHE_DRIVER=.*/CACHE_DRIVER=redis/" .env'
        sh 'sed -i "s/SESSION_DRIVER=.*/SESSION_DRIVER=redis/" .env'
    }
    stage('test') {
        sh "APP_ENV=testing ./develop.sh test"
    }
}