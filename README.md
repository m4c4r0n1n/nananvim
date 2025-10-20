# nananvim

<img width="1699" height="1376" alt="251020_01h14m26s_screenshot" src="https://github.com/user-attachments/assets/ba400f69-68de-46a3-811d-5b4f17ccc271" />

My minimal Neovim setup powered by lazy.nvim. Built primarily for Arch but works on most Linux distros. I'm just one nana-man trying to make a clean config, so bear with me if something's janky lol.

## What's in it?

- **Snacks.nvim**: Dashboard on startup, plus a file picker that can preview images, PDFs, Mermaid diagrams, and LaTeX right in your terminal (if you're using Kitty)
- **Treesitter**: Better syntax highlighting and code navigation for 20+ languages
- **LSP**: Language servers auto-install through Mason (Lua, Python, TypeScript, HTML/CSS/JSON out of the box)
- **Telescope**: Fuzzy finder for live grep, buffers, help tags, and more
- **Rose Pine Moon**: Beautiful theme with pure black background for that clean aesthetic
- **Other stuff**: Bufferline for tabs, gitsigns for git integration, trouble for diagnostics, todo-comments, autopairs, surround motions, conform for formatting, toggleterm, lualine status bar, and GitHub Copilot for AI pair programming

## Screenshots

### Snacks picker with inline image preview

<img width="1699" height="1376" alt="251020_01h25m18s_screenshot" src="https://github.com/user-attachments/assets/80f31521-00a1-4269-a15e-86f8131e266b" />


### Editing with LSP, Treesitter syntax highlighting, and Rose Pine Moon theme

<img width="939" height="1136" alt="image" src="https://github.com/user-attachments/assets/2c54f8b5-b89c-4c1c-8973-15997cc21f3c" />


## Quick Install (Copy & Paste Method)

Just copy and paste ONE of these commands based on your distro:

**Arch Linux (btw):**
```bash
sudo pacman -S git ripgrep fd imagemagick kitty nodejs npm python && curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage && chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim && git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim && nvim
```

**Ubuntu/Pop!_OS/Debian:**
```bash
sudo apt update && sudo apt install -y git ripgrep fd-find imagemagick kitty nodejs npm python3 python3-pip curl build-essential unzip && mkdir -p ~/.local/bin && ln -s $(which fdfind) ~/.local/bin/fd && curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage && chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim && git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim && nvim
```

**What this does:**
1. Installs all the dependencies (git, ripgrep, fd, imagemagick, etc.)
2. Downloads Neovim v0.10.2 AppImage
3. Makes it executable and moves it to `/usr/local/bin`
4. Clones this config to `~/.config/nvim`
5. Starts Neovim (Lazy will auto-install all plugins on first launch)

**Note:** If you already have a Neovim config, back it up first:
```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

## Manual Install (If You Want More Control)

1. **Backup your existing config** if you have one:
```bash
   mv ~/.config/nvim ~/.config/nvim.bak
```

2. **Install dependencies:**

   For Arch:
```bash
   sudo pacman -S git ripgrep fd imagemagick kitty nodejs npm python
```

   For Ubuntu/Debian:
```bash
   sudo apt install git ripgrep fd-find imagemagick kitty nodejs npm python3
   # fd-find is called fdfind on Ubuntu, so we symlink it:
   ln -s $(which fdfind) ~/.local/bin/fd
```

3. **Install Neovim 0.10.2+:**
```bash
   curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage
   chmod u+x nvim.appimage
   sudo mv nvim.appimage /usr/local/bin/nvim
```

4. **Clone this config:**
```bash
   git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim
```

5. **Start Neovim:**
```bash
   nvim
```
   
   Lazy.nvim will automatically install all plugins on first launch. Just wait for it to finish.

6. **Check everything's working:**
```
   :checkhealth
```

## Windows Users

Yo, real talk - this config is built for Linux. If you're on Windows, here are your options:

### Option 1: WSL2 (Recommended - Just Do This)
Install Ubuntu through WSL2 and follow the Ubuntu install instructions above. You'll get the full experience including image previews if you use Windows Terminal or another WSL-compatible terminal. This is seriously the easiest way, I promise.

### Option 2: Native Windows (Not Recommended But Possible)
The config *should* work natively on Windows, but you'll need to:
- Install Neovim from the official Windows installer
- Clone to `%LOCALAPPDATA%\nvim` instead of `~/.config/nvim`
- Manually install dependencies via Chocolatey/Scoop
- Image previews won't work (no Kitty/proper terminal support)
- Some plugins might be janky

Honestly just use WSL2 lol, you'll thank me later.

## What You'll Need

**The bare minimum** (config will work without these, but you'll miss features):

- **Neovim 0.10+**: The editor itself (earlier versions might work but no promises)
- **Git**: For lazy.nvim to work
- **Ripgrep & fd**: Makes file searching blazingly fast
- **A Nerd Font**: For icons to display properly (I use JetBrainsMono Nerd Font)

**For the full experience:**

- **ImageMagick**: Required for inline image previews in Snacks picker
- **Kitty**: Terminal emulator that supports inline images (WezTerm works too with tweaks)

**For language servers and formatters:**

- **Node.js 18+**: For TypeScript/JavaScript LSP and prettier
- **Python 3.10+**: For pyright, black, isort

**Bonus stuff for advanced Snacks previews:**

- **Tectonic**: For LaTeX rendering (`yay -S tectonic` on Arch)
- **Mermaid CLI**: For diagram previews (`npm install -g @mermaid-js/mermaid-cli`)
- **Ghostscript**: For PDF handling

After setup, run `:checkhealth` to see what's working and what's missing.

## Config Structure

If you want to understand how this is organized or modify it:
```
~/.config/nvim/
├── init.lua                    # Main entry point - bootstraps Lazy and loads config
└── lua/
    ├── config/
    │   ├── init.lua           # Loads all config modules
    │   ├── options.lua        # Vim options (line numbers, indentation, etc.)
    │   ├── keymaps.lua        # Global keymaps
    │   └── autocmds.lua       # Autocommands + appearance customizations
    └── plugins/
        ├── colorscheme.lua    # Rose Pine Moon theme
        ├── ui.lua             # Snacks, bufferline, lualine, indent guides
        ├── editor.lua         # Telescope, neo-tree, which-key, toggleterm
        ├── coding.lua         # Completion, autopairs, comments, copilot
        ├── lsp.lua            # LSP servers, Mason, formatters
        ├── treesitter.lua     # Syntax highlighting
        ├── git.lua            # Gitsigns
        └── diagnostics.lua    # Trouble, todo-comments
```

All plugin files in `lua/plugins/` are automatically loaded by Lazy - you don't need to require them manually. That's the magic!

## Keybindings

**Leader key:** Space

I tried to keep these intuitive and similar to other popular configs. Here are the main ones:

### File Navigation
- `f` - Find files (Telescope)
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Switch buffers
- `<leader>fo` - Recent files
- `<leader>e` - Toggle file explorer (Neo-tree)
  - Press `H` in Neo-tree to toggle hidden files
- `<leader>o` - Focus file explorer

### LSP (Language Server)
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show hover documentation
- `gi` - Go to implementation
- `<leader>ca` - Code actions (quick fixes)
- `<leader>rn` - Rename symbol
- `<leader>cf` - Format current buffer

### Git
- `]h` / `[h` - Next/previous git hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage entire buffer
- `<leader>hp` - Preview hunk
- `<leader>hb` - Git blame for current line
- `<leader>hd` - Diff this

### Buffer Management
- `<S-h>` / `<S-l>` - Cycle through buffers (Shift + h/l)
- `[b` / `]b` - Previous/next buffer
- `<leader>bp` - Pin buffer
- `<leader>bo` - Close all other buffers
- `<leader>bP` - Close all non-pinned buffers

### Diagnostics & Problems
- `<leader>xx` - Show document diagnostics (Trouble)
- `<leader>xX` - Show workspace diagnostics
- `<leader>xL` - Location list
- `<leader>xQ` - Quickfix list
- `]t` / `[t` - Next/previous TODO comment

### Terminal
- `<C-\>` - Toggle floating terminal

### Other Useful Stuff
- `gcc` - Comment/uncomment line
- `gc` (in visual mode) - Comment selection
- `<C-s>` - Save file
- `<leader>q` - Quit
- `<leader>Q` - Quit all
- `<Esc>` - Clear search highlight

For more keybinds, check `lua/config/keymaps.lua` and the individual plugin files.

## Known Issues & Bugs

There's probably some stuff I'm forgetting to tweak or haven't discovered yet. I know it, you know it, but it escapes my mind right now lol. If you find something broken or weird:

1. First, run `:checkhealth` to see if it's a missing dependency
2. Check if it's an LSP issue (some servers are finicky on certain distros)
3. If it's actually broken, please open an issue! Seriously, I'm just one nana-man learning this stuff, so any feedback helps

Some known quirks:
- LSP might throw some errors on first startup (especially on Ubuntu/Pop!_OS) - they usually go away after Mason finishes installing everything
- Image previews only work in Kitty (or terminals with image protocol support)
- On some systems, fd might be called `fdfind` - the Ubuntu install command handles this but if you install manually you might need to symlink it

## Making This Config Your Own

Feel free to fork this and modify it! Some common tweaks:

**Change the colorscheme:**
Edit `lua/plugins/colorscheme.lua` - I use Rose Pine Moon but you can swap in Catppuccin, Gruvbox, Tokyo Night, whatever you want.

**Add more language servers:**
Edit `lua/plugins/lsp.lua` and add servers to the `servers` table. Mason will auto-install them.

**Change keybindings:**
Edit `lua/config/keymaps.lua` for global keymaps, or check the `keys` section in individual plugin files.

**Disable plugins you don't want:**
Just delete the file from `lua/plugins/` or set `enabled = false` in the plugin spec.

## Credits & Thanks

This config wouldn't exist without these amazing projects:

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager by folke
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Dashboard & utilities
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [rose-pine](https://github.com/rose-pine/neovim) - Beautiful theme
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configs
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP installer
- And many more listed in the plugin files

## License

MIT - Do whatever you want with this config. No attribution needed but appreciated if you fork it or build something cool with it!

---

Made with ❤️ (and way too much caffeine) by one nana-man who's still figuring this stuff out
