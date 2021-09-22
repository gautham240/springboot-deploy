pipeline{
    agent any
    parameters {
	    string(name: 'ImageTag', description: "Name of the docker build")
    }
    stages{
        stage('git checkout'){
            steps{
                git branch: 'main', 
                    credentialsId: 'git_credentials', 
                    url: 'https://github.com/gautham240/springboot-deploy.git'
            }
        }
        stage('Build Maven'){
            steps{
                sh 'mvn clean install -DskipTests=true'
            }
        }
        stage("Docker Build") {
	        steps {
	            sh 'docker build -t gautham240/spring-boot-hello:${ImageTag} .'
	        }
        }
        stage("Docker Push") {
	        steps {
               withCredentials([usernamePassword(credentialsId: 'docker_credentials', passwordVariable: 'docker_password', usernameVariable: 'docker_username')]) {
                   sh 'docker login -u ${docker_username} -p ${docker_password}'
               }
               sh 'docker push gautham240/spring-boot-hello:${ImageTag}'
           }
        }
        stage('Deployment'){
            steps{
                withCredentials([kubeconfigFile(credentialsId: 'kubernetes_credentials', variable: 'KUBECONFIG')]) {
                    sh """
                    cat deployment.yml | sed "s/{{ImageTag}}/${ImageTag}/g" | kubectl apply -f -
                    kubectl apply -f loadbalancer-service.yml
                    kubectl apply -f ingress.yml
                """
	           }
            }
        }
	}
}
