# Installation

Everything about getting nananvim on your machine.

## Quick Install (One-Line Installer)

```bash
curl -fsSL https://raw.githubusercontent.com/m4c4r0n1n/nananvim/main/install.sh | bash
```

The installer will:
- Detect your distro (Arch, Fedora, Debian, Ubuntu, NixOS, Void, Gentoo, macOS, and distros based on them), x86_64 and arm64
- Install all required dependencies (including lazygit and the tree-sitter CLI)
- Install clipboard tools (wl-clipboard, xclip) so yank and paste reach your system clipboard
- Download the latest stable Neovim (0.12+) if yours is too old
- Clone this config to `~/.config/nvim`
- Backup your existing config if present

**Note:** If you want to review the script first: [install.sh](install.sh)

Want to see what it does before it touches anything? Add `--dry-run`. It prints every package, backup and delete, and changes nothing:

```bash
curl -fsSL https://raw.githubusercontent.com/m4c4r0n1n/nananvim/main/install.sh | bash -s -- --dry-run
```

## Try it without touching your config

Zero risk, your existing setup stays exactly where it is:

```bash
git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nananvim
NVIM_APPNAME=nananvim nvim
```

Plugins install into their own isolated data directory. Don't like it? `rm -rf ~/.config/nananvim ~/.local/share/nananvim ~/.local/state/nananvim ~/.cache/nananvim` and it never happened. Like it? Alias `NVIM_APPNAME=nananvim nvim` or do a real install below.

## Manual Install

If you prefer to install manually or want more control:

### 1. Backup your existing config (if you have one)

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

### 2. Install dependencies

**For Arch:**
```bash
sudo pacman -S git curl unzip ripgrep fd imagemagick kitty nodejs npm python clang tree-sitter-cli lazygit wl-clipboard xclip
```

**For Ubuntu/Debian:**
```bash
sudo apt install git curl unzip ripgrep fd-find imagemagick kitty nodejs npm python3 python3-venv clang build-essential wl-clipboard xclip
# fd-find is called fdfind on Ubuntu, so symlink it:
ln -s $(which fdfind) ~/.local/bin/fd
# tree-sitter-cli only lands in apt from 23.10+; otherwise grab the binary:
# curl -Lo /tmp/tree-sitter.gz https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
# gunzip /tmp/tree-sitter.gz && chmod +x /tmp/tree-sitter && sudo mv /tmp/tree-sitter /usr/local/bin/
```

(Already on Ghostty or WezTerm? Skip kitty, it's only needed for the kitty graphics protocol, which they both speak.)

### 3. Install Neovim 0.12.0+

```bash
# Use nvim-linux-arm64 on ARM machines
curl -fLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim && sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo mv /opt/nvim-linux-x86_64 /opt/nvim
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
```

### 4. Clone this config

```bash
git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim
```

### 5. Start Neovim

```bash
nvim
```

Lazy.nvim will automatically install all plugins on first launch. Just wait for it to finish.

### 6. Check everything's working

```vim
:checkhealth nananvim
```

This checks every external tool the config leans on (ripgrep, fd, tree-sitter, a kitty-graphics terminal, ImageMagick, text browsers, AI setup) and tells you exactly what's missing and what it's for.

## Windows Users

This config is built primarily for Linux. If you're on Windows, you have some options...:

### Option 1: WSL2 (Recommended - Just Do This)

Install Ubuntu through WSL2 and follow the Ubuntu install instructions above (or just run the one-line installer). You'll get the full experience including image previews if you use Windows Terminal or another WSL-compatible terminal.

### Option 2: Native Windows (Not Recommended But Possible)

The config *should* work natively on Windows, but you'll need to:
- Install Neovim from the official Windows installer
- Clone to `%LOCALAPPDATA%\nvim` instead of `~/.config/nvim`
- Manually install dependencies via Chocolatey/Scoop
- Image previews won't work (no Kitty/proper terminal support)
- Some plugins might be janky
- Sorry if it doesn't work, why are you on Windows?

Honestly using WSL2 is your best option.

## What You'll Need

**The bare minimum** (config will work without these, but you'll miss features):

- **Neovim 0.12+**: The editor itself (nvim-treesitter v2 requires this; earlier versions won't work)
- **tree-sitter CLI**: Needed by nvim-treesitter v2 to compile parsers. The installer handles this.
- **Git, curl, unzip**: For lazy.nvim, Mason and parser downloads
- **A C compiler**: For treesitter parsers (`build-essential` / `base-devel` / Xcode tools)
- **Ripgrep & fd**: Makes file searching pretty fast
- **A Nerd Font**: For icons to display properly

**For the full experience:**

- **ImageMagick**: Required for inline image previews in Snacks picker
- **A kitty-graphics terminal**: Kitty, Ghostty, or WezTerm, anything that speaks the kitty graphics protocol (needed for inline image previews)
- **w3m** (or lynx/elinks): The in-editor text browser for the panel workspace, auto-detected, falls back to your external browser if absent
- **lazygit**: The git UI on `<leader>gg`
- **wl-clipboard or xclip**: Yank and paste with the system clipboard (the installer adds both)

**For language servers and formatters:**

- **Node.js 20+**: For the TypeScript/HTML/CSS/JSON/YAML servers and prettier
- **Python 3.10+**: For basedpyright and ruff (Mason installs both)
- **clang**: For C/C++ (Mason installs clangd if you don't have it)

**For debugging (DAP):**

- **debugpy / codelldb / bash-debug-adapter / js-debug-adapter**: Python, C/C++/Rust, Bash/sh, and JS/TS debugging, all auto-installed via Mason, no manual install needed
- **node**: only needed if you debug JavaScript/TypeScript (the js-debug adapter runs on it)
- **osv**: Lua debugging for Neovim config/plugins, a pure-Lua plugin (no system package, nothing to install)

After setup, run `:checkhealth nananvim` to see what's working and what's missing.
