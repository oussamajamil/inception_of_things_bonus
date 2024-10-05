#!/bin/bash


# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RESET='\033[0m' # Reset color


echo -e "${CYAN}-------Install argocd---------------${RESET}"

# Install argocd check if argocd is already installed
if ! k3d cluster get argocd > /dev/null 2>&1; then
    k3d cluster create argocd -p "8888:30888@loadbalancer" 
    echo -e "${CYAN}-----------argocd done-------------------${RESET}"
else
    echo -e "${YELLOW}-----------argocd already installed-------------------${RESET}"
fi

kubectl get namespace argocd > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${YELLOW}-----------argocd namespace already exist-------------------${RESET}"
else
     kubectl create namespace argocd --save-config
    echo -e "${CYAN}-----------argocd namespace created-------------------${RESET}"
fi

kubectl get namespace dev > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${YELLOW}-----------dev namespace already exist-------------------${RESET}"
else
     kubectl create namespace dev --save-config
    echo -e "${CYAN}-----------dev namespace created-------------------${RESET}"
fi


 kubectl get namespace gitlab > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${YELLOW}-----------gitlab namespace already exist-------------------${RESET}"
else
     kubectl create namespace gitlab --save-config
    echo -e "${CYAN}-----------gitlab namespace created-------------------${RESET}"
fi


 kubectl get deployment -n argocd argocd-server > /dev/null 2>&1
if [ $? -ne 0 ]; then
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
fi



 kubectl apply -f ${SOURCEDIR}/config/deployment.yaml

until   kubectl get pods -n argocd | grep -q "Running"; do
    echo -e "${YELLOW}Waiting for argocd-server pod to be ready...${RESET}"
    sleep 5
done



echo -e "${YELLOW}Get argoCd password${RESET}"
while true; do
    PASSWORD=$( kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' 2>/dev/null | base64 -d)
    echo -e "|||||${YELLOW}ArgoCD password: ${PASSWORD}       ${RESET}|||||"
    if [ -n "$PASSWORD" ]; then
        break
    fi
    sleep 20
done




echo -e "${YELLOW}---- create forward port for argocd and wil-playground----${RESET}"

screen -dmS argocd_port_forward bash -c ' kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443'

# POD=$(kubectl get pods -n dev -l app=wil-playground -o jsonpath="{.items[0].metadata.name}")
# screen -dmS wil_playground_port_forward bash -c "kubectl port-forward --address 0.0.0.0 -n dev $POD 8888:8888"
echo -e "${YELLOW}---- argocd and wil-playground port forward done----${RESET}"

echo -e "${YELLOW}ArgoCD is ready and running on http://ojamil.com:8080${RESET}"