FROM jenkins/jenkins:lts

# if we want to install via apt
USER root
# kubectl
RUN apt-get update && apt-get install -y apt-transport-https && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    touch /etc/apt/sources.list.d/kubernetes.list && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get install -y kubectl
# Docker
RUN apt-get -y install ca-certificates \
     curl \
     vim \
     gnupg2 \
     software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce    
ARG MINIKUBE_DIR
COPY kubectl-config.yml /root/.kube/config
COPY ca.crt /root/.kube/ca.crt 
COPY client.crt /root/.kube/client.crt 
COPY client.key /root/.kube/client.key