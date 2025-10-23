# nananvim

<img width="1319" height="1376" alt="image" src="https://github.com/user-attachments/assets/0f47d7df-7692-4e4a-8974-d325f8219308" />

A minimal Neovim config that actually works. No bloat, no bullshit, just a clean setup powered by lazy.nvim that gets you coding fast. Built for Arch, but runs on most Linux distros.

## What You're Getting

This isn't your typical "I copied NvChad" config. It's a from-scratch setup that cherry-picks a few useful things:

- **Snacks.nvim**: Folke's latest plugin that does everything - dashboard, file picker with inline image previews (yeah, images IN your terminal if you're using Kitty), statuscolumn, and more
- **Full LSP Support**: Auto-installs language servers through Mason. Comes ready for Lua, Python, TypeScript, Go, Rust, C/C++, and web stuff (HTML/CSS/JSON)
- **Treesitter**: Syntax highlighting, auto-installs parsers for 20+ languages
- **Telescope**: The fuzzy finder that everyone uses. Live grep, buffer switching, git integration, the works
- **Rose Pine Moon**: Dark theme with pure black background because we're not animals
- **GitHub Copilot**: For those who want it or just remove it from coding.lua
- **Smart Formatting**: Auto-formats on save using prettier, black, stylua, clang-format, etc.
- **Git Integration**: Gitsigns shows changes inline, browse GitHub links, lazygit integration
- **Useful Keybinds**: Space as leader, `f` for files, everything where you'd expect it

## Screenshots

### Dashboard & File Picker
<img width="1699" height="1376" alt="251020_01h25m18s_screenshot" src="https://github.com/user-attachments/assets/80f31521-00a1-4269-a15e-86f8131e266b" />

### Coding with LSP & Treesitter
<img width="939" height="1136" alt="image" src="https://github.com/user-attachments/assets/2c54f8b5-b89c-4c1c-8973-15997cc21f3c" />

## Installation

## Quick Install

The easiest way to install nananvim is with the automated installer:
```bash
curl -fsSL https://raw.githubusercontent.com/m4c4r0n1n/nananvim/main/install.sh | bash
```

The installer will:
- Detect your distro (Arch, Ubuntu, Fedora, Gentoo, MacOS)
- Install all required dependencies
- Download Neovim 0.10.2+ if needed
- Clone this config to `~/.config/nvim`
- Backup your existing config if present

**Note:** Review the [install.sh](install.sh) script before running if you want to see what it does.

**Or run distro-specific commands** (if you don't want to use the installer)

### Quick Install (Just Works™)

Pick your distro and paste one command:

**Arch Linux:**
```bash
sudo pacman -S git ripgrep fd imagemagick kitty nodejs npm python python-pip clang && \
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && \
chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim && \
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null; \
git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim && nvim
```

**Ubuntu/Debian/Pop!_OS:**
```bash
sudo apt update && sudo apt install -y git ripgrep fd-find imagemagick kitty nodejs npm python3 python3-pip clang curl build-essential && \
mkdir -p ~/.local/bin && ln -sf $(which fdfind) ~/.local/bin/fd && \
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && \
chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim && \
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null; \
git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim && nvim
```

**Fedora:**
```bash
sudo dnf install -y git ripgrep fd-find ImageMagick kitty nodejs npm python3 python3-pip clang && \
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && \
chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim && \
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null; \
git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim && nvim
```

Lazy.nvim will auto-install all plugins on first launch. Just wait like 30 seconds and you're good.

### Manual Install

If you want more control:

1. **Backup First:**
```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

2. **Install dependencies:**
```bash
# Arch
sudo pacman -S git ripgrep fd imagemagick kitty nodejs npm python python-pip clang

# Ubuntu/Debian  
sudo apt install git ripgrep fd-find imagemagick kitty nodejs npm python3 python3-pip clang
ln -s $(which fdfind) ~/.local/bin/fd  # Ubuntu calls fd something stupid

# Fedora
sudo dnf install git ripgrep fd-find ImageMagick kitty nodejs npm python3 python3-pip clang
```

3. **Install Neovim 0.10+:**
```bash
# AppImage method (works everywhere)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# Or use your package manager if it has 0.10+
```

4. **Clone this config:**
```bash
git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim
```

5. **Launch and wait:**
```bash
nvim
```

First launch will take a minute while Lazy installs everything. When it's done, run `:checkhealth` to make sure everything's working.

## Keybindings

Leader = Space. Here's what you actually need to know:

### Finding Stuff
- `f` - Find files (Telescope)
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Switch buffers
- `<leader>fo` - Recent files
- `<leader>fh` - Help tags (search Neovim help)

### File Explorer
- `<leader>e` - Toggle Neo-tree
- `<leader>o` - Focus Neo-tree
- `H` in Neo-tree - Show hidden files

### LSP (When in a code file)
- `gd` - Go to definition
- `gr` - Find references  
- `K` - Hover docs
- `gi` - Go to implementation
- `<leader>ca` - Code actions (fixes, refactors)
- `<leader>rn` - Rename symbol
- `<leader>cf` - Format file

### Git
- `]h` / `[h` - Next/previous git change
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line
- `<leader>gg` - Open Lazygit (if installed)

### Buffers
- `<S-h>` / `<S-l>` - Previous/next buffer
- `<leader>bd` - Delete buffer
- `<leader>bo` - Close other buffers

### Windows
- `<C-h/j/k/l>` - Navigate between splits
- `<C-w>v` - Vertical split
- `<C-w>s` - Horizontal split
- `<C-w>q` - Close window

### Other
- `<C-\>` - Toggle terminal
- `gcc` - Comment line
- `gc` in visual mode - Comment selection
- `<C-s>` - Save
- `<leader>q` - Quit
- `<leader>Q` - Quit all

### Copilot
- `<C-y>` - Accept suggestion
- `<M-]>` / `<M-[>` - Next/previous suggestion
- `<C-]>` - Dismiss suggestion

## File Structure

```
~/.config/nvim/
├── init.lua                    # Entry point - bootstraps lazy.nvim
└── lua/
    ├── config/
    │   ├── init.lua           # Loads all config modules
    │   ├── options.lua        # Vim options (line numbers, tabs, etc)
    │   ├── keymaps.lua        # Global keybindings
    │   └── autocmds.lua       # Auto commands (highlight yanks, etc)
    └── plugins/
        ├── colorscheme.lua    # Rose Pine theme
        ├── ui.lua            # UI stuff (snacks, bufferline, lualine)
        ├── editor.lua        # Editor tools (telescope, neo-tree, which-key)
        ├── coding.lua        # Completion, snippets, copilot
        ├── lsp.lua          # Language servers and formatting
        ├── treesitter.lua   # Syntax highlighting
        ├── git.lua          # Git integration
        └── diagnostics.lua  # Error handling (trouble, todo-comments)
