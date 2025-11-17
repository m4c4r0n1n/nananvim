# nananvim

<img width="1319" height="1376" alt="image" src="https://github.com/user-attachments/assets/0f47d7df-7692-4e4a-8974-d325f8219308" />

A random dude's minimal and easily customizable neovim config that actually works. Built primarily for Arch but works on most Linux distros and MacOS. Bear with me if something's janky or whatever, I'm just one nana-man trying to build a decent config. I built this for fun initially and to make a small config full of useful tools without too much bloat all while keeping it easy to customize. The idea is to have the most over-glorified, ever evolving neovim config dots possible while remaining easily customizable and well documented should someone else ever decide to give them a shot. Pretty minimal, easy for those who don't want to spend all day configuring neovim to act like an IDE. I'll add random shit as I find it, or find something useful, still a work in progress. Should you trust a random solo dude's configs for nvim? Hell yes.

## What's in it?

- **Snacks.nvim**: Dashboard on startup, plus a file picker that can preview images, PDFs, and more right in your terminal (if you're using Kitty)
- **Treesitter**: Better syntax highlighting and code navigation for 20+ languages
- **LSP**: Language servers auto-install through Mason (Lua, Python, TypeScript, C/C++, HTML/CSS/JSON out of the box)
- **DAP**: Debug Adapter Protocol support for Python, C/C++/Rust, and JavaScript/TypeScript with DAP UI
- **Telescope**: Fuzzy finder for live grep, buffers, help tags, and more
- **Theme Switcher**: Browse and preview colorschemes in real-time with `<leader>th`
- **Rose Pine Moon**: Beautiful default theme with pure black background for that clean aesthetic, or your own terminal background color
- **Codeium**: Free AI code suggestions as you type
- **Avante.nvim**: AI chat for code (optional, requires API key setup)
- **Other stuff**: Bufferline for tabs, gitsigns for git integration, trouble for diagnostics, todo-comments, autopairs, surround motions, conform for formatting, toggleterm, lualine status bar

## Screenshots

### Snacks picker with inline image preview

<img width="1699" height="1376" alt="251020_01h25m18s_screenshot" src="https://github.com/user-attachments/assets/80f31521-00a1-4269-a15e-86f8131e266b" />

### Editing with LSP, Treesitter syntax highlighting, and Rose Pine Moon theme

<img width="939" height="1136" alt="image" src="https://github.com/user-attachments/assets/2c54f8b5-b89c-4c1c-8973-15997cc21f3c" />

## Quick Install (One-Line Installer)

The easiest way to install nananvim:

```bash
curl -fsSL https://raw.githubusercontent.com/m4c4r0n1n/nananvim/main/install.sh | bash
```

The installer will:
- Detect your distro (Arch, Ubuntu(lsp issues are harmless working on fix), Fedora, Gentoo, MacOS)
- Install all required dependencies
- Download Neovim 0.10.2+ if needed
- Clone this config to `~/.config/nvim`
- Backup your existing config if present

**Note:** If you want to review the script first: [install.sh](install.sh)

## Manual Install

If you prefer to install manually or want more control:

### 1. Backup your existing config (if you have one)

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

### 2. Install dependencies

**For Arch:**
```bash
sudo pacman -S git ripgrep fd imagemagick kitty nodejs npm python clang
```

**For Ubuntu/Debian:**
```bash
sudo apt install git ripgrep fd-find imagemagick kitty nodejs npm python3 clang
# fd-find is called fdfind on Ubuntu, so symlink it:
ln -s $(which fdfind) ~/.local/bin/fd
```

### 3. Install Neovim 0.10.2+

```bash
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

### 4. Clone this config

```bash
git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nvim
```

### 5. Start Neovim

```bash
nvim
```

Lazy.nvim will (should) automatically install all plugins on first launch. Just wait for it to finish.

### 6. Check everything's working

```vim
:checkhealth
```

## Windows Users

This config is built primarily for Linux. If you're on Windows, you have some options...:

### Option 1: WSL2 (Recommended - Just Do This)

Install Ubuntu through WSL2 and follow the Ubuntu install instructions above. You'll get the full experience including image previews if you use Windows Terminal or another WSL-compatible terminal.

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

- **Neovim 0.10+**: The editor itself (earlier versions might work but no promises)
- **Git**: For lazy.nvim to work
- **Ripgrep & fd**: Makes file searching pretty fast
- **A Nerd Font**: For icons to display properly

**For the full experience:**

- **ImageMagick**: Required for inline image previews in Snacks picker
- **Kitty**: Terminal emulator that supports inline images (WezTerm works too with tweaks)

**For language servers and formatters:**

- **Node.js 18+**: For TypeScript/JavaScript LSP and prettier
- **Python 3.10+**: For pyright, black, isort
- **clang**: For C/C++ LSP

**For debugging (DAP):**

- **debugpy**: Python debugging (`pip install debugpy`)
- **lldb-vscode** or **codelldb**: C/C++/Rust debugging (auto-installed via Mason)
- **node-debug2**: JavaScript/TypeScript debugging (auto-installed via Mason)

After setup, run `:checkhealth` to see what's working and what's missing.

## AI Features Setup

nananvim includes **free Codeium** for inline code suggestions - no setup required. If you don't want AI suggestions, you can disable Codeium by removing it from `lua/plugins/coding.lua`.

### Codeium (Inline Suggestions)

**Keybindings:**
- `<Tab>` - Accept suggestion
- `<M-]>` - Next suggestion
- `<M-[>` - Previous suggestion
- `<C-]>` - Dismiss suggestion

### Avante (AI Chat) - Optional

For AI chat (like ChatGPT in nvim), you'll need to configure a provider:

#### Option 1: FREE - Groq (Recommended)

1. Get a free API key: https://console.groq.com
2. Add to your shell:
```bash
   echo 'export GROQ_API_KEY="your-key"' >> ~/.zshrc
   source ~/.zshrc
