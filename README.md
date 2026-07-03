# nananvim

<img width="1718" height="1362" alt="image" src="https://github.com/user-attachments/assets/de3c5790-93db-410b-bb40-52619dfa93ee" />

A fast, minimal, fully documented Neovim config that actually works. ~45ms startup, 40 plugins with only 17 loaded at boot, CI-tested against Neovim **stable and nightly**. Batteries included, bloat optional.

<img width="1319" height="1376" alt="image" src="https://github.com/user-attachments/assets/0f47d7df-7692-4e4a-8974-d325f8219308" />

Built primarily for Arch but works on most Linux distros and MacOS. I use this daily and fix things the moment they break, or eventually... If you do decide to use this config and something breaks, open an issue and I **WILL** fix it immediately. Thank you.

What's changed lately lives in the [CHANGELOG](CHANGELOG.md).

## Why nananvim?

There are a hundred "minimal nvim configs" out there. Here's what this one does differently:

- **Actually fast**: ~45ms startup. 40 plugins total, only 17 load at startup, everything else waits for its trigger.
- **Two first-party plugins you won't find anywhere else** (see below): a Browser│Terminal│TODO panel workspace, and a live-preview theme switcher with a blackout mode.
- **An IDE when you want one, not when you don't**: rich completion UI, a full linting layer, and the entire DAP debugging stack sit behind per-feature flags in one file (`lua/config/extras.lua`). On by default, one `false` to genuinely remove any of them.
- **AI is opt-in, not opt-out**: no Codeium, no Avante, no binary downloads, no `make` step, until you create one file. Delete the file, it's all gone.
- **Tested, not vibes**: CI runs the whole config headless on stable *and* nightly Neovim on every push. `:checkhealth nananvim` diagnoses your machine.
- **Documented like someone might actually read it**: full [keybinding reference](KEYBINDINGS.md), [customization guide](docs/customization-guide.md), [troubleshooting](docs/troubleshooting.md), [advanced features](docs/advanced-features.md).

## First-party plugins

### [nanabrowser.nvim](https://github.com/m4c4r0n1n/nanabrowser.nvim): Browser │ Terminal │ TODO workspace

One keypress (`<leader>p`) toggles a panel workspace: an in-editor text browser (w3m/lynx/elinks, auto-detected), a terminal, and a persistent TODO list. Adaptive layout: side-by-side when your window is wide, a tabbed float when it isn't. `<leader>pz` zooms one panel to full size and back. `gx` opens the URL under your cursor externally; `<leader>wb` browses it in-editor. Extensible: `register_panel()` lets you add your own panels.

### [theme-switcher.nvim](https://github.com/m4c4r0n1n/theme-switcher.nvim): live theme preview + blackout

`<leader>th` opens a picker that previews every installed colorscheme **live as you move over it**, and remembers your pick across sessions. `<leader>tb` toggles blackout mode: the theme's text colors on a pure black background (the default), or the theme's own background. Drop any colorscheme plugin into `lua/plugins/` and it shows up automatically.

## What else is in it?

- **Snacks.nvim**: Dashboard on startup, plus the fuzzy finder/file picker that can preview images, PDFs, and more right in your terminal (Kitty or Ghostty, anything with the kitty graphics protocol)
- **Treesitter**: Better syntax highlighting and code navigation for 20+ languages
- **LSP**: Language servers auto-install through Mason (Lua, Python, TypeScript, C/C++, HTML/CSS/JSON out of the box)
- **Completion**: nvim-cmp with kind icons, bordered menu/docs, and inline ghost text, plus a hook to append your own sources
- **Linting**: nvim-lint layered on top of LSP (shellcheck, markdownlint, hadolint, yamllint auto-installed); add a linter by adding one table entry
- **DAP**: Debug Adapter Protocol support for Python, C/C++/Rust (via codelldb), Bash/sh, and JavaScript/TypeScript with DAP UI, and automatic `.vscode/launch.json` loading per project
- **Rose Pine Moon**: Default theme, blacked out by default
- **AI (opt-in)**: Codeium inline suggestions + Avante chat, both off by default, flip them on with a `lua/config/local.lua` (see AI setup below)
- **Other stuff**: Bufferline for tabs, gitsigns for git integration, trouble for diagnostics, todo-comments, autopairs, surround motions, conform for formatting, snacks terminal, lualine status bar, which-key with labeled groups

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

<img width="1718" height="1400" alt="image" src="https://github.com/user-attachments/assets/a36b2720-f89e-4226-93c6-452d5127a9f6" />

### Editing with LSP, Treesitter syntax highlighting, and Rose Pine Moon theme

<img width="1718" height="1400" alt="image" src="https://github.com/user-attachments/assets/c3855bf3-304a-4bdd-80bd-640c596a1046" />

### Silly Theme-Picker I Made

<img width="1718" height="1362" alt="image" src="https://github.com/user-attachments/assets/d93ea09b-8973-4884-af19-5ab23d7dc9fc" />
Like most others, but it doesn't keep moving the selections over each time you scroll.

### A Panel Project

<img width="1718" height="1400" alt="image" src="https://github.com/user-attachments/assets/b98bac43-4de5-4aa4-b6ec-db4d8055b7ea" />


## Try it without touching your config

Zero risk, your existing setup stays exactly where it is:

```bash
git clone https://github.com/m4c4r0n1n/nananvim.git ~/.config/nananvim
NVIM_APPNAME=nananvim nvim
```

Plugins install into their own isolated data directory. Don't like it? `rm -rf ~/.config/nananvim ~/.local/share/nananvim ~/.local/state/nananvim ~/.cache/nananvim` and it never happened. Like it? Alias `NVIM_APPNAME=nananvim nvim` or do a real install below.

## Quick Install (One-Line Installer)

```bash
curl -fsSL https://raw.githubusercontent.com/m4c4r0n1n/nananvim/main/install.sh | bash
```

The installer will:
- Detect your distro (Arch, Ubuntu, Fedora, Gentoo, MacOS)
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

(Already on Ghostty or WezTerm? Skip kitty, it's only needed for the kitty graphics protocol, which they both speak.)

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

Lazy.nvim will automatically install all plugins on first launch. Just wait for it to finish.

### 6. Check everything's working

```vim
:checkhealth nananvim
```

This checks every external tool the config leans on (ripgrep, fd, tree-sitter, a kitty-graphics terminal, ImageMagick, text browsers, AI setup) and tells you exactly what's missing and what it's for.

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
- **A kitty-graphics terminal**: Kitty, Ghostty, or WezTerm, anything that speaks the kitty graphics protocol (needed for inline image previews)
- **w3m** (or lynx/elinks): The in-editor text browser for the panel workspace, auto-detected, falls back to your external browser if absent

**For language servers and formatters:**

- **Node.js 18+**: For TypeScript/JavaScript LSP and prettier
- **Python 3.10+**: For pyright, black, isort
- **clang**: For C/C++ LSP

**For debugging (DAP):**

- **debugpy / codelldb / bash-debug-adapter / js-debug-adapter**: Python, C/C++/Rust, Bash/sh, and JS/TS debugging, all auto-installed via Mason, no manual install needed
- **node**: only needed if you debug JavaScript/TypeScript (the js-debug adapter runs on it)

After setup, run `:checkhealth nananvim` to see what's working and what's missing.

## AI Features Setup

AI is **off by default** to keep startup lean and reliable, no binary downloads, no `make` build, nothing loads until you opt in. Both Codeium (inline suggestions) and Avante (chat) are gated behind a single file: `lua/config/local.lua`. Create it and they turn on.

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
           model = "claude-sonnet-5",
           extra_request_body = {
             max_tokens = 4096,
           },
         },
       },
     },
   }
```
(Don't set `temperature` for Claude Sonnet 5, it rejects non-default sampling params.)

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

<img width="1718" height="1400" alt="image" src="https://github.com/user-attachments/assets/84a823a8-a373-4cc9-99f4-34ccc3909be5" />

nananvim includes full debugging support via nvim-dap. Debug adapters are auto-installed through Mason.

### Quick Start

1. Set a breakpoint: `<leader>db`
2. Start debugging: `<leader>dc`
3. Step through code: `<leader>di` (into), `<leader>do` (over), `<leader>dO` (out)
4. Toggle DAP UI: `<leader>du`

### Language-Specific Setup

Debug adapters are auto-installed via Mason, so most languages need nothing extra.

**Python:**
`debugpy` is auto-installed via Mason (run from its own venv, so no `pip install` needed). The program under debug still runs on your project interpreter (venv if one is active).

**C/C++/Rust:**
Uses `codelldb`, auto-installed via Mason, no system lldb or extra packages needed.

**Bash/sh:**
Uses `bash-debug-adapter`, auto-installed via Mason (bundles its own `bashdb`).

**JavaScript/TypeScript:**
Uses `js-debug-adapter` (vscode-js-debug), auto-installed via Mason. Requires `node` on your PATH.

**Panels too cramped?** The DAP UI panel sizes live at the top of the `config`
function in `lua/plugins/dap.lua` (`left_panel_width` / `bottom_panel_height`).
Bump either number and restart to give the sidebar or repl/console more room.

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
│       └── ci.yml         # CI: headless boot on stable + nightly nvim
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
│   │   ├── commands.lua   # Custom commands
│   │   ├── extras.lua     # Master switch: cmp UI / lint / DAP flags
│   │   └── local.lua      # (optional, gitignored) AI opt-in + overrides
│   ├── nananvim/
│   │   └── health.lua     # :checkhealth nananvim
│   └── plugins/
│       ├── colorscheme.lua    # Rose Pine Moon theme
│       ├── theme-switcher.lua # Live theme preview + blackout toggle
│       ├── nanabrowser.lua    # Browser │ Terminal │ TODO workspace
│       ├── ui.lua             # Snacks (dashboard/picker/terminal), bufferline, lualine
│       ├── editor.lua         # neo-tree, which-key, sleuth
│       ├── coding.lua         # Completion, autopairs, Codeium, Avante
│       ├── lsp.lua            # LSP servers, Mason, conform formatters
│       ├── lint.lua           # nvim-lint (gated by extras.lint)
│       ├── treesitter.lua     # Syntax highlighting
│       ├── git.lua            # Gitsigns
│       ├── diagnostics.lua    # Trouble, todo-comments
│       └── dap.lua            # Debug Adapter Protocol (gated by extras.dap)
├── init.lua               # Main entry point
├── README.md              # This file
├── CHANGELOG.md           # What's changed
├── KEYBINDINGS.md         # Complete keybinding reference
├── CONTRIBUTING.md        # Contribution guidelines
├── install.sh             # One-line installer script
└── lazy-lock.json         # Plugin versions
```

All plugin files in `lua/plugins/` are automatically loaded by Lazy, you don't need to require them manually.

## Keybindings

**Leader key:** Space

I tried to keep these intuitive and similar to other popular configs. Press `<Space>` and wait, which-key shows every group, labeled. For a complete reference, see [KEYBINDINGS.md](KEYBINDINGS.md).

### File Navigation

- `<leader>f` - Find files in cwd (Snacks picker; bare `f` stays the native find-in-line motion)
- `<leader>ff` - Find files (home)
- `<leader>fa` - Find all files incl. hidden/ignored (home)
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Switch buffers
- `<leader>fo` - Recent files
- `<leader>fr` - Resume last picker
- `<leader>e` - Toggle file explorer (Neo-tree)
- `H` in Neo-tree to toggle hidden files
- `<leader>o` - Focus file explorer

### Panel Workspace (nanabrowser)

- `<leader>p` - Toggle Browser │ Terminal │ TODO panels
- `<leader>pz` - Zoom current panel (focus one / show all)
- `<Tab>` / `<S-Tab>` - Cycle panels (float layout)
- `<leader>wb` - Browse a URL in-editor (w3m/lynx/elinks)
- `<leader>wo` - Open a URL in your external browser
- `gx` - Open URL under cursor externally (normal/visual)
- `<leader>tt` - Toggle the panel terminal
- `<leader>td` - Focus the TODO panel

### Themes

- `<leader>th` - Theme switcher (live preview as you browse)
- `<leader>tb` - Toggle blackout ⇄ theme background (blacked out by default)

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
- `<leader>hs` - Stage / unstage hunk (toggle, run it again on a staged hunk to undo)
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
- `<leader>tt` - Panel terminal (part of the nanabrowser workspace)

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

If you find something broken or weird:

1. First, run `:checkhealth nananvim`, it knows what every dependency is for and will tell you what's missing
2. Check if it's an LSP issue (some servers are finicky on certain distros)
3. If it's actually broken, please open an issue, I use this daily and fix things fast

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
