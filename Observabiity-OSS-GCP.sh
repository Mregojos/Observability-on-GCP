# Observability-OSS-GCP

# Environment Variables
source env*
echo "USERNAME:"
read -s DOCKER_USERNAME
export DOCKER_USERNAME=$DOCKER_USERNAME
echo $DOCKER_USERNAME

# Create a firewall
gcloud compute --project=$(gcloud config get project) firewall-rules create $FIREWALL_RULES_NAME-observability \
    --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9000,tcp:8000,tcp:10000 --source-ranges=0.0.0.0/0
    
# Infrastructure (Run in another shell)
source env*
sh infra*

# GitOps
#-------------- Edited from GitOps on GCP Repo [START] --------------------#
# kubectl and minikube
sh kubectl-minikube.sh

# Build the image and push to the hub
cd app
docker build -t $DOCKER_USERNAME/app .
cd ..
# hub.docker.com/repositories
# Login Docker
docker login
# Docker Images
docker images
# Push to Docker Hub
docker push $DOCKER_USERNAME/app
# Docker logout
docker logout

# Option A: Create app.yaml manifest with secrets
# Deploy locally (kubectl)
kubectl delete namespace app
# Create app namespace
kubectl create namespace app
cd manifest
sh app-secrets.sh
cd ..
# Apply deployment
kubectl apply -f manifest/app.yaml -n app
kubectl get all -n app
watch kubectl get all -n app
kubectl expose deployment.apps/app-deployment -n app
kubectl get all -n app
kubectl port-forward service/app-deployment 9000:9000 --address 0.0.0.0 -n app
# Go to <IP>:9000
kubectl get pods -n app
# Delete namespace
kubectl delete namespace app

# App GitOps Deployment
# GitOps
sh GitOps.sh
# kubectl get namespaces
# cat ~/.kube/config
# Access The Argo CD API Server
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
# Run in another terminal and create a firewall (command below)
kubectl port-forward svc/argocd-server -n argocd 8000:443 --address 0.0.0.0
argocd admin initial-password -n argocd
# USERNAME: admin
# PASSWORD: <argocd admin initial-password -n argocd> #password
# You can change it using the UI
# argocd login <ARGOCD_SERVER>:PORT
# argocd account update-password
# New password: p@ssword

# Create an application from a git repository
# Create Apps Via CLI
# kubectl config set-context --current --namespace=argocd
# argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
# argocd app create app --repo https://github.com/mregojos/GitOps-on-GCP.git --path manifest --dest-server https://kubernetes.default.svc --dest-namespace default
# or Create Apps Via UI
# Create an application from a git repository
# Create Apps Via CLI
# Create app.yaml manifest
cd manifest
sh app-secrets-default.sh
cd ..
# Remove comment tags in git-push and add after
kubectl port-forward svc/argocd-server -n argocd 8000:443 --address 0.0.0.0
kubectl config set-context --current --namespace=argocd
argocd app create app --repo https://github.com/mregojos/GitOps-on-GCP.git --path manifest --dest-server https://kubernetes.default.svc --dest-namespace default --revision main --sync-policy auto
watch kubectl get all -n default
kubectl expose deployment.apps/app-deployment -n default
kubectl get all -n default
kubectl port-forward service/app-deployment 9000:9000 --address 0.0.0.0 -n default
# Delete App
argocd app delete app -y

# or Create Apps Via UI
#-------------- Edited from GitOps on GCP Repo [END]--------------------#


#-------------- Observability [START] --------------------#
# Option A: helm and Kube-Prometheus-Stack
sh Observability-OSS.sh
helm list -n monitoring
kubectl get all -n monitoring
# Port-forward
kubectl port-forward svc/my-kube-prometheus-stack-grafana  10000:80 -n monitoring --address 0.0.0.0 
# User: Admin
# Password: prom-operator

# Option B
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo prometheus
helm install bitnami/prometheus --generate-name
helm install bitnami/grafana --generate-name
helm list
kubectl get all
# Run in another shell 
kubectl port-forward service/grafana-<...> 8000:3000 --address 0.0.0.0
# For Grafana UI
# USER: admin
# Password: Use the command given
!helm search repo prometheus
# Kube Prometheus
!helm install bitnami/kube-prometheus --generate-name
!kubectl get svc
# Run in another shell 
# !kubectl port-forward svc/kube-prometheus-1699111085-prometheus  9000:9090 --address 0.0.0.0
!kubectl get all
#-------------- Observability [END] --------------------#


#-------------- Cleanup [START] --------------------#
gcloud compute firewall-rules delete $FIREWALL_RULES_NAME-observability --quiet 

#-------------- End [START] --------------------#