```

Each plugin file is automatically loaded by lazy.nvim. Want to add something? Drop a new file in `plugins/` and it just works.

## Language Support

These work out of the box:

- **Lua** - lua_ls with Neovim API support
- **Python** - pyright, black, isort
- **JavaScript/TypeScript** - ts_ls, prettier, ESLint
- **C/C++** - clangd with full IntelliSense
- **Go** - gopls
- **Rust** - rust-analyzer
- **Web** - HTML, CSS, Tailwind, JSON
- **Markdown** - With preview support
- **YAML/TOML** - For your configs

Want more? Add them to the `servers` table in `lua/plugins/lsp.lua`. Mason will handle installation.

## Troubleshooting

### Snacks image preview not working?
```bash
# Quick fix
pkill -f nvim
rm -rf ~/.local/share/nvim/lazy/snacks.nvim ~/.cache/nvim ~/.local/state/nvim/lazy
nvim  # Then run :Lazy sync
```

### LSP not working?
- Run `:Mason` and check if servers are installed
- `:LspInfo` shows active servers for current file
- `:checkhealth` for general diagnostics

### Telescope can't find files?
Make sure you have ripgrep and fd installed. The installer should handle this but:
```bash
# Arch
sudo pacman -S ripgrep fd

# Ubuntu
sudo apt install ripgrep fd-find
```

### Images not showing in file preview?
- You need Kitty terminal (or WezTerm with tweaks)
- Check with: `kitty +kitten icat --detect-support`
- Make sure `TERM=xterm-kitty` is set

### Copilot not working?
Run `:Copilot setup` and authenticate with GitHub.

## Customization

### Change theme
Edit `lua/plugins/colorscheme.lua`. Current theme is Rose Pine Moon but you can swap in whatever:
- catppuccin
- tokyonight  
- gruvbox
- nord
- dracula

### Add plugins
Create a new file in `lua/plugins/` or add to an existing one. Example:

```lua
-- lua/plugins/my-stuff.lua
return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },
  {
    "someone/cool-plugin",
    config = function()
      require("cool-plugin").setup({
        -- options
      })
    end,
  },
}
```

### Change options
Edit `lua/config/options.lua`. It's all commented so you know what does what.

### Add keybinds
Global ones go in `lua/config/keymaps.lua`. Plugin-specific ones go in the plugin's `keys` table.

## Performance

This config is fast. Like, actually fast:
- Lazy loading everything that doesn't need to be immediate
- Startup time: ~50-100ms on decent hardware
- No useless plugins or eye candy that tanks performance
- Big file detection auto-disables heavy features

## Tips

1. **Learn the keybinds** - Muscle memory is everything. Start with `f` for files and `<leader>fg` for grep.

2. **Use `:Lazy` to manage plugins** - Update with `U`, clean with `x`, profile with `P`.

3. **`:Mason` manages language servers** - Install new ones with `i`, update with `U`.

4. **Customize gradually** - Don't dump 50 plugins in at once. This config is a solid base.

5. **Read the messages** - When shit breaks, `:messages` usually tells you why.

## Why This Config?

I made this because:
- Most configs are either too minimal (no features) or too bloated (250 plugins)
- Wanted something that works out of box

This is my daily driver. It's not perfect but it works for actual coding, not just looking pretty in screenshots.

## Contributing

Found a bug? Something broken? Cool feature idea? PRs welcome. Just:
- Keep it minimal
- Test your changes
- Explain what and why

## License

MIT - Take it, modify it, make it yours. Credit appreciated but not required.

---

Made with caffeine and questionable life choices by a guy who just wanted to customize Neovim.

If this helped you, star the repo. If it didn't, open an issue and tell me why it sucks.
