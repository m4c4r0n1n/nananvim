#!/usr/bin/env bash

# nananvim installer
# https://github.com/m4c4r0n1n/nananvim
#
# This script installs the dependencies, backs up your current Neovim config
# and clones nananvim to ~/.config/nvim.

set -e

# Colors for the output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No color

# Settings
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
NVIM_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
NVIM_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"
REPO_URL="https://github.com/m4c4r0n1n/nananvim.git"
BACKUP_DIR="$HOME/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)"
MIN_NVIM_VERSION="0.12.0"

# Log file
LOG_FILE="/tmp/nananvim_install_$(date +%Y%m%d_%H%M%S).log"

print_banner() {
    echo -e "${MAGENTA}${BOLD}"
    cat << "BANNER"
                                     _         
 _ __   __ _ _ __   __ _ _ ____   __(_)_ __ ___  
| '_ \ / _` | '_ \ / _` | '_ \ \ / /| | '_ ` _ \ 
| | | | (_| | | | | (_| | | | \ V / | | | | | | |
|_| |_|\__,_|_| |_|\__,_|_| |_|\_/  |_|_| |_| |_|
                                                  
EOF
BANNER
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
            # shellcheck disable=SC1091
            . /etc/os-release
            OS=$ID
        elif type lsb_release >/dev/null 2>&1; then
            OS=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
        elif [ -f /etc/debian_version ]; then
            OS=debian
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
    command -v "$1" &> /dev/null
}

# Return 0 if version $1 is the same as or newer than version $2.
version_compare() {
    if [[ "$1" == "$2" ]]; then
        return 0
    fi

    local i
    local -a ver1 ver2
    IFS=. read -ra ver1 <<< "$1"
    IFS=. read -ra ver2 <<< "$2"

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

# Print the installed Neovim version without the "v" prefix (for example 0.12.5).
nvim_version() {
    nvim --version | head -1 | cut -d' ' -f2 | sed 's/^v//'
}

# Print the CPU architecture name that the release files use: x86_64 or arm64.
release_arch() {
    case "$(uname -m)" in
        x86_64|amd64) echo "x86_64" ;;
        aarch64|arm64) echo "arm64" ;;
        *) echo "unsupported" ;;
    esac
}

# Install the latest stable Neovim release in /opt/nvim. Link it to /usr/local/bin/nvim.
# The tarball does not need FUSE (an AppImage does).
install_neovim_release() {
    local arch
    arch=$(release_arch)
    if [ "$arch" = "unsupported" ]; then
        print_error "No Neovim release file for $(uname -m). Install Neovim ${MIN_NVIM_VERSION}+ manually."
        return 1
    fi

    print_info "Installing the latest stable Neovim (linux-${arch})..."
    local tmp
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/nvim.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${arch}.tar.gz"
    tar -xzf "$tmp/nvim.tar.gz" -C "$tmp"
    sudo rm -rf /opt/nvim
    sudo mv "$tmp/nvim-linux-${arch}" /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm -rf "$tmp"
    hash -r
    print_success "Neovim $(nvim_version) installed in /opt/nvim"
}

