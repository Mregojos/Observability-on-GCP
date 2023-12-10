# https://helm.sh
wget https://get.helm.sh/helm-v3.13.1-linux-amd64.tar.gz
tar -zxvf helm-v3.13.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64
rm helm-v*
# Verify
helm help

# Kube-Prometheus-Stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# I add namespace monitoring
kubectl create namespace monitoring
helm install my-kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 52.1.0 -n monitoring



# Option B
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install bitnami/prometheus --generate-name
helm install bitnami/grafana --generate-name
helm install bitnami/kube-prometheus --generate-name