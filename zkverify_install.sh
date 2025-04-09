#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[1;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Display header
display_header() {
    clear
    echo -e "${CYAN}"
    echo -e "    ${RED}██╗  ██╗ █████╗ ███████╗ █████╗ ███╗   ██╗${NC}"
    echo -e "    ${GREEN}██║  ██║██╔══██╗██╔════╝██╔══██╗████╗  ██║${NC}"
    echo -e "    ${BLUE}███████║███████║███████╗███████║██╔██╗ ██║${NC}"
    echo -e "    ${YELLOW}██╔══██║██╔══██║╚════██║██╔══██║██║╚██╗██║${NC}"
    echo -e "    ${MAGENTA}██║  ██║██║  ██║███████║██║  ██║██║ ╚████║${NC}"
    echo -e "    ${CYAN}╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝${NC}"
    echo -e "${BLUE}=======================================================${NC}"
    echo -e "${GREEN}       ✨ zknode Installation Script ✨${NC}"
    echo -e "${BLUE}=======================================================${NC}"
    echo -e "${CYAN} Telegram Channel: CryptoAirdropHindi @CryptoAirdropHindi ${NC}"  
    echo -e "${CYAN} Follow us on social media for updates and more ${NC}"
    echo -e " 📱 Telegram: https://t.me/CryptoAirdropHindi6 "
    echo -e " 🎥 YouTube: https://www.youtube.com/@CryptoAirdropHindi6 "
    echo -e " 💻 GitHub Repo: https://github.com/CryptoAirdropHindi/ "
}

# Check if script is run as root
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}This script requires root privileges.${NC}"
    echo -e "${YELLOW}Please try running with 'sudo -i' to switch to root user, then run this script again.${NC}"
    exit 1
fi

# Script save path
SCRIPT_PATH="$HOME/zknode.sh"

# Main menu function
function main_menu() {
    while true; do
        display_header
        echo -e "${BLUE}To exit the script, press Ctrl+C${NC}"
        echo -e "${YELLOW}Please select an operation:${NC}"
        echo -e "1) ${GREEN}Install zknode${NC}"
        echo -e "2) ${CYAN}View zknode logs${NC}"
        echo -e "3) ${RED}Remove zknode${NC}"
        echo -e "4) ${MAGENTA}Install & Start Validator Node${NC}"
        echo -e "5) ${MAGENTA}Exit script${NC}"
        
        read -p "$(echo -e "${BLUE}Enter your choice: ${NC}")" choice

        case $choice in
            1) 
                install_zknode
                ;;
            2)
                view_logs
                ;;
            3)
                remove_zknode
                ;;
            4)
                install_and_start_validator_node
                ;;
            5)
                echo -e "${GREEN}Exiting script!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option, please choose again.${NC}"
                ;;
        esac

        echo -e "${YELLOW}Press any key to continue...${NC}"
        read -n 1 -s
    done
}

# Install and Start Validator Node function (automated process)
function install_and_start_validator_node() {
    display_header

    # Update & install Docker and required packages
    echo -e "${YELLOW}Updating and installing Docker and dependencies...${NC}"
    sudo apt update && sudo apt install -y docker.io docker-compose jq sed

    # Add user to Docker group
    echo -e "${YELLOW}Adding user to Docker group...${NC}"
    sudo usermod -aG docker $USER
    newgrp docker

    # Check Docker installation
    echo -e "${CYAN}Checking Docker...${NC}"
    docker --version || { echo -e "${RED}[Error] Docker installation failed.${NC}"; exit 1; }

    # Create a user for the node (change 'shareithub' to the desired username)
    echo -e "${YELLOW}Creating user for Validator Node...${NC}"
    sudo useradd -m -s /bin/bash shareithub
    sudo passwd shareithub
    sudo usermod -aG docker shareithub
    ls -ld /home/shareithub

    # Switch to the new user (automatically logging in)
    echo -e "${YELLOW}Switching to user 'shareithub'...${NC}"
    su - shareithub

    # Clone the repository for the validator node
    echo -e "${YELLOW}Cloning the repository...${NC}"
    git clone https://github.com/zkVerify/compose-zkverify-simplified.git
    cd compose-zkverify-simplified

    # Start the initialization script and select 'Validator Node'
    echo -e "${YELLOW}Running the initialization script...${NC}"
    ./scripts/init.sh

    # Update the node (automated pull and update)
    echo -e "${YELLOW}Updating the Node...${NC}"
    cd ~/zkverify-repo
    git pull
    ./scripts/update.sh

    # Start the Node
    echo -e "${YELLOW}Starting the Node...${NC}"
    ./scripts/start.sh

    # Start Docker Compose
    echo -e "${YELLOW}Starting Docker Compose for Validator Node...${NC}"
    docker compose -f /home/shareithub/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d

    # Show logs
    echo -e "${CYAN}Checking logs...${NC}"
    docker logs -f validator-node
}

# View zknode logs function
function view_logs() {
    display_header
    echo -e "${YELLOW}Viewing zknode logs...${NC}"
    docker logs -f zknode
}

# Remove zknode function
function remove_zknode() {
    display_header
    echo -e "${RED}Removing zknode...${NC}"

    # Stop and remove Docker containers
    echo -e "${YELLOW}Stopping and removing Docker containers...${NC}"
    cd /root/zknode-container-starter
    docker compose down

    # Remove repository files
    echo -e "${YELLOW}Removing related files...${NC}"
    rm -rf ~/zknode-container-starter

    # Remove Docker image
    echo -e "${YELLOW}Removing Docker image...${NC}"
    docker rmi zknode/hello-world:latest

    echo -e "${GREEN}zknode successfully removed!${NC}"
}

# Call main menu function
main_menu