# Install lazygit from its GitHub release. This step is optional: a failure
# shows a warning and the install continues.
install_lazygit_release() {
    if check_command "lazygit"; then
        return 0
    fi

    local arch
    case "$(release_arch)" in
        x86_64) arch=x86_64 ;;
        arm64) arch=arm64 ;;
        *) print_warning "No lazygit release file for $(uname -m). Skipped."; return 0 ;;
    esac

    print_info "Installing lazygit..."
    local version tmp
    version=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v*([^"]+)".*/\1/') || true
    if [ -z "$version" ]; then
        print_warning "Could not find the lazygit version. Skipped. <leader>gg needs lazygit."
        return 0
    fi
    tmp=$(mktemp -d)
    if curl -fsSL -o "$tmp/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_${arch}.tar.gz" \
        && sudo tar -xzf "$tmp/lazygit.tar.gz" -C /usr/local/bin lazygit; then
        print_success "lazygit ${version} installed"
    else
        print_warning "lazygit install failed. <leader>gg needs lazygit."
    fi
    rm -rf "$tmp"
    return 0
}

# Install the tree-sitter CLI from its GitHub release.
# nvim-treesitter (main) uses it to compile parsers.
install_tree_sitter_release() {
    if check_command "tree-sitter"; then
        return 0
    fi

    local arch
    case "$(release_arch)" in
        x86_64) arch=x64 ;;
        arm64) arch=arm64 ;;
        *) print_error "No tree-sitter release file for $(uname -m)"; return 1 ;;
    esac

    print_info "Installing the tree-sitter CLI..."
    local tmp
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/tree-sitter.gz" "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${arch}.gz"
    gunzip -f "$tmp/tree-sitter.gz"
    chmod +x "$tmp/tree-sitter"
    sudo mv "$tmp/tree-sitter" /usr/local/bin/tree-sitter
    rm -rf "$tmp"
    print_success "tree-sitter CLI installed"
}

install_dependencies_arch() {
    print_info "Installing dependencies for Arch Linux..."

    local packages=(
        git
        curl
        unzip
        make
        gcc
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
        tree-sitter-cli
    )

    # kitty is only for image previews (kitty graphics protocol). Ghostty also supports it.
    if ! check_command "kitty" && ! check_command "ghostty"; then
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
        curl
        unzip
        ripgrep
        fd-find
        imagemagick
        nodejs
        npm
        python3
        python3-pip
        python3-venv
        clang
        build-essential
    )

    # kitty is only for image previews (kitty graphics protocol). Ghostty also supports it.
    if ! check_command "kitty" && ! check_command "ghostty"; then
        packages+=(kitty)
    fi

    sudo apt install -y "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }

    # Ubuntu names the fd binary fdfind. Link it as fd.
    if check_command "fdfind" && ! check_command "fd"; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
        print_info "Created fd symlink in ~/.local/bin"
    fi

    # The apt version of Neovim is usually too old. Install the release if necessary.
    if ! check_command "nvim" || ! version_compare "$(nvim_version)" "$MIN_NVIM_VERSION"; then
        install_neovim_release || return 1
    fi

    install_lazygit_release

    # tree-sitter-cli is in apt from Ubuntu 23.10. Use the release file on older versions.
    if ! check_command "tree-sitter"; then
        if apt-cache show tree-sitter-cli >/dev/null 2>&1; then
            sudo apt install -y tree-sitter-cli
        else
            install_tree_sitter_release || return 1
        fi
    fi

    print_success "Dependencies installed"
}

install_dependencies_fedora() {
    print_info "Installing dependencies for Fedora..."

    local packages=(
        git
        curl
        unzip
        make
        gcc
        neovim
        ripgrep
        fd-find
        ImageMagick
        nodejs
        npm
        python3
        python3-pip
        clang
        tree-sitter-cli
    )

    # kitty is only for image previews (kitty graphics protocol). Ghostty also supports it.
    if ! check_command "kitty" && ! check_command "ghostty"; then
        packages+=(kitty)
    fi

    sudo dnf install -y "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }

    # lazygit is not in the official Fedora repositories.
    install_lazygit_release

    print_success "Dependencies installed"
}

install_dependencies_macos() {
    print_info "Installing dependencies for macOS..."

    if ! check_command "brew"; then
        print_error "Homebrew is necessary but not installed"
        print_info "Install it from: https://brew.sh"
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
        tree-sitter-cli
    )

    # kitty is only for image previews (kitty graphics protocol). Ghostty also supports it.
    if ! check_command "kitty" && ! check_command "ghostty"; then
        packages+=(kitty)
    fi

    brew install "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }

    print_success "Dependencies installed"
}