```
3. Create config override:
```bash
   mkdir -p ~/.config/nvim/lua/config
   nvim ~/.config/nvim/lua/config/local.lua
```
4. Add this:
```lua
   return {
     avante = {
       provider = "openai",
       providers = {
         openai = {
           endpoint = "https://api.groq.com/openai/v1",
           model = "llama-3.3-70b-versatile",
           extra_request_body = {
             temperature = 0,
             max_tokens = 4096,
           },
         },
       },
     },
   }
```

#### Option 2: Claude (Non-free option)

1. Get API key: https://console.anthropic.com
2. Add to shell:
```bash
   echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.zshrc
   source ~/.zshrc
```
3. Create `~/.config/nvim/lua/config/local.lua`:
```lua
   return {
     avante = {
       provider = "claude",
       providers = {
         claude = {
           endpoint = "https://api.anthropic.com",
           model = "claude-sonnet-4-20250514",
           extra_request_body = {
             temperature = 0,
             max_tokens = 4096,
           },
         },
       },
     },
   }
```

#### Option 3: Skip AI Chat

Just don't create `local.lua` - you'll still get:
- ✅ Free Codeium suggestions
- ✅ LSP autocomplete  
- ✅ All other features

**Avante keybindings** (only if configured):
- `<leader>aa` - Ask AI
- `<leader>ae` - Edit code with AI (visual mode)
- `<leader>ar` - Refresh
- `<leader>at` - Toggle Avante window
- `<leader>ac` - Open chat window
- `<leader>af` - Focus Avante window

## Debugging with DAP

<img width="939" height="560" alt="251026_01h02m58s_screenshot" src="https://github.com/user-attachments/assets/ebf115c9-a363-4c4e-8073-629113305e19" />

nananvim includes full debugging support via nvim-dap. Debug adapters are auto-installed through Mason.

### Quick Start

1. Set a breakpoint: `<leader>db`
2. Start debugging: `<leader>dc`
3. Step through code: `<leader>di` (into), `<leader>do` (over), `<leader>dO` (out)
4. Toggle DAP UI: `<leader>du`

### Language-Specific Setup

**Python:**
```bash
pip install debugpy
```

**C/C++/Rust:**
Debug adapters auto-install via Mason. For better experience:
```bash
# On Arch
sudo pacman -S lldb

