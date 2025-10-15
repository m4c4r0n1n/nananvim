# nananvim
A minimal, lazy.nvim-powered Neovim configuration focused on productivity with inline image previews (via snacks.nvim), Treesitter highlighting, LSP support, and Telescope-style fuzzy finding. Built for Arch Linux but portable to most Unix-like systems.

## Features
- **Snacks.nvim**: Dashboard, file picker/grep with Kitty inline image/PDF/Mermaid/LaTeX previews.
- **Treesitter**: Syntax highlighting, indentation, and incremental selection for 20+ languages.
- **LSP**: Auto-setup for Lua, Python, TypeScript, HTML/CSS/JSON via Mason.
- **Telescope**: Enhanced with Snacks for image-aware previews.
- **Other goodies**: Bufferline tabs, gitsigns, trouble diagnostics, todo-comments, autopairs, surround, conform formatting, toggleterm, lualine, Catppuccin theme.

## Quick Install (One-Shot)

**Arch Linux:**
```bash
sudo pacman -S git ripgrep fd imagemagick kitty nodejs npm python && curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage && chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim && git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim && nvim
```

**Ubuntu/Pop!_OS/Debian:**
```bash
sudo apt update && sudo apt install -y git ripgrep fd-find imagemagick kitty nodejs npm python3 python3-pip curl && curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage && chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim && git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim && nvim
```

*Note: Uses Neovim AppImage for reliable v0.10.2+ installation. Back up existing config first if needed: `mv ~/.config/nvim ~/.config/nvim.bak`*

## Prerequisites
Before cloning and setting up, ensure you have these installed (most are optional; the config will work without them but with reduced features):
- **Neovim 0.9.5+**: Core editor. Install via your package manager (e.g., `sudo pacman -S neovim` on Arch, `brew install neovim` on macOS).
- **Git**: For lazy.nvim bootstrap. (e.g., `sudo pacman -S git`).
- **Ripgrep (rg) & fd**: For fast file/grep searching in Telescope/Snacks. (e.g., `sudo pacman -S ripgrep fd`).
- **ImageMagick**: For inline image processing in Snacks (required for previews). (e.g., `sudo pacman -S imagemagick`).
- **Kitty Terminal**: Recommended for inline image support (Snacks uses Kitty Graphics Protocol). (e.g., `sudo pacman -S kitty`). Alternatives like WezTerm may work with tweaks.
- **Optional for LSP/Formatters**:
  - Node.js (v18+): For ts_ls, prettier, etc. (e.g., via nvm or `sudo pacman -S nodejs npm`).
  - Python 3.10+: For pyright, black, isort. (e.g., `sudo pacman -S python`).
- **Optional for Snacks Extras**:
  - Tectonic: LaTeX rendering. (e.g., `yay -S tectonic` on Arch AUR).
  - Mermaid CLI (mmdc): Diagram previews. (e.g., `npm install -g @mermaid-js/mermaid-cli`).
  - Ghostscript (gs): PDF handling. (e.g., `sudo pacman -S ghostscript`).

Run `:checkhealth` in Neovim after setup to verify.

## Installation
1. **Backup your config** (if any): `mv ~/.config/nvim ~/.config/nvim.bak`.
2. **Clone the repo**:
   ```bash
   git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim
   ```
3. **Launch Neovim**: 
   ```bash
   nvim
   ```
   lazy.nvim will bootstrap automatically and install all plugins on first launch.
4. **Run health check**: Once plugins are installed, run `:checkhealth` to verify everything is working correctly!


⚠️ **Known Issue on Ubuntu/Pop!_OS**: Working on a resolution, everything still functions and shouldn't be an issue until I figure it out, still learning so if anyone ever even uses this then please be patient, though hopefully it'll be resolved by then. I am but one nana-man.
