# nananvim

My minimal Neovim setup powered by lazy.nvim. Built primarily for Arch but works on most Linux distros.

## What's in it?

- **Snacks.nvim**: Dashboard on startup, plus a file picker that can preview images, PDFs, Mermaid diagrams, and LaTeX right in the terminal (if you're using Kitty)
- **Treesitter**: Better syntax highlighting and code navigation for 20+ languages
- **LSP**: Language servers auto-install through Mason (Lua, Python, TypeScript, HTML/CSS/JSON out of the box)
- **Telescope**: Fuzzy finder for files, text, buffers - works alongside Snacks
- **Other stuff**: Bufferline for tabs, gitsigns for git integration, trouble for diagnostics, todo-comments, autopairs, surround motions, conform for formatting, toggleterm, lualine status bar, Catppuccin theme

## Quick Install

**Arch Linux:**
```bash
sudo pacman -S git ripgrep fd imagemagick kitty nodejs npm python && curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage && chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim && git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim && nvim
```

**Ubuntu/Pop!_OS/Debian:**
```bash
sudo apt update && sudo apt install -y git ripgrep fd-find imagemagick kitty nodejs npm python3 python3-pip curl build-essential unzip && mkdir -p ~/.local/bin && ln -s $(which fdfind) ~/.local/bin/fd && curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage && chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim && git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim && nvim
```

*Note: This uses the Neovim AppImage to get v0.10.2+. If you have an existing config, back it up first: `mv ~/.config/nvim ~/.config/nvim.bak`*

## Windows Users

This config is primarily built for Linux. If you want to use it on Windows, you have two options:

1. **WSL2 (Recommended)**: Install Ubuntu through WSL2 and follow the Ubuntu install instructions. You'll get the full experience including image previews if you use a terminal that supports it.

2. **Native Windows**: The config *should* work but you'll need to:
   - Install Neovim from the official Windows installer
   - Clone to `~/AppData/Local/nvim` instead
   - Manually install dependencies via Chocolatey/Scoop
   - Image previews won't work (no Kitty support)
   
Honestly just use WSL2 lol, it's way easier.

## What you'll need

The basics (config will work without these, but you'll miss features):

- **Neovim 0.9.5+**: The editor itself
- **Git**: For lazy.nvim to work
- **Ripgrep & fd**: Makes file searching fast (`sudo pacman -S ripgrep fd`)
- **ImageMagick**: Required if you want inline image previews
- **Kitty**: Terminal emulator that supports inline images (alternatives like WezTerm might work with tweaks)

For language servers and formatters:

- **Node.js 18+**: For TypeScript/JavaScript LSP and prettier
- **Python 3.10+**: For pyright, black, isort

Bonus stuff for Snacks previews:

- **Tectonic**: For LaTeX rendering (`yay -S tectonic` on Arch)
- **Mermaid CLI**: For diagram previews (`npm install -g @mermaid-js/mermaid-cli`)
- **Ghostscript**: For PDF handling

Run `:checkhealth` after setup to see what's working.

## Manual Install

1. Backup your existing config if you have one:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repo:
   ```bash
   git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim
   ```

3. Start Neovim:
   ```bash
   nvim
   ```
   
   lazy.nvim will automatically install all plugins on first launch.

4. Check everything's working:
   ```
   :checkhealth
   ```

## Known Issues

There's some weird LSP shit happening on Ubuntu/Pop!_OS that I'm still tracking down. Everything still works, just might throw some error messages on startup. Working on it tho - I am but one nana-man so please be patient lol. Still learning this stuff.

If anyone actually ends up using this and run into problems, feel free to open an issue.
