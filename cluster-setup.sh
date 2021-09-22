#! /bin/bash

# Install kubectl in Main server to deploy applications

FILE_kubectl=/usr/bin/kubectl
if [ -f "$FILE_kubectl" ]; then
    echo "kubectl already installed"
else
	curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	cp kubectl /usr/bin
fi

# Install eksctl in Main server to setup eks cluster

FILE_eksctl=/usr/bin/eksctl
if [ -f "$FILE_eksctl" ]; then
    echo "eksctl already installed"
else
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
	mv /tmp/eksctl /usr/bin
	echo "eksctl version"
	eksctl version
fi

# Install jq 
yum install jq -y

eks_master () {
    eksctl create cluster --name=eksdemo \
                  --region=us-east-1 \
                  --zones=us-east-1a,us-east-1b \
                  --without-nodegroup
}
eks_nodeGroup () {
	eksctl create nodegroup --cluster=eksdemo \
                   --region=us-east-1 \
                   --name=eksdemo-ng \
                   --node-type=t2.medium \
                   --nodes=2 \
                   --nodes-min=2 \
                   --nodes-max=4 \
                   --node-volume-size=10 \
                   --ssh-access \
                   --ssh-public-key=naresh_devops \
                   --managed \
                   --asg-access \
                   --external-dns-access \
                   --full-ecr-access \
                   --appmesh-access \
                   --alb-ingress-access	
}
cluster=$(aws eks list-clusters --region us-east-1 | jq -r ".clusters" | grep eksdemo)
 
 
nodeGroupName=$(aws eks list-nodegroups --cluster-name eksdemo --region us-east-1 | jq -r ".nodegroups" | grep eksdemo-ng)

if [[ ! -z $cluster ]]; then
    echo "The cluster already exist"
	if [[ ! -z $nodeGroupName ]]; then
		echo "Node Group already exist"
	else
		echo "Eks NodeGroup creating....!!!!"
		eks_nodeGroup
	fi
else
	echo "Eks master and nodeGroup creating....!!!!"
    eks_master
	eks_nodeGroup
fi
