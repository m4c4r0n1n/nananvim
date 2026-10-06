#!/usr/bin/env bash

# nananvim installer
# https://github.com/m4c4r0n1n/nananvim
#
# This script installs the dependencies, backs up your current Neovim config
# and clones nananvim to ~/.config/nvim.
#
# Usage: install.sh [--dry-run]
#   --dry-run  Show each change. Do not make it.

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
# NANANVIM_REPO and NANANVIM_REF install from a fork, a branch or a local clone (CI uses this).
REPO_URL="${NANANVIM_REPO:-https://github.com/m4c4r0n1n/nananvim.git}"
REPO_REF="${NANANVIM_REF:-}"
BACKUP_DIR="${NVIM_CONFIG_DIR}.bak.$(date +%Y%m%d_%H%M%S)"
MIN_NVIM_VERSION="0.12.0"
# nvim-treesitter (main) needs this tree-sitter CLI version or newer.
MIN_TS_VERSION="0.26.1"
# Mason installs most language servers with npm. They need this Node.js major version or newer.
MIN_NODE_MAJOR=20

# Log file
LOG_FILE="/tmp/nananvim_install_$(date +%Y%m%d_%H%M%S).log"

# 1 = dry run: show each change, do not make it (--dry-run).
DRY_RUN=0

print_banner() {
    echo -e "${MAGENTA}${BOLD}"
    cat << "BANNER"
                                    _
 _ __   __ _ _ __   __ _ _ ____   _(_)_ __ ___
| '_ \ / _` | '_ \ / _` | '_ \ \ / / | '_ ` _ \
| | | | (_| | | | | (_| | | | \ V /| | | | | | |
|_| |_|\__,_|_| |_|\__,_|_| |_|\_/ |_|_| |_| |_|
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

# Show a change that a dry run does not make.
print_dry() {
    echo -e "${CYAN}${BOLD}[DRY RUN]${NC} $1"
}

# Run a command that changes the system. A dry run shows it and does not run it.
run() {
    if [ "$DRY_RUN" = 1 ]; then
        print_dry "$*"
    else
        "$@"
    fi
}

# Report a change that is complete. A dry run makes no change, thus it shows nothing.
print_done() {
    if [ "$DRY_RUN" = 0 ]; then
        print_success "$1"
    fi
}

detect_os() {
    # NANANVIM_OS skips the detection (CI uses it to test the NixOS path).
    if [ -n "${NANANVIM_OS:-}" ]; then
        echo "$NANANVIM_OS"
        return
    fi
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            # shellcheck disable=SC1091
            . /etc/os-release
            OS=$ID
            # Derived distros (Kali, Mint, Manjaro, Nobara...) use the steps of
            # their base distro (ID_LIKE).
            case "$OS" in
                arch|ubuntu|debian|fedora|nixos|gentoo|void) ;;
                *)
                    case " ${ID_LIKE:-} " in
                        *" arch "*) OS=arch ;;
                        *" fedora "*) OS=fedora ;;
                        *" ubuntu "* | *" debian "*) OS=debian ;;
                    esac
                    ;;
            esac
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
# Only bash is used here, because minimal systems (the nix image) have no sed or awk.
nvim_version() {
    local _ version
    read -r _ version _ < <(nvim --version 2>/dev/null)
    echo "${version#v}"
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
    if [ "$DRY_RUN" = 1 ]; then
        print_dry "Install lazygit from its GitHub release in /usr/local/bin"
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

# Print the installed tree-sitter CLI version (for example 0.26.9), or nothing.
tree_sitter_version() {
    local _ version
    read -r _ version _ < <(tree-sitter --version 2>/dev/null)
    echo "$version"
}

# Return 0 if the tree-sitter CLI runs and is new enough.
tree_sitter_ok() {
    local version
    version=$(tree_sitter_version)
    [ -n "$version" ] && version_compare "$version" "$MIN_TS_VERSION"
}

# Print the glibc version (for example 2.39), or nothing (macOS, musl).
glibc_version() {
    local line
    line=$(getconf GNU_LIBC_VERSION 2>/dev/null) || line=$(ldd --version 2>/dev/null) || line=""
    line=${line%%$'\n'*}
    if [[ "$line" =~ ([0-9]+\.[0-9]+)$ ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

# Install the tree-sitter CLI from its GitHub release in /usr/local/bin.
# The release binaries need glibc 2.39 or newer.
install_tree_sitter_release() {
    local arch
    case "$(release_arch)" in
        x86_64) arch=x64 ;;
        arm64) arch=arm64 ;;
        *) return 1 ;;
    esac

    print_info "Installing the tree-sitter CLI (release binary)..."
    local tmp
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/tree-sitter.gz" "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${arch}.gz" || {
        rm -rf "$tmp"
        return 1
    }
    gunzip -f "$tmp/tree-sitter.gz"
    chmod +x "$tmp/tree-sitter"
    sudo mv "$tmp/tree-sitter" /usr/local/bin/tree-sitter
    rm -rf "$tmp"
    hash -r
}

# Build the tree-sitter CLI from source with cargo and put it in /usr/local/bin.
# This works on any glibc. It takes a few minutes.
install_tree_sitter_cargo() {
    print_info "Building the tree-sitter CLI from source (this takes a few minutes)..."
    # Distribution cargo packages are often too old. rustup gives a current Rust.
    if ! check_command "rustup"; then
        curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal || return 1
    fi
    # shellcheck disable=SC1091
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    cargo install --locked tree-sitter-cli || return 1
    sudo install -m 755 "$HOME/.cargo/bin/tree-sitter" /usr/local/bin/tree-sitter
    hash -r
}

# Make sure that a new enough tree-sitter CLI is installed. Distribution
# packages are sometimes too old (Ubuntu 24.04, Fedora 43). Then use the release
# binary, or build it from source when glibc is too old for the release binary.
ensure_tree_sitter() {
    if tree_sitter_ok; then
        print_success "tree-sitter CLI $(tree_sitter_version)"
        return 0
    fi
    if [ "$DRY_RUN" = 1 ]; then
        local found
        found=$(tree_sitter_version)
        print_dry "Install tree-sitter CLI ${MIN_TS_VERSION}+ (found: ${found:-none})"
        return 0
    fi
    if [ "$OS" = "macos" ]; then
        brew upgrade tree-sitter-cli || brew install tree-sitter-cli || true
    elif [ "$OS" = "nixos" ]; then
        print_warning "nixpkgs gave tree-sitter $(tree_sitter_version). Update your nixpkgs (nix flake update / nix-channel --update)."
    else
        local glibc
        glibc=$(glibc_version)
        if [ -n "$glibc" ] && version_compare "$glibc" "2.39"; then
            install_tree_sitter_release || true
        fi
        tree_sitter_ok || install_tree_sitter_cargo || true
    fi
    if tree_sitter_ok; then
        print_success "tree-sitter CLI $(tree_sitter_version)"
    else
        print_error "Could not install tree-sitter CLI ${MIN_TS_VERSION}+. Treesitter parsers will not compile."
        return 1
    fi
}

# Print the major version of node (for example 22), or nothing.
node_major() {
    local version
    version=$(node --version 2>/dev/null) || return 0
    version=${version#v}
    echo "${version%%.*}"
}

# Return 0 if node runs and is new enough.
node_ok() {
    local major
    major=$(node_major)
    [ -n "$major" ] && [ "$major" -ge "$MIN_NODE_MAJOR" ]
}

# Install the latest Node.js LTS release in /opt/node. Link node, npm and npx
# to /usr/local/bin.
install_node_release() {
    local arch
    case "$(release_arch)" in
        x86_64) arch=x64 ;;
        arm64) arch=arm64 ;;
        *) return 1 ;;
    esac

    # index.json has one release on each line, newest first.
    local line version=""
    line=$(curl -fsSL https://nodejs.org/dist/index.json | grep -m1 '"lts":"') || true
    if [[ "$line" =~ \"version\":\"(v[0-9.]+)\" ]]; then
        version=${BASH_REMATCH[1]}
    fi
    [ -n "$version" ] || return 1

    print_info "Installing Node.js ${version} (LTS) in /opt/node..."
    local tmp bin
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/node.tar.gz" "https://nodejs.org/dist/${version}/node-${version}-linux-${arch}.tar.gz" || {
        rm -rf "$tmp"
        return 1
    }
    tar -xzf "$tmp/node.tar.gz" -C "$tmp"
    sudo rm -rf /opt/node
    sudo mv "$tmp/node-${version}-linux-${arch}" /opt/node
    for bin in node npm npx; do
        sudo ln -sf "/opt/node/bin/$bin" "/usr/local/bin/$bin"
    done
    rm -rf "$tmp"
    hash -r
}

# Make sure that a new enough Node.js is installed. Distribution packages are
# sometimes too old (Ubuntu 22.04 has node 12, Ubuntu 24.04 has node 18).
# Node.js is optional: without it, only the npm-based servers are missing.
ensure_node() {
    if ! node_ok && [ "$DRY_RUN" = 1 ]; then
        local found
        found=$(node_major)
        print_dry "Install Node.js ${MIN_NODE_MAJOR}+ (found: ${found:-none})"
        return 0
    fi
    if ! node_ok; then
        case "$OS" in
            macos) brew upgrade node || brew install node || true ;;
            nixos) print_warning "nixpkgs gave Node.js $(node --version 2>/dev/null). Update your nixpkgs." ;;
            *) install_node_release || true ;;
        esac
    fi
    if node_ok; then
        print_success "Node.js $(node --version)"
    else
        print_warning "Node.js ${MIN_NODE_MAJOR}+ is not installed. Mason cannot install the TypeScript, HTML, CSS, JSON and YAML servers."
    fi
    return 0
}

