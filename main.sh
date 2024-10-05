#!/bin/bash
# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RESET='\033[0m' # Reset color



export SOURCEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ${SOURCEDIR}

# active cleaning script
echo -e "${YELLOW}This script will clean your machine.${RESET}"
bash ${SOURCEDIR}/script/clean.sh
echo -e "${GREEN}Your machine has been cleaned successfully.${RESET}"

#.. update host in /etc/hosts
entry="127.0.0.1 gitlab.ojamil.com"
hosts_file="/etc/hosts"

# //// add permission to /etc/hosts
sudo chmod a+w /etc/hosts

# Check if the entry exists
if ! grep -q "$entry" "$hosts_file"; then
    echo "$entry" | sudo tee -a "$hosts_file" > /dev/null
    echo "Entry added to /etc/hosts."
else
    echo "Entry already exists in /etc/hosts."
fi


# Function to display a welcome message with ASCII art and color
function welcome_message() {
echo -e "${CYAN}------------------------------------------------------------------${RESET}"
echo -e "${CYAN}|                                                                 |${RESET}"
echo -e "${CYAN}|    ${YELLOW}WELCOME TO THE INCEPTION PROJECT Part bonus${CYAN}                  |${RESET}"
echo -e "${CYAN}|                                                                 |${RESET}"
echo -e "${CYAN}-------------------------------------------------------------------${RESET}"
echo ""    
echo -e "${RED}"
echo -e "  ____    ___   ___  _         _ _   _"
echo -e " / __ \      |/     \| \      /|(_) | |"
echo -e "| |  | |     ||     ||  \\    / | _  | |"
echo -e "| |  | | _   ||_____||    \\ /  || | | |"
echo -e "| |__| |/    ||     ||         || | | |"
echo -e " \____//_____||     ||         ||_| |_|"
echo -e "                                          "
echo -e "${CYAN}----------------------------------------${RESET}"
echo ""


echo -e "${YELLOW}This script will install curl on your machine.${RESET}"
# sudo apt-get update
# sudo apt-get install curl -y
echo -e "${GREEN}Curl has been installed successfully.${RESET}"

echo -e "${YELLOW}This script will install kubectl and docker on your machine.${RESET}"
bash ${SOURCEDIR}/script/kubectl.sh

echo -e "${YELLOW}This script will install k3d on your machine.${RESET}"
bash ${SOURCEDIR}/script/k3d.sh

echo -e "${YELLOW}This script will install and setup argocd on your machine.${RESET}"
bash ${SOURCEDIR}/script/argocd.sh

echo -e "${YELLOW}This script will install and setup helm on your machine.${RESET}"
bash ${SOURCEDIR}/script/helm.sh

echo -e "${YELLOW}This script will setup gitlab on your machine.${RESET}"
bash ${SOURCEDIR}/script/gitlab.sh
}
welcome_message
