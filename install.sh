#!/usr/bin/env bash

# nananvim installer script
# https://github.com/m4c4r0n1n/nananvim

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
NVIM_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
NVIM_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"
REPO_URL="https://github.com/m4c4r0n1n/nananvim.git"
BACKUP_DIR="$HOME/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)"
MIN_NVIM_VERSION="0.10.0"

# Logging
LOG_FILE="/tmp/nananvim_install_$(date +%Y%m%d_%H%M%S).log"

log() {
    echo "$1" | tee -a "$LOG_FILE"
}

print_banner() {
    echo -e "${MAGENTA}${BOLD}"
    cat << "EOF"
                                          _         
 _ __   __ _ _ __   __ _ _ ____   __(_)_ __ ___  
| '_ \ / _` | '_ \ / _` | '_ \ \ / /| | '_ ` _ \ 
| | | | (_| | | | | (_| | | | \ V / | | | | | | |
|_| |_|\__,_|_| |_|\__,_|_| |_|\_/  |_|_| |_| |_|
                                                  
EOF
    echo -e "${NC}"
    echo -e "${CYAN}Modern Neovim Distribution${NC}"
    echo -e "${BLUE}https://github.com/m4c4r0n1n/nananvim${NC}"
    echo
}

print_error() {
    echo -e "${RED}${BOLD}[ERROR]${NC} $1" >&2
    echo "[ERROR] $1" >> "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}${BOLD}[✓]${NC} $1"
    echo "[SUCCESS] $1" >> "$LOG_FILE"
}

print_info() {
    echo -e "${BLUE}${BOLD}[INFO]${NC} $1"
    echo "[INFO] $1" >> "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}${BOLD}[WARNING]${NC} $1"
    echo "[WARNING] $1" >> "$LOG_FILE"
}

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            VER=$VERSION_ID
        elif type lsb_release >/dev/null 2>&1; then
            OS=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
            VER=$(lsb_release -sr)
        elif [ -f /etc/debian_version ]; then
            OS=debian
            VER=$(cat /etc/debian_version)
        elif [ -f /etc/arch-release ]; then
            OS=arch
        elif [ -f /etc/fedora-release ]; then
            OS=fedora
        elif [ -f /etc/gentoo-release ]; then
            OS=gentoo
        else
            OS=unknown
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS=macos
    else
        OS=unknown
    fi
    
    echo "$OS"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

version_compare() {
    if [[ "$1" == "$2" ]]; then
        return 0
    fi
    
    local IFS=.
    local i ver1=($1) ver2=($2)
    
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 1
        fi
    done
    return 0
}

install_dependencies_arch() {
    print_info "Installing dependencies for Arch Linux..."
    
    local packages=(
        git
        neovim
        ripgrep
        fd
        imagemagick
        nodejs
        npm
        python
        python-pip
        clang
        lazygit
    )
    
    if ! check_command "kitty"; then
        packages+=(kitty)
    fi
    
    sudo pacman -S --needed --noconfirm "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }
    
    print_success "Dependencies installed"
}

install_dependencies_ubuntu() {
    print_info "Installing dependencies for Ubuntu/Debian..."
    
    sudo apt update
    
    local packages=(
        git
        ripgrep
        fd-find
        imagemagick
        nodejs
        npm
        python3
        python3-pip
        clang
        curl
        build-essential
    )
    
    if ! check_command "kitty"; then
        packages+=(kitty)
    fi
    
    sudo apt install -y "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }
    
    # Fix fd naming on Ubuntu
    if check_command "fdfind" && ! check_command "fd"; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
        print_info "Created fd symlink"
    fi
    
    # Install Neovim AppImage if version is old
    if ! check_command "nvim" || ! version_compare "$(nvim --version | head -1 | cut -d' ' -f2)" "$MIN_NVIM_VERSION"; then
        print_info "Installing Neovim 0.10+ via AppImage..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
    fi
    
    # Install lazygit
    if ! check_command "lazygit"; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
        rm lazygit.tar.gz
    fi
    
    print_success "Dependencies installed"
}

install_dependencies_fedora() {
    print_info "Installing dependencies for Fedora..."
    
    local packages=(
        git
        neovim
        ripgrep
        fd-find
        ImageMagick
        nodejs
        npm
        python3
        python3-pip
        clang
        lazygit
    )
    
    if ! check_command "kitty"; then
        packages+=(kitty)
    fi
    
    sudo dnf install -y "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }
    
    print_success "Dependencies installed"
}

install_dependencies_macos() {
    print_info "Installing dependencies for macOS..."
    
    if ! check_command "brew"; then
        print_error "Homebrew is required but not installed"
        print_info "Install from: https://brew.sh"
        exit 1
    fi
    
    local packages=(
        neovim
        ripgrep
        fd
        imagemagick
        node
        python
        llvm
        lazygit
    )
    
    if ! check_command "kitty"; then
        packages+=(kitty)
    fi
    
    brew install "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }
    
    print_success "Dependencies installed"
}

check_neovim_version() {
    if ! check_command "nvim"; then
        print_error "Neovim is not installed"
        return 1
    fi
    
    local nvim_version=$(nvim --version | head -1 | cut -d' ' -f2 | sed 's/^v//')
    
    if version_compare "$nvim_version" "$MIN_NVIM_VERSION"; then
        print_success "Neovim version $nvim_version meets requirements"
    else
        print_error "Neovim version $nvim_version is too old (need $MIN_NVIM_VERSION+)"
        return 1
    fi
}

backup_existing_config() {
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        print_info "Backing up existing config to $BACKUP_DIR"
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        print_success "Backup created"
    fi
    
    # Clean Neovim data directories
    print_info "Cleaning Neovim cache and state..."
    rm -rf "$NVIM_DATA_DIR/lazy"
    rm -rf "$NVIM_CACHE_DIR"
    rm -rf "$NVIM_STATE_DIR/lazy"
    rm -f "$NVIM_STATE_DIR/lazy-lock.json"
}

install_nananvim() {
    print_info "Installing nananvim..."
    
    git clone --depth 1 "$REPO_URL" "$NVIM_CONFIG_DIR" || {
        print_error "Failed to clone repository"
        return 1
    }
    
    print_success "nananvim installed"
}

verify_installation() {
    print_info "Verifying installation..."
    
    # Check if config exists
    if [ ! -d "$NVIM_CONFIG_DIR" ]; then
        print_error "Config directory not found"
        return 1
    fi
    
    # Check for init.lua
    if [ ! -f "$NVIM_CONFIG_DIR/init.lua" ]; then
        print_error "init.lua not found"
        return 1
    fi
    
    # Check for required directories
    for dir in lua/config lua/plugins; do
        if [ ! -d "$NVIM_CONFIG_DIR/$dir" ]; then
            print_error "Required directory $dir not found"
            return 1
        fi
    done
    
    print_success "Installation verified"
}

post_install_message() {
    echo
    echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}     nananvim installation completed successfully!${NC}"
    echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "  1. ${BOLD}nvim${NC}              - Launch Neovim (plugins will auto-install)"
    echo -e "  2. ${BOLD}:checkhealth${NC}     - Verify everything is working"
    echo -e "  3. ${BOLD}:Copilot setup${NC}   - Configure GitHub Copilot (optional)"
    echo
    echo -e "${YELLOW}Tips:${NC}"
    echo -e "  • Press ${BOLD}f${NC} to find files"
    echo -e "  • Press ${BOLD}<Space>${NC} to see keybindings"
    echo -e "  • Run ${BOLD}:Mason${NC} to manage language servers"
    echo
    
    if [ -d "$BACKUP_DIR" ]; then
        echo -e "${BLUE}Your old config was backed up to:${NC}"
        echo -e "  $BACKUP_DIR"
        echo
    fi
    
    echo -e "${GREEN}Happy coding!${NC}"
    echo
    echo -e "${BLUE}Documentation: https://github.com/m4c4r0n1n/nananvim${NC}"
    echo -e "${BLUE}Issues: https://github.com/m4c4r0n1n/nananvim/issues${NC}"
}

main() {
    print_banner
    
    # Detect OS
    OS=$(detect_os)
    print_info "Detected OS: $OS"
    
    # Check for existing installation
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        echo -e "${YELLOW}Existing Neovim configuration found${NC}"
        read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi
    
    # Install dependencies based on OS
    case "$OS" in
        arch)
            install_dependencies_arch
            ;;
        ubuntu|debian|pop|linuxmint)
            install_dependencies_ubuntu
            ;;
        fedora)
            install_dependencies_fedora
            ;;
        macos)
            install_dependencies_macos
            ;;
        gentoo)
            print_warning "Gentoo support coming soon! Please install dependencies manually:"
            echo "  emerge -av app-editors/neovim sys-apps/ripgrep sys-apps/fd"
            echo "  emerge -av media-gfx/imagemagick net-libs/nodejs"
            echo "  emerge -av dev-lang/python sys-devel/clang"
            exit 0
            ;;
        *)
            print_error "Unsupported OS: $OS"
            print_info "Please install dependencies manually and run:"
            echo "  git clone $REPO_URL $NVIM_CONFIG_DIR"
            exit 1
            ;;
    esac
    
    # Check Neovim version
    check_neovim_version || exit 1
    
    # Backup existing config
    backup_existing_config
    
    # Install nananvim
    install_nananvim || exit 1
    
    # Verify installation
    verify_installation || exit 1
    
    # Show success message
    post_install_message
    
    # Log file location
    print_info "Installation log saved to: $LOG_FILE"
}

# Run main function
main "$@"
