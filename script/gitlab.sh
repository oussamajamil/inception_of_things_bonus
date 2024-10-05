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