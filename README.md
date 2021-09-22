# springboot-deploy

# Pre-Requisites:
	- Jenkins Setup
  - Install git, maven and docker
	
# Cluster Setup
	Attach Role to Server to connect from ec2 service to eks service
	Here I have taken some admin role 
  Run shell script 
	sh cluster.sh
# clone code to server and setup Nginx-ingress-contoller
  git clone https://github.com/gautham240/springboot-deploy.git
  cd springboot-deploy/nginx-ingress-controller
  kubectl apply -f .
# Install Jenkins
	sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
	sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
	sudo yum upgrade -y
	sudo amazon-linux-extras install epel -y
    sudo yum install java-1.8.0-openjdk -y
	sudo yum install jenkins -y
  sudo usermod -aG docker jenkins
	sudo service jenkins start
  Open "8080" Port in security group and run below url
	<Public-IP>:<Port>
# Add plugins in kubernetes
    kubernetes-contineous-deploy
# Create credentilas for git, docker and kubernetes
# Create job in jenkins and run, it will deploy in kubernetes
# Create hosted name in Route53 and add record with details of ingress url along with our domain