# Make sure that a new enough Neovim is installed. Distribution packages are
# sometimes too old (Debian, Ubuntu, Fedora 43). Then install the release.
ensure_neovim() {
    if check_command "nvim" && version_compare "$(nvim_version)" "$MIN_NVIM_VERSION"; then
        return 0
    fi
    if [ "$DRY_RUN" = 1 ]; then
        local found
        found=$(nvim_version)
        print_dry "Install Neovim ${MIN_NVIM_VERSION}+ (found: ${found:-none})"
        return 0
    fi
    if [ "$OS" = "macos" ]; then
        brew upgrade neovim || brew install neovim
    elif [ "$OS" = "nixos" ]; then
        print_error "nixpkgs gave Neovim $(nvim_version 2>/dev/null). Update your nixpkgs (nix flake update / nix-channel --update)."
        return 1
    else
        install_neovim_release
    fi
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

    run sudo pacman -S --needed --noconfirm "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }

    print_done "Dependencies installed"
}

install_dependencies_ubuntu() {
    print_info "Installing dependencies for Ubuntu/Debian..."

    run sudo apt-get update

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

    run sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }

    # Ubuntu names the fd binary fdfind. Link it as fd.
    if check_command "fdfind" && ! check_command "fd"; then
        print_info "Linking fdfind as fd in ~/.local/bin"
        run mkdir -p "$HOME/.local/bin"
        run ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    fi

    install_lazygit_release

    print_done "Dependencies installed"
}

install_dependencies_fedora() {
    print_info "Installing dependencies for Fedora..."

    local packages=(
        git
        curl
        tar
        gzip
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

    run sudo dnf install -y "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }

    # lazygit is not in the official Fedora repositories.
    install_lazygit_release

    print_done "Dependencies installed"
}

install_dependencies_void() {
    print_info "Installing dependencies for Void Linux..."

    local packages=(
        git
        curl
        tar
        gzip
        unzip
        make
        gcc
        neovim
        ripgrep
        fd
        ImageMagick
        nodejs
        python3
        lazygit
    )

    # kitty is only for image previews (kitty graphics protocol). Ghostty also supports it.
    if ! check_command "kitty" && ! check_command "ghostty"; then
        packages+=(kitty)
    fi

    # xbps-install stops on a package that is already installed. Thus ask
    # only for the missing packages.
    local missing=()
    local pkg
    for pkg in "${packages[@]}"; do
        xbps-query "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
    done

    # Update xbps first. An old xbps cannot install from the current repository.
    run sudo xbps-install -Syu xbps || true
    if [ "${#missing[@]}" -gt 0 ]; then
        run sudo xbps-install -Sy "${missing[@]}" || {
            print_error "Failed to install packages"
            return 1
        }
    fi

    print_done "Dependencies installed"
}

install_dependencies_gentoo() {
    print_info "Installing dependencies for Gentoo (binary packages when available)..."

    local packages=(
        dev-vcs/git
        net-misc/curl
        app-arch/unzip
        app-editors/neovim
        sys-apps/ripgrep
        sys-apps/fd
        media-gfx/imagemagick
        net-libs/nodejs
        dev-util/tree-sitter-cli
    )

    # kitty is only for image previews (kitty graphics protocol). Ghostty also supports it.
    if ! check_command "kitty" && ! check_command "ghostty"; then
        packages+=(x11-terms/kitty)
    fi

    # --getbinpkg uses the official Gentoo binary packages, thus most
    # packages do not compile. --noreplace keeps the packages you have.
    run sudo emerge --getbinpkg --noreplace --ask=n "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }

    # lazygit is not in the Gentoo repository.
    install_lazygit_release

    print_done "Dependencies installed"
}

install_dependencies_nixos() {
    print_info "Installing dependencies for NixOS (nix profile)..."

    if ! check_command "nix"; then
        print_error "nix is not installed"
        return 1
    fi

    # Packages go in your user profile. Prefer configuration.nix or
    # home-manager? Add the same packages there and run this script again.
    # Each entry is "nixpkgs attribute:command". A package whose command
    # already exists is skipped (nix profile refuses duplicates).
    local packages=(
        git:git
        curl:curl
        unzip:unzip
        gnumake:make
        gcc:cc
        neovim:nvim
        ripgrep:rg
        fd:fd
        imagemagick:magick
        nodejs:node
        python3:python3
        tree-sitter:tree-sitter
        lazygit:lazygit
        w3m:w3m
    )
    local refs=()
    local entry
    for entry in "${packages[@]}"; do
        if ! check_command "${entry#*:}"; then
            refs+=("nixpkgs#${entry%%:*}")
        fi
    done

    if [ "${#refs[@]}" -eq 0 ]; then
        print_success "All dependencies are already installed"
        return 0
    fi

    run nix --extra-experimental-features "nix-command flakes" profile install "${refs[@]}" || {
        print_error "Failed to install packages"
        return 1
    }
    hash -r

    # Mason downloads prebuilt language servers and debug adapters. On NixOS
    # they start only with nix-ld (it supplies the normal Linux loader).
    if [ -z "${NIX_LD:-}" ]; then
        print_warning "nix-ld is not enabled. Mason's language servers will not start without it."
        print_info "Add this to configuration.nix and run nixos-rebuild switch:"
        echo "  programs.nix-ld.enable = true;"
    fi

    print_done "Dependencies installed"
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

    run brew install "${packages[@]}" || {
        print_error "Failed to install packages"
        return 1
    }

    print_done "Dependencies installed"
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
        arch)                        run sudo pacman -S --needed --noconfirm w3m ;;
        ubuntu|debian|pop|linuxmint) run sudo DEBIAN_FRONTEND=noninteractive apt-get install -y w3m ;;
        fedora)                      run sudo dnf install -y w3m ;;
        macos)                       run brew install w3m ;;
        nixos)                       run nix --extra-experimental-features "nix-command flakes" profile install nixpkgs#w3m ;;
        void)                        run sudo xbps-install -Sy w3m ;;
        gentoo)                      run sudo emerge --getbinpkg --noreplace --ask=n www-client/w3m ;;
        *)                           false ;;
    esac || true
    if [ "$DRY_RUN" = 1 ]; then
        return 0
    fi

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
        run mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        print_done "Backup created"
    fi

    # Remove the old plugin data, cache and state.
    print_info "Cleaning Neovim cache and state..."
    run rm -rf "$NVIM_DATA_DIR/lazy"
    run rm -rf "$NVIM_CACHE_DIR"
    run rm -rf "$NVIM_STATE_DIR/lazy"
    run rm -f "$NVIM_STATE_DIR/lazy-lock.json"
}

install_nananvim() {
    print_info "Installing nananvim..."

    if [ -n "$REPO_REF" ]; then
        run git clone "$REPO_URL" "$NVIM_CONFIG_DIR" && run git -C "$NVIM_CONFIG_DIR" checkout -q "$REPO_REF"
    else
        run git clone --depth 1 "$REPO_URL" "$NVIM_CONFIG_DIR"
    fi || {
        print_error "Failed to clone repository"
        return 1
    }

    print_done "nananvim installed"
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

usage() {
    echo "Usage: install.sh [--dry-run]"
    echo
    echo "  --dry-run   Show each change. Do not make it."
    echo "  -h, --help  Show this help."
}

main() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --dry-run) DRY_RUN=1 ;;
            -h|--help) usage; exit 0 ;;
            *) usage >&2; exit 1 ;;
        esac
        shift
    done

    print_banner

    if [ "$DRY_RUN" = 1 ]; then
        # A dry run does not write a log.
        LOG_FILE=/dev/null
        print_dry "Nothing changes. Each change shows as [DRY RUN]."
    fi

    OS=$(detect_os)
    print_info "Detected OS: $OS"

    # Ask before the script replaces a config. A dry run does not replace it, thus it does not ask.
    if [ -d "$NVIM_CONFIG_DIR" ] && [ "$DRY_RUN" = 0 ]; then
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
        nixos)
            install_dependencies_nixos
            ;;
        macos)
            install_dependencies_macos
            ;;
        gentoo)
            install_dependencies_gentoo
            ;;
        void)
            install_dependencies_void
            ;;
        *)
            print_error "Unsupported OS: $OS"
            print_info "Install the dependencies manually, then run:"
            echo "  git clone $REPO_URL $NVIM_CONFIG_DIR"
            exit 1
            ;;
    esac

    # Distribution packages can be too old. Get new enough versions.
    ensure_neovim || exit 1
    ensure_tree_sitter || exit 1
    ensure_node

    # Optional text browser. A failure does not stop the install.
    install_optional_browser

    # A dry run does not install Neovim, thus it does not check the version.
    if [ "$DRY_RUN" = 0 ]; then
        check_neovim_version || exit 1
    fi

    backup_existing_config

    install_nananvim || exit 1

    if [ "$DRY_RUN" = 1 ]; then
        echo
        print_success "Dry run complete. Nothing changed."
        exit 0
    fi

    verify_installation || exit 1

    post_install_message

    print_info "Installation log saved to: $LOG_FILE"
}

main "$@"