install_optional_browser() {
    # w3m is the text browser in the nanabrowser panel. It is optional:
    # nanabrowser uses the external browser if w3m is not installed. Thus a
    # failure here must not stop the install.
    if check_command "w3m"; then
        print_success "w3m already installed"
        return 0
    fi

    print_info "Installing w3m (optional in-editor text browser)..."
    case "$OS" in
        arch)                        sudo pacman -S --needed --noconfirm w3m ;;
        ubuntu|debian|pop|linuxmint) sudo apt install -y w3m ;;
        fedora)                      sudo dnf install -y w3m ;;
        macos)                       brew install w3m ;;
        *)                           false ;;
    esac || true

    if check_command "w3m"; then
        print_success "w3m installed"
    else
        print_warning "w3m not installed. The browser panel uses your external browser"
    fi
    return 0
}

check_neovim_version() {
    if ! check_command "nvim"; then
        print_error "Neovim is not installed"
        return 1
    fi

    local version
    version=$(nvim_version)

    if version_compare "$version" "$MIN_NVIM_VERSION"; then
        print_success "Neovim $version is correct"
    else
        print_error "Neovim $version is too old (${MIN_NVIM_VERSION}+ is necessary)"
        return 1
    fi
}

backup_existing_config() {
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        print_info "Backing up the current config to $BACKUP_DIR"
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        print_success "Backup created"
    fi

    # Remove the old plugin data, cache and state.
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

    if [ ! -d "$NVIM_CONFIG_DIR" ]; then
        print_error "Config directory not found"
        return 1
    fi

    if [ ! -f "$NVIM_CONFIG_DIR/init.lua" ]; then
        print_error "init.lua not found"
        return 1
    fi

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
    echo -e "  1. ${BOLD}nvim${NC}                     Start Neovim (plugins install automatically)"
    echo -e "  2. ${BOLD}:checkhealth nananvim${NC}    Check the external tools"
    echo -e "  3. Make ${BOLD}lua/config/local.lua${NC} to turn on the AI plugins (optional)"
    echo
    echo -e "${YELLOW}Tips:${NC}"
    echo -e "  • Push ${BOLD}<Space>f${NC} to find files"
    echo -e "  • Push ${BOLD}<Space>${NC} and wait to see the keybindings"
    echo -e "  • Push ${BOLD}<Space>gg${NC} for lazygit"
    echo -e "  • Run ${BOLD}:Mason${NC} to manage language servers"
    echo

    if [ -d "$BACKUP_DIR" ]; then
        echo -e "${BLUE}Your old config is in:${NC}"
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

    OS=$(detect_os)
    print_info "Detected OS: $OS"

    # Ask before the script replaces a config.
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        echo -e "${YELLOW}Existing Neovim configuration found${NC}"
        read -p "Do you want to backup and replace it? (y/N): " -n 1 -r < /dev/tty
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi

    case "$OS" in
        arch|endeavouros|manjaro)
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
            print_warning "Gentoo support is not available yet. Install the dependencies manually:"
            echo "  emerge -av app-editors/neovim sys-apps/ripgrep sys-apps/fd dev-util/tree-sitter-cli"
            echo "  emerge -av media-gfx/imagemagick net-libs/nodejs app-arch/unzip"
            echo "  emerge -av dev-lang/python llvm-core/clang www-client/w3m dev-vcs/lazygit"
            exit 0
            ;;
        *)
            print_error "Unsupported OS: $OS"
            print_info "Install the dependencies manually, then run:"
            echo "  git clone $REPO_URL $NVIM_CONFIG_DIR"
            exit 1
            ;;
    esac

    # Optional text browser. A failure does not stop the install.
    install_optional_browser

    check_neovim_version || exit 1

    backup_existing_config

    install_nananvim || exit 1

    verify_installation || exit 1

    post_install_message

    print_info "Installation log saved to: $LOG_FILE"
}

main "$@"