# On Ubuntu
sudo apt install lldb
```

**JavaScript/TypeScript:**
Auto-installed via Mason, no additional setup needed.

### DAP Keybindings

- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue/Start debugging
- `<leader>di` - Step into function
- `<leader>do` - Step over function
- `<leader>dO` - Step out of function
- `<leader>dr` - Open REPL
- `<leader>dt` - Terminate debugging
- `<leader>du` - Toggle DAP UI
- `<leader>dh` - Hover to see variable values

## Config Structure

If you want to understand how this is organized or modify it:

```
~/.config/nvim/
├── .github/
│   └── workflows/
│       └── ci.yml         # CI testing
├── docs/                  # Documentation
│   ├── troubleshooting.md
│   ├── customization-guide.md
│   ├── language-specific-setup.md
│   └── advanced-features.md
├── lua/
│   ├── config/
│   │   ├── init.lua       # Loads all config modules
│   │   ├── options.lua    # Vim options
│   │   ├── keymaps.lua    # Global keymaps
│   │   ├── autocmds.lua   # Autocommands + appearance
│   │   └── commands.lua   # Custom commands
│   └── plugins/
│       ├── colorscheme.lua    # Rose Pine Moon theme
│       ├── ui.lua             # Snacks, bufferline, lualine
│       ├── editor.lua         # Telescope, neo-tree, which-key
│       ├── coding.lua         # Completion, autopairs, Codeium, Avante
│       ├── lsp.lua            # LSP servers, Mason, formatters
│       ├── treesitter.lua     # Syntax highlighting
│       ├── git.lua            # Gitsigns
│       ├── diagnostics.lua    # Trouble, todo-comments
│       └── dap.lua            # Debug Adapter Protocol
├── init.lua               # Main entry point
├── README.md              # This file
├── KEYBINDINGS.md         # Complete keybinding reference
├── CONTRIBUTING.md        # Contribution guidelines
├── install.sh             # One-line installer script
└── lazy-lock.json         # Plugin versions
```

All plugin files in `lua/plugins/` are automatically loaded by Lazy - you don't need to require them manually.

## Keybindings

**Leader key:** Space

I tried to keep these intuitive and similar to other popular configs. For a complete reference, see [KEYBINDINGS.md](KEYBINDINGS.md).

### File Navigation

- `f` - Find files (Telescope)
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Switch buffers
- `<leader>fo` - Recent files
- `<leader>e` - Toggle file explorer (Neo-tree)
- `H` in Neo-tree to toggle hidden files
- `<leader>o` - Focus file explorer

### LSP (Language Server)

- `gd` - Go to definition
- `gr` - Find references
- `K` - Show hover documentation
- `gi` - Go to implementation
- `<leader>ca` - Code actions (quick fixes)
- `<leader>rn` - Rename symbol
- `<leader>cf` - Format current buffer
- `<leader>th` - Toggle inlay hints

### Debugging (DAP)

- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue/Start debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dt` - Terminate debugging
- `<leader>du` - Toggle DAP UI

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

### AI Features

**Codeium (always active):**
- `<Tab>` - Accept suggestion
- `<M-]>` - Next suggestion
- `<M-[>` - Previous suggestion
- `<C-]>` - Dismiss

**Avante (if configured):**
- `<leader>aa` - Ask AI
- `<leader>ae` - Edit with AI (visual)
- `<leader>ac` - Open chat

### Themes

- `<leader>th` - Theme switcher (browse and preview all themes)
- `<leader>tb` - Toggle background (Terminal/Blackout)

### Other Useful Stuff

- `gcc` - Comment/uncomment line
- `gc` (in visual mode) - Comment selection
- `<C-s>` - Save file
- `<leader>q` - Quit
- `<leader>Q` - Quit all
- `<Esc>` - Clear search highlight

## Documentation

- **[Troubleshooting Guide](docs/troubleshooting.md)** - Common issues and solutions
- **[Customization Guide](docs/customization-guide.md)** - Make nananvim your own
- **[Language-Specific Setup](docs/language-specific-setup.md)** - Detailed language configuration
- **[Advanced Features](docs/advanced-features.md)** - Power user tips and tricks

## Known Issues & Bugs

There's probably some stuff I'm forgetting to tweak or haven't discovered yet. I know it, you know it, but it escapes my mind right now. If you find something broken or weird:

1. First, run `:checkhealth` to see if it's a missing dependency
2. Check if it's an LSP issue (some servers are finicky on certain distros)
3. If it's actually broken, please open an issue!

Some known quirks:

- LSP might throw some errors on first startup (especially on Ubuntu/Pop!_OS) - they usually go away after Mason finishes installing everything
- On some systems, fd might be called `fdfind` - the Ubuntu install command handles this but if you install manually you might need to symlink it

## Making This Config Your Own

Feel free to fork this and modify it! Check out the [Customization Guide](docs/customization-guide.md) for details on:

- Changing the colorscheme
- Adding more language servers
- Modifying keybindings
- Disabling plugins you don't want
- Adding new plugins

## Contributing

Contributions are welcome! Just read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a PR.

## Credits & Thanks

This config wouldn't exist without these amazing projects:

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager by folke
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Dashboard & utilities
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [rose-pine](https://github.com/rose-pine/neovim) - Theme
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configs
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP installer
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug Adapter Protocol
- [codeium.vim](https://github.com/Exafunction/codeium.vim) - Free AI suggestions
- [avante.nvim](https://github.com/yetone/avante.nvim) - AI chat
- And many more listed in the plugin files

## License

MIT - Do whatever you want with this config. No attribution needed but appreciated if you fork it or build something cool with it!

---

Made with ❤️ (and way too much caffeine).
