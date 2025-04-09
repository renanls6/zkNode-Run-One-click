#!/bin/bash

# Exibir título e descrição
display_header() {
    clear
    echo -e "${CYAN}"
    echo -e "        ██████╗ █████╗ ███╗   ██╗████████╗███████╗${NC}"
    echo -e "        ██╔══██╗██╔══██╗████╗  ██║╚══██╔══╝██╔════╝${NC}"
    echo -e "        ██████╔╝███████║██╔██╗ ██║   ██║   █████╗  ${NC}"
    echo -e "        ██╔══██╗██╔══██║██║╚██╗██║   ██║   ██╔══╝  ${NC}"
    echo -e "        ██████╔╝██║  ██║██║ ╚████║   ██║   ███████╗${NC}"
    echo -e "        ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝${NC}"
    echo -e "${CYAN}=========================================================${NC}"
    echo -e "${GREEN}         ✨ Pipe Network Installation Script ✨${NC}"
    echo -e "${CYAN}=========================================================${NC}"
    echo -e " 📱 Telegram Channel: @CryptoAirdropHindi "
    echo -e " 🎥 YouTube: https://www.youtube.com/@CryptoAirdropHindi6 "
    echo -e " 💻 GitHub Repo: https://github.com/CryptoAirdropHindi/ "
}

# Função para criar uma Screen
create_screen() {
    display_header
    echo -e "${YELLOW}Criando e iniciando uma nova Screen chamada 'pipe'...${NC}"
    screen -S pipe
}

# Pré-requisitos
function install_prerequisites() {
    display_header
    echo -e "${YELLOW}Atualizando o sistema...${NC}"
    sudo apt update && sudo apt upgrade -y

    # Instalar Screen
    echo -e "${YELLOW}Instalando Screen...${NC}"
    sudo apt install screen -y

    # Criar a screen
    create_screen

    # Baixar o script pop
    echo -e "${YELLOW}Baixando o script pop...${NC}"
    curl -L -o pop "https://dl.pipecdn.app/v0.2.8/pop"

    # Tornar o script pop executável
    echo -e "${YELLOW}Tornando o script pop executável...${NC}"
    chmod +x pop

    # Criar diretório de cache
    echo -e "${YELLOW}Criando diretório de cache...${NC}"
    mkdir download_cache
}

# Configure sua Wallet
function configure_wallet() {
    display_header
    echo -e "${GREEN}Para prosseguir, adicione sua PrivateKey da Phantom Wallet.${NC}"

    # Solicitar PrivateKey
    read -p "Digite a PrivateKey da sua Phantom Wallet: " private_key
    echo -e "${YELLOW}Configurando a Wallet com a chave fornecida...${NC}"
    sudo ./pop --pubKey $private_key
}

# Cadastro com Código de Referência
function referral_signup() {
    display_header
    echo -e "${GREEN}Cadastre-se com o Código de Referência.${NC}"

    # Código de referência
    echo -e "${YELLOW}Entre com o Código de Referência...${NC}"
    ./pop --signup-by-referral-route 42133ad69ee486f
}

# Fechar a Screen
function close_screen() {
    display_header
    echo -e "${YELLOW}Fechando a Screen...${NC}"
    echo -e "${CYAN}Para fechar a screen, pressione: CTRL + ALT + D${NC}"
}

# Verificar Pontuação
function check_status() {
    display_header
    echo -e "${YELLOW}Verificando a pontuação...${NC}"
    ./pop --status
}

# Função principal do menu
function main_menu() {
    while true; do
        display_header
        echo -e "${BLUE}Para sair do script, pressione Ctrl+C${NC}"
        echo -e "${YELLOW}Selecione uma operação:${NC}"
        echo -e "1) ${GREEN}Instalar Pré-requisitos e Screen${NC}"
        echo -e "2) ${CYAN}Configurar Wallet${NC}"
        echo -e "3) ${MAGENTA}Cadastro com Código de Referência${NC}"
        echo -e "4) ${CYAN}Verificar Pontuação${NC}"
        echo -e "5) ${RED}Fechar Screen${NC}"
        echo -e "6) ${MAGENTA}Sair do script${NC}"

        read -p "$(echo -e "${BLUE}Digite sua escolha: ${NC}")" choice

        case $choice in
            1) 
                install_prerequisites
                ;;
            2)
                configure_wallet
                ;;
            3)
                referral_signup
                ;;
            4)
                check_status
                ;;
            5)
                close_screen
                ;;
            6)
                echo -e "${GREEN}Saindo do script!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opção inválida, por favor escolha novamente.${NC}"
                ;;
        esac

        echo -e "${YELLOW}Pressione qualquer tecla para continuar...${NC}"
        read -n 1 -s
    done
}

# Executar o menu principal
main_menu
