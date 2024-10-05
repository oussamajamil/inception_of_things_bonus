#!/bin/bash

set -e


screen -S gitlab_port_forward -X quit || echo "gitlab_port_forward not found"
screen -S argocd_port_forward -X quit || echo "argocd_port_forward not found"
screen -S wil_playground_port_forward -X quit  || echo "wil_playground_port_forward not found"

#uninstall gitlab
helm uninstall gitlab -n gitlab || echo "Gitlab resources not found"

#uninstall argocd
k3d cluster delete argocd ||  echo "ArgoCD resources not found"

#delete all namespaces
kubectl delete namespace argocd || echo "argocd namespace not found"
kubectl delete namespace dev || echo "dev namespace not found"
kubectl delete namespace gitlab || echo "gitlab namespace not found"

#remove helm
snap remove helm || echo "helm not found"


kubectl delete -f ${BONUSDIR}/confs/wil-playground/manifests/wil42.yaml || echo "wil42.yaml not found" || echo "wil42.yaml not found"
kubectl delete -f ${BONUSDIR}/confs/deployment.yaml || echo "deployment.yaml not found or already deleted" || echo "deployment.yaml not found or already deleted"

kubectl delete -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -n argocd || echo "ArgoCD resources not found" || echo "ArgoCD resources not found"

if k3d cluster get argocd 2>/dev/null; then
 k3d cluster delete argocd
else
  echo "k3d cluster 'argocd' not found"
fi

# clean up docker and k3d

apt-get remove -y docker-ce docker-ce-cli containerd.io || echo "docker not found"
apt-get remove -y k3d || echo "k3d not found"

apt-get autoremove -y || echo "autoremove failed"

usermod -aG docker $USER || echo "usermod failed"

rm -rf /etc/apt/sources.list.d/docker.list || echo "docker.list not found"
rm -rf /etc/apt/keyrings/docker.asc || echo "docker.asc not found"

rm -rf /usr/local/bin/kubectl || echo "kubectl not found"

rm -rf /etc/hosts || echo "hosts not found"

#clean kubectl
rm -rf /usr/local/bin/kubectl || echo "kubectl not found"
