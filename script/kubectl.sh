#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RESET='\033[0m' # Reset color


#instalation docker 

echo -e "${CYAN}--------------------------------------------${RESET}"
echo -e "${CYAN} install GPG key for Docker${RESET}"
echo -e "${CYAN}--------------------------------------------${RESET}"
 apt-get update
 apt-get install -y ca-certificates curl
 install -m 0755 -d /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
 chmod a+r /etc/apt/keyrings/docker.asc

echo -e "${CYAN}--------------------------------------------${RESET}"

echo -e "${CYAN} Add Docker repository${RESET}"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null
 apt-get update

echo -e "${CYAN}--------------------------------------------${RESET}"

echo -e "${CYAN} Install Docker Engen${RESET}"
 apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
 systemctl start docker

 systemctl enable docker

echo "Waiting for Docker to start..."
until  systemctl is-active --quiet docker; do
  echo "Docker is not running yet. Waiting..."
  sleep 5
done

if  systemctl is-active --quiet docker; then
	echo -e "\033[0;32mDocker is active and running.\033[0m"

else
	echo -e "\e[91mFailed to start Docker. Exiting.\e[0m"
  exit 1
fi

echo -e "${CYAN}--------------------------------------------${RESET}"

echo -e "${CYAN} Add user to Docker group${RESET}"
 usermod -aG docker $USER

echo -e "${CYAN}--------------------------------------------${RESET}"






#instalation kubeclt

echo -e "${CYAN}--------------------------------------------${RESET}"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

if [ $? -eq 0 ]; then
     install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
     rm -f kubectl kubectl.sha256
    echo -e "\033[0;32mChecksum is correct. Proceeding with installation.\033[0m"
else
    echo -e "\e[91mChecksum is incorrect. Exiting.\e[0m"
    exit 1
fi

