#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ap-south-1"
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('eks-cluster') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage("Deploy to EKS") {
            steps {
                script {
                    dir('Kubernetes') {
                        sh "aws eks update-kubeconfig --name eks-cluster --region ap-south-1"
                        sh "cat /var/lib/jenkins/.kube/config"
                        sh "kubectl apply -f nginx-deployment.yaml -n default"
                        sh "kubectl apply -f nginx-service.yaml -n default"
                    }
                }
            }
        }
    }
}
