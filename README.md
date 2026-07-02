# nananvim

<img width="1319" height="1376" alt="image" src="https://github.com/user-attachments/assets/0f47d7df-7692-4e4a-8974-d325f8219308" />

# UPDATES!!
I've been slow to update things, I doubt anyone uses this anyway, but I found a few things that could be improved and a few things that could be dropped. I've been really lazy on actually posting updated screenshots or anything like that, but I've fixed the About Me at least.


If you do decide to use this config and something breaks, send me a message and I **WILL** fix it immediately. Thank you.

## We Still Alive

A random dude's minimal and easily customizable neovim config that actually works. Built primarily for Arch but works on most Linux distros and MacOS. Bear with me if something's janky or whatever, I really only fix things as I find them as I use this config daily. I built this for fun initially and to make a small config full of useful tools without too much bloat all while keeping it easy to customize. The idea is to have the most over-glorified, ever evolving neovim config dots possible while remaining easily customizable and well documented should someone else ever decide to give them a shot. Pretty minimal, easy for those who don't want to spend all day configuring neovim to act like an IDE. I'll add random shit as I find it, or find something useful, still a work in progress. Should you trust a random solo dude's configs for nvim? Hell yes.

## What's in it?

- **Snacks.nvim**: Dashboard on startup, plus the fuzzy finder/file picker that can preview images, PDFs, and more right in your terminal (Kitty or Ghostty, anything with the kitty graphics protocol)
- **Treesitter**: Better syntax highlighting and code navigation for 20+ languages
- **LSP**: Language servers auto-install through Mason (Lua, Python, TypeScript, C/C++, HTML/CSS/JSON out of the box)
- **Completion**: nvim-cmp with kind icons, bordered menu/docs, and inline ghost text, plus a hook to append your own sources
- **Linting**: nvim-lint layered on top of LSP (shellcheck, markdownlint, hadolint, yamllint auto-installed); add a linter by adding one table entry
- **DAP**: Debug Adapter Protocol support for Python and C/C++/Rust (via codelldb) with DAP UI, and automatic `.vscode/launch.json` loading per project
- **Theme Switcher**: Browse and preview colorschemes in real-time with `<leader>th`
- **Rose Pine Moon**: Default theme, blacked out by default (theme text colors on a pure black background); `<leader>tb` swaps between blackout and the theme's own background
- **AI (opt-in)**: Codeium inline suggestions + Avante chat, both off by default, flip them on with a `lua/config/local.lua` (see AI setup below)
- **Other stuff**: Bufferline for tabs, gitsigns for git integration, trouble for diagnostics, todo-comments, autopairs, surround motions, conform for formatting, snacks terminal, lualine status bar

### Extras switch

The richer completion UI, standalone linting, and the DAP layer are all wired
through a single master switch at `lua/config/extras.lua`. They're **on by
default** but still fully lazy-loaded, the flags only decide whether a feature's
trigger is armed, not whether it loads at startup. Flip any to `false` to make it
genuinely gone on a lean machine:

```lua
return {
  cmp_rich = true, -- kind icons, bordered menus, ghost text
  lint = true,     -- nvim-lint linters + auto-installed tools
  dap = true,      -- nvim-dap + dap-ui + .vscode/launch.json
  cmp_extra_sources = {}, -- append your own cmp sources here
}
```

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
- Download Neovim 0.12.0+ if needed
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
sudo pacman -S git ripgrep fd imagemagick kitty nodejs npm python clang tree-sitter-cli
```

**For Ubuntu/Debian:**
```bash
sudo apt install git ripgrep fd-find imagemagick kitty nodejs npm python3 clang
# fd-find is called fdfind on Ubuntu, so symlink it:
ln -s $(which fdfind) ~/.local/bin/fd
# tree-sitter-cli only lands in apt from 23.10+; otherwise grab the binary:
# curl -Lo /tmp/tree-sitter.gz https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
# gunzip /tmp/tree-sitter.gz && chmod +x /tmp/tree-sitter && sudo mv /tmp/tree-sitter /usr/local/bin/
```

### 3. Install Neovim 0.12.0+

```bash
curl -fLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
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

- **Neovim 0.12+**: The editor itself (nvim-treesitter v2 requires this; earlier versions won't work)
- **tree-sitter CLI**: Needed by nvim-treesitter v2 to compile parsers. The installer handles this.
- **Git**: For lazy.nvim to work
- **Ripgrep & fd**: Makes file searching pretty fast
- **A Nerd Font**: For icons to display properly

**For the full experience:**

- **ImageMagick**: Required for inline image previews in Snacks picker
- **A kitty-graphics terminal**: Kitty, Ghostty, or WezTerm — anything that speaks the kitty graphics protocol (needed for inline image previews)

**For language servers and formatters:**

- **Node.js 18+**: For TypeScript/JavaScript LSP and prettier
- **Python 3.10+**: For pyright, black, isort
- **clang**: For C/C++ LSP

**For debugging (DAP):**

- **debugpy**: Python debugging (`pip install debugpy`)
- **codelldb**: C/C++/Rust debugging (auto-installed via Mason; no system lldb needed)

After setup, run `:checkhealth` to see what's working and what's missing.

## AI Features Setup

AI is **off by default** to keep startup lean and reliable — no binary downloads, no `make` build, nothing loads until you opt in. Both Codeium (inline suggestions) and Avante (chat) are gated behind a single file: `lua/config/local.lua`. Create it and they turn on.

**Just want free Codeium suggestions?** That's the whole setup:

```bash
mkdir -p ~/.config/nvim/lua/config
echo 'return {}' > ~/.config/nvim/lua/config/local.lua
```

For Avante chat, put your provider config in that same file (see below).

### Codeium (Inline Suggestions)

**Keybindings** (once enabled):
- `<Tab>` - Accept suggestion (falls back to the completion menu when it's open, so cmp keeps `<Tab>`)
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

#### Option 3: Skip AI entirely

Just don't create `local.lua` - no AI plugins load at all (no Codeium, no Avante, no build step). You still get:
- ✅ LSP autocomplete
- ✅ Everything else in the config

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
Uses `codelldb`, auto-installed via Mason — no system lldb or extra packages needed.

**JavaScript/TypeScript:**
Not wired up by default (the old node-debug2 adapter is archived upstream). If you need JS/TS debugging, add `js-debug-adapter` in `lua/plugins/dap.lua`.

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
│   │   ├── autocmds.lua   # Autocommands
│   │   └── commands.lua   # Custom commands
│   └── plugins/
│       ├── colorscheme.lua    # Rose Pine Moon theme
│       ├── ui.lua             # Snacks, bufferline, lualine
│       ├── editor.lua         # neo-tree, which-key, sleuth
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

- `<leader>f` - Find files (Snacks picker) — note: bare `f` is back to the native find-in-line motion
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Switch buffers
- `<leader>fo` - Recent files
- `<leader>fr` - Resume last picker
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
- `<leader>ih` - Toggle inlay hints

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
- `<leader>hs` - Stage / unstage hunk (toggle — run it again on a staged hunk to undo)
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage entire buffer
- `<leader>hp` - Preview hunk
- `<leader>hb` - Git blame for current line
- `<leader>hd` - Diff this

### Buffer Management

- `[b` / `]b` - Previous/next buffer (bare `H`/`L` are left as their native top/bottom-of-screen motions)
- `<leader>bp` - Pin buffer
- `<leader>bo` - Close all other buffers
- `<leader>bP` - Close all non-pinned buffers

### Diagnostics & Problems

- `<leader>xx` - Diagnostics (Trouble)
- `<leader>xX` - Buffer diagnostics (Trouble)
- `<leader>xL` - Location list
- `<leader>xQ` - Quickfix list
- `]t` / `[t` - Next/previous TODO comment

### Terminal

- `<C-\>` - Toggle floating terminal (Snacks terminal)

### AI Features

**Codeium (only when AI is enabled via `local.lua`):**
- `<Tab>` - Accept suggestion (yields to the completion menu when it's open)
- `<M-]>` - Next suggestion
- `<M-[>` - Previous suggestion
- `<C-]>` - Dismiss

**Avante (if configured):**
- `<leader>aa` - Ask AI
- `<leader>ae` - Edit with AI (visual)
- `<leader>ac` - Open chat

### Themes

- `<leader>th` - Theme switcher (browse and preview all themes)
- `<leader>tb` - Toggle blackout ⇄ theme background (blacked out by default)

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
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Dashboard, picker & utilities
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
