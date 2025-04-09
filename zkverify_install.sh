#!/bin/bash

# Colors for display
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
    echo -e "${CYAN}########################################################${NC}"
    echo -e "${BLUE}          zkVerify Node Setup and Management          ${NC}"
    echo -e "${CYAN}########################################################${NC}"
    echo -e "${YELLOW}This script helps you install and manage zkVerify Node.${NC}"
    echo -e "${BLUE}Please choose an option from the menu below.${NC}"
}

# Check if script is run as root
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}This script requires root privileges.${NC}"
    echo -e "${YELLOW}Please try running with 'sudo -i' to switch to root user, then run this script again.${NC}"
    exit 1
fi

# Install Docker and dependencies
install_docker() {
    echo -e "${YELLOW}Updating system and installing Docker and dependencies...${NC}"
    sudo apt update && sudo apt install -y docker.io docker-compose jq sed
    echo -e "${GREEN}Docker and dependencies installed successfully!${NC}"
}

# Add user to Docker group
add_user_to_docker_group() {
    echo -e "${YELLOW}Adding current user to Docker group...${NC}"
    sudo usermod -aG docker $USER
    newgrp docker
    echo -e "${GREEN}User added to Docker group successfully!${NC}"
}

# Create user for the Node
create_node_user() {
    read -p "Enter a name for the node user (default: shareithub): " NODE_USER
    NODE_USER=${NODE_USER:-shareithub}

    echo -e "${YELLOW}Creating user '$NODE_USER' for the Node...${NC}"
    sudo useradd -m -s /bin/bash $NODE_USER
    sudo passwd $NODE_USER
    sudo usermod -aG docker $NODE_USER
    ls -ld /home/$NODE_USER
    echo -e "${GREEN}User '$NODE_USER' created successfully!${NC}"
}

# Clone repository and configure Node
clone_repository() {
    echo -e "${YELLOW}Cloning zkVerify repository...${NC}"
    git clone https://github.com/zkVerify/compose-zkverify-simplified.git
    cd compose-zkverify-simplified
    echo -e "${GREEN}Repository cloned successfully!${NC}"
}

# Start Node initialization
initialize_node() {
    echo -e "${YELLOW}Starting Node initialization...${NC}"
    ./scripts/init.sh
}

# Update Node
update_node() {
    echo -e "${YELLOW}Updating the Node...${NC}"
    cd ~/zkverify-repo
    git pull
    ./scripts/update.sh
}

# Start Node
start_node() {
    echo -e "${YELLOW}Starting the Node...${NC}"
    ./scripts/start.sh
}

# Compose Docker containers
compose_docker() {
    read -p "Enter the path to your user folder (e.g., /home/your_user): " USER_FOLDER
    USER_FOLDER=${USER_FOLDER:-/home/$USER}

    echo -e "${YELLOW}Composing Docker containers...${NC}"
    docker compose -f $USER_FOLDER/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d
    echo -e "${GREEN}Docker containers are up and running!${NC}"
}

# View Node logs
view_logs() {
    echo -e "${YELLOW}Viewing Node logs...${NC}"
    docker logs -f validator-node
}

# Main menu function
function main_menu() {
    while true; do
        display_header
        echo -e "${BLUE}To exit the script, press Ctrl+C${NC}"
        echo -e "${YELLOW}Please select an operation:${NC}"
        echo -e "1) ${GREEN}Update & Install Docker${NC}"
        echo -e "2) ${CYAN}Add User to Docker Group${NC}"
        echo -e "3) ${RED}Create User for Node${NC}"
        echo -e "4) ${MAGENTA}Clone Repository and Initialize Node${NC}"
        echo -e "5) ${CYAN}Update Node${NC}"
        echo -e "6) ${GREEN}Start Node${NC}"
        echo -e "7) ${YELLOW}Compose Docker Containers${NC}"
        echo -e "8) ${BLUE}View Node Logs${NC}"
        echo -e "9) ${RED}Exit Script${NC}"

        read -p "$(echo -e "${BLUE}Enter your choice: ${NC}")" choice

        case $choice in
            1)
                install_docker
                ;;
            2)
                add_user_to_docker_group
                ;;
            3)
                create_node_user
                ;;
            4)
                clone_repository
                initialize_node
                ;;
            5)
                update_node
                ;;
            6)
                start_node
                ;;
            7)
                compose_docker
                ;;
            8)
                view_logs
                ;;
            9)
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

# Call main menu function
main_menu
