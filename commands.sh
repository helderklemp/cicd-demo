# Set of commands to run the demo

# Looking at the cluster
kubectl get nodes
kubectl get nodes -n kube-system

# Running a single Pod
kubectl apply -f k8s/deployment.yml
kubectl get pods 
kubectl get services
kubectl get services cicd-demo-service -o wide
kubectl get deployments cicd-demo-deployment -o wide
minikube service cicd-demo-service

#Running a deployment
#window 1
watch -n1 kubectl get pods
kubectl scale cicd-demo-deployment --replicas=3

#window 2
kubectl get events --watch

#window 3
while true ; do curl -s 192.168.99.100:30373/ | jq ".hostname" ; done

#window 4
kubectl scale deployment cicd-demo-deployment --replicas=2
kubectl set image  deployment/cicd-demo-deployment cicd-demo-app=helderklemp/cicd-demo:42
kubectl rollout undo deployment cicd-demo-deployment



