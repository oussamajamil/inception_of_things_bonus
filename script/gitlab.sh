#!/bin/bash


# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RESET='\033[0m' # Reset color



#install gitlab with helm
echo -e "${CYAN}-------Install gitlab---------------${RESET}"

helm repo add gitlab https://charts.gitlab.io/

helm search repo gitlab

helm repo update



echo -e "${CYAN}-----------gitlab done-------------------${RESET}"


helm upgrade --install gitlab gitlab/gitlab \
	-f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain="gitlab.ojamil.com" \
  --set certmanager-issuer.email="ojamil1999@gmail.com" \
  --set global.hosts.https="false" \
  --set global.ingress.configureCertmanager="false" \
  --set gitlab-runner.install="false" \
  -n gitlab



password=$(kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' -n gitlab | base64 --decode)
echo -e "${CYAN}-----------gitlab password: ${password}  -------------------${RESET}"

#wait for gitlab to be ready

kubectl wait -n gitlab --for=condition=available deployment --all --timeout=-1s


echo -e "${CYAN}-----------gitlab is ready-------------------${RESET}"

#forwad port to access gitlab
screen -dmS gitlab_port_forward bash -c 'kubectl port-forward --address 0.0.0.0 svc/gitlab-webservice-default -n gitlab 8085:8181'

screen -dmS argocd_port_forward bash -c 'kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443'


#  kubectl apply -f ${SOURCEDIR}/config/wil-playground/manifests/wil42.yaml
 kubectl apply -f ${SOURCEDIR}/config/deployment.yaml

echo -e "${CYAN}-----------gitlab port forward-------------------${RESET}"
echo -e "${CYAN}-----------gitlab url http://gitlab.ojamil.com:8085-------------------${RESET}"