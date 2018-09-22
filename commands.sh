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

#Running a deployment
#window 1
kubectl get pods  --watch

#window 2
while true ; do curl -s http://192.168.99.100:30506/ ; done



