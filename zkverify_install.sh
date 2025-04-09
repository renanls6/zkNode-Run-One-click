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
    echo -e "${GREEN}       ✨ zkVerify Node Installation Script ✨${NC}"
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

# Main menu function
function main_menu() {
    while true; do
        display_header
        echo -e "${BLUE}To exit the script, press Ctrl+C${NC}"
        echo -e "${YELLOW}Please select an operation:${NC}"
        echo -e "1) ${GREEN}Install zkVerify Node${NC}"
        echo -e "2) ${CYAN}View zkVerify Node logs${NC}"
        echo -e "3) ${RED}Remove zkVerify Node${NC}"
        echo -e "4) ${MAGENTA}Exit script${NC}"
        
        read -p "$(echo -e "${BLUE}Enter your choice: ${NC}")" choice

        case $choice in
            1) 
                install_zkverify_node
                ;;
            2)
                view_logs
                ;;
            3)
                remove_zkverify_node
                ;;
            4)
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

# Install zkVerify Node function
function install_zkverify_node() {
    display_header
    # System update and Docker installation
    echo -e "${YELLOW}System update and installing necessary packages...${NC}"
    sudo apt update && sudo apt install -y docker.io docker-compose jq sed

    # Add user to docker group
    echo -e "${YELLOW}Adding user to Docker group...${NC}"
    sudo usermod -aG docker $USER
    newgrp docker

    # Create user for the Node
    echo -e "${YELLOW}Creating user for Node...${NC}"
    sudo useradd -m -s /bin/bash shareithub
    sudo passwd shareithub
    sudo usermod -aG docker shareithub
    ls -ld /home/shareithub
    echo -e "${YELLOW}User 'shareithub' created successfully!${NC}"

    # Switch to the created user
    echo -e "${YELLOW}Logging in as 'shareithub'...${NC}"
    su - shareithub

    # Clone repository
    echo -e "${YELLOW}Cloning zkVerify repository...${NC}"
    git clone https://github.com/zkVerify/compose-zkverify-simplified.git
    cd compose-zkverify-simplified

    # Start Node initialization
    echo -e "${YELLOW}Starting node initialization...${NC}"
    ./scripts/init.sh

    # Update Node
    echo -e "${YELLOW}Updating Node...${NC}"
    cd ~/zkverify-repo
    git pull
    ./scripts/update.sh

    # Start Node
    echo -e "${YELLOW}Starting the Node...${NC}"
    ./scripts/start.sh

    # Compose Docker container
    echo -e "${YELLOW}Composing Docker...${NC}"
    docker compose -f /home/shareithub/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d

    echo -e "${GREEN}zkVerify Node installation complete!${NC}"
}

# View zkVerify Node logs function
function view_logs() {
    display_header
    echo -e "${YELLOW}Viewing zkVerify Node logs...${NC}"
    docker logs -f validator-node
}

# Remove zkVerify Node function
function remove_zkverify_node() {
    display_header
    echo -e "${RED}Removing zkVerify Node...${NC}"

    # Stop and remove Docker containers
    echo -e "${YELLOW}Stopping and removing Docker containers...${NC}"
    cd /root/compose-zkverify-simplified
    docker compose down

    # Remove repository files
    echo -e "${YELLOW}Removing related files...${NC}"
    rm -rf ~/compose-zkverify-simplified

    echo -e "${GREEN}zkVerify Node successfully removed!${NC}"
}

# Call main menu function
main_menu
