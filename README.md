# nananvim

<img width="1718" height="1362" alt="image" src="https://github.com/user-attachments/assets/de3c5790-93db-410b-bb40-52619dfa93ee" />

TIRED OF LAZYVIM? WANT SOMETHING LESS BLOATED? TRY NANANVIM! A fast, minimal, fully documented Neovim config that actually works. ~35ms startup, 53 plugins with only 6 loaded before the first screen draws, CI-tested against Neovim **stable and nightly** with a smoke test that fails on any startup error. Batteries included, bloat optional.

<img width="1319" height="1376" alt="image" src="https://github.com/user-attachments/assets/0f47d7df-7692-4e4a-8974-d325f8219308" />

Built primarily for Arch but works on most Linux distros and MacOS. I use this daily and fix things the moment they break, or eventually... If you do decide to use this config and something breaks, open an issue and I **WILL** fix it immediately. Thank you.

Latest: I've added a bunch of quality of life stuff (sessions, oil, harpoon, multiple cursors, a test runner, diffview, NananvimUpdate command, rendered markdown and more), and your own settings now live in one file that updates never touch. Full rundown in the [CHANGELOG](CHANGELOG.md).

## Why nananvim?

Because why not. Nobody will use this, lol. But if you're here, here are some specs:

- **Kinda Fast**: ~35ms startup. 53 plugins total, only 6 load before the first screen draws, everything else waits for its trigger. Completion runs on blink.cmp's Rust fuzzy matcher.
- **Built on Neovim 0.12, not around it**: native `vim.lsp.config`/`vim.lsp.enable`, native commenting, native treesitter incremental selection, global rounded borders (`winborder`), linked HTML tag editing. Less plugin glue, fewer things to break.
- **Custom Plugins** (see below): a Browser│Terminal│TODO panel workspace, and a live-preview theme switcher with a blackout mode.
- **Easy to use and functional**: rich completion UI, a full linting layer, and the entire DAP debugging stack sit behind per-feature flags in one file (`lua/config/extras.lua`). On by default, one `false` to genuinely remove any of them.
- **Updates don't eat your settings**: your stuff lives in one gitignored file (`lua/config/local.lua`): options, keymaps, extra plugins, overrides for any built-in plugin. `:NananvimUpdate` pulls the new version and the tested plugin versions without touching it.
- **AI is opt-in, not opt-out**: no Windsurf, no Avante, no binary downloads, no `make` step, until you create one file. Delete the file, it's all gone.
- **Tested, not vibes**: CI loads every plugin headless on stable *and* nightly Neovim on every push and fails on any startup error, then checks formatting (StyLua), the installer (ShellCheck) and the docs. `:checkhealth nananvim` diagnoses your machine.
- **Documented like someone might actually read it**: full [keybinding reference](KEYBINDINGS.md), [customization guide](docs/customization-guide.md), [troubleshooting](docs/troubleshooting.md), [advanced features](docs/advanced-features.md).

## First-party plugins

### [nanabrowser.nvim](https://github.com/m4c4r0n1n/nanabrowser.nvim): Browser │ Terminal │ TODO workspace

One keypress (`<leader>p`) toggles a panel workspace: an in-editor text browser (w3m/lynx/elinks, auto-detected), a terminal, and a persistent TODO list. Adaptive layout: side-by-side when your window is wide, a tabbed float when it isn't. `<leader>pz` zooms one panel to full size and back. `gx` opens the URL under your cursor externally; `<leader>wb` browses it in-editor. Extensible: `register_panel()` lets you add your own panels.

### [theme-switcher.nvim](https://github.com/m4c4r0n1n/theme-switcher.nvim): live theme preview + blackout

`<leader>th` opens a picker that previews every installed colorscheme **live as you move over it**, and remembers your pick across sessions. `<leader>tb` toggles blackout mode: the theme's text colors on a pure black background (the default), or the theme's own background. Drop any colorscheme plugin into `lua/plugins/` and it shows up automatically.

## What else is in it?

- **Snacks.nvim**: Dashboard, fuzzy picker (files, grep, LSP, git, undo history, keymaps...) that can preview images, PDFs and more right in your terminal (Kitty or Ghostty, anything with the kitty graphics protocol), notifications, indent guides, lazygit, terminal, zen mode and `<leader>u` UI toggles
- **Treesitter** (`main` branch): highlighting and indent for 25+ languages out of the box, and any other parser installs itself the first time you open that file type. Function/class/argument text objects and motions, plus a sticky context line
- **LSP**: Native Neovim 0.12 LSP, servers auto-install through Mason (Lua, Python via basedpyright + ruff, TypeScript/JavaScript via vtsls + eslint, HTML/CSS/Tailwind, JSON/YAML with SchemaStore, Bash, Markdown, C/C++). Definitions and references open in a picker with preview, folds come from the server when it has them, and a spinner shows what the server is doing
- **Completion**: blink.cmp with kind icons, bordered menu/docs, ghost text, signature help, friendly-snippets, cmdline completion, and a hook to append your own sources
- **Formatting**: conform.nvim formats on save (ruff, stylua, prettier, shfmt, clang-format); `<leader>uf` toggles it
- **Linting**: nvim-lint layered on top of LSP (shellcheck, markdownlint, hadolint, yamllint auto-installed); add a linter by adding one table entry
- **DAP**: Debug Adapter Protocol support for Python, C/C++/Rust (via codelldb), Bash/sh, JavaScript/TypeScript, and Lua (Neovim config/plugins, via osv) with DAP UI, and automatic `.vscode/launch.json` loading per project
- **Testing**: neotest runs the test under the cursor, the file or the whole project (pytest, vitest, jest), results inline, debug a test with DAP
- **Motion and search**: flash.nvim jumps (`s`), grug-far project-wide search and replace with live preview (`<leader>sr`), harpoon for your 5 most-used files, multiple cursors (`<C-n>`)
- **Files**: neo-tree, plus oil.nvim (`-`) to rename/move/delete files by editing them like text
- **Git**: gitsigns (stage lines, blame, hunk text object), lazygit (`<leader>gg`), diffview for side-by-side diffs, file history and merge conflicts, git pickers, open on GitHub
- **Sessions**: every folder remembers its open files and splits; restore from the dashboard (`s`)
- **Markdown**: rendered right in the buffer (headings, tables, checkboxes); the raw text shows on the cursor line
- **Rose Pine Moon**: Default theme, blacked out by default
- **AI (opt-in)**: Windsurf (Codeium) inline suggestions + Avante chat (Claude Sonnet 5.5 by default), both off by default, flip them on with a `lua/config/local.lua` (see AI setup below)
- **Other stuff**: Bufferline for tabs, trouble for diagnostics, an editable quickfix list, todo-comments, autopairs + auto-closing HTML/JSX tags, surround motions, lualine status bar (git diff, LSP servers, macro recording, plugin updates), which-key with labeled groups, scratch buffers, `nvim file.lua:42` opens at line 42, `:SudaWrite` for root files, tmux pane navigation, Neovide support, `:TokenCount` with exact Claude token counts

### Extras switch

The richer completion UI, standalone linting, and the DAP layer are all wired
through a single master switch at `lua/config/extras.lua`. They're **on by
default** but still fully lazy-loaded, the flags only decide whether a feature's
trigger is armed, not whether it loads at startup. Flip any to `false` to make it
genuinely gone on a lean machine:

```lua
return {
  cmp_rich = true, -- kind icons, bordered menus, ghost text, auto docs
  lint = true,     -- nvim-lint linters + auto-installed tools
  dap = true,      -- nvim-dap + dap-ui + .vscode/launch.json
  test = true,     -- neotest on <leader>T
  ui2 = false,     -- Neovim 0.12 message UI, no "Press ENTER" (experimental)
  cmp_extra_sources = {}, -- append your own blink.cmp sources here
}
```

Rather not touch a tracked file? Flip them from `lua/config/local.lua` instead: `return { extras = { dap = false } }`.

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
- Detect your distro (Arch, Fedora, Debian, Ubuntu, NixOS, Void, Gentoo, macOS, and distros based on them), x86_64 and arm64
- Install all required dependencies (including lazygit and the tree-sitter CLI)
- Download the latest stable Neovim (0.12+) if yours is too old
- Clone this config to `~/.config/nvim`
- Backup your existing config if present

**Note:** If you want to review the script first: [install.sh](install.sh)

Want to see what it does before it touches anything? Add `--dry-run`. It prints every package, backup and delete, and changes nothing:

```bash
curl -fsSL https://raw.githubusercontent.com/m4c4r0n1n/nananvim/main/install.sh | bash -s -- --dry-run
```

## Manual Install

If you prefer to install manually or want more control:

### 1. Backup your existing config (if you have one)

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

### 2. Install dependencies

**For Arch:**
```bash
sudo pacman -S git curl unzip ripgrep fd imagemagick kitty nodejs npm python clang tree-sitter-cli lazygit
```

**For Ubuntu/Debian:**
```bash
sudo apt install git curl unzip ripgrep fd-find imagemagick kitty nodejs npm python3 python3-venv clang build-essential
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
- **Git, curl, unzip**: For lazy.nvim, Mason and parser downloads
- **A C compiler**: For treesitter parsers (`build-essential` / `base-devel` / Xcode tools)
- **Ripgrep & fd**: Makes file searching pretty fast
- **A Nerd Font**: For icons to display properly

**For the full experience:**

- **ImageMagick**: Required for inline image previews in Snacks picker
- **A kitty-graphics terminal**: Kitty, Ghostty, or WezTerm, anything that speaks the kitty graphics protocol (needed for inline image previews)
- **w3m** (or lynx/elinks): The in-editor text browser for the panel workspace, auto-detected, falls back to your external browser if absent
- **lazygit**: The git UI on `<leader>gg`

**For language servers and formatters:**

- **Node.js 20+**: For the TypeScript/HTML/CSS/JSON/YAML servers and prettier
- **Python 3.10+**: For basedpyright and ruff (Mason installs both)
- **clang**: For C/C++ (Mason installs clangd if you don't have it)

**For debugging (DAP):**

- **debugpy / codelldb / bash-debug-adapter / js-debug-adapter**: Python, C/C++/Rust, Bash/sh, and JS/TS debugging, all auto-installed via Mason, no manual install needed
- **node**: only needed if you debug JavaScript/TypeScript (the js-debug adapter runs on it)
- **osv**: Lua debugging for Neovim config/plugins, a pure-Lua plugin (no system package, nothing to install)

After setup, run `:checkhealth nananvim` to see what's working and what's missing.

## AI Features Setup

AI is **off by default** to keep startup lean and reliable, no binary downloads, no `make` build, nothing loads until you opt in. Inline suggestions and Avante (chat) are gated behind a single file: `lua/config/local.lua`. Create it and they turn on.

**Just want free Windsurf suggestions?** That's the whole setup (then run `:Codeium Auth` once to log in):

```bash
cp ~/.config/nvim/lua/config/local.example.lua ~/.config/nvim/lua/config/local.lua
```

**Got GitHub Copilot instead?** Set `suggestions = "copilot"` in that file and run `:LspCopilotSignIn` once. It runs on Neovim 0.12's built-in inline completion, so there's no Copilot plugin at all. `suggestions = false` turns suggestions off but keeps Avante.

With no `avante` table, Avante uses Claude Sonnet 5.5 and reads `ANTHROPIC_API_KEY`. For a different provider, put its config in that same file (see below), or `avante = false` to drop it.

### Windsurf / Copilot (Inline Suggestions)

**Keybindings** (once enabled):
- `<Tab>` - Accept suggestion (while the completion menu is open, `<Tab>` moves in the menu instead)
- `<M-]>` - Next suggestion
- `<M-[>` - Previous suggestion
- `<C-]>` - Dismiss suggestion (Windsurf)

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
           model = "claude-sonnet-5-5", -- or "claude-opus-5-5" for harder tasks
           extra_request_body = {
             max_tokens = 16000,
           },
         },
       },
     },
   }
```
(Don't set `temperature` for Claude Sonnet 5.5, it rejects non-default sampling params.) This is also the built-in default, so `return {}` gets you the same thing.

#### Option 3: Skip AI entirely

Just don't create `local.lua`, no AI plugins load at all (no Windsurf, no Avante, no build step). You still get:
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

<img width="3438" height="1400" alt="image" src="https://github.com/user-attachments/assets/4605dfd2-5450-4466-b242-79402f5ce90e" />


nananvim includes full debugging support via nvim-dap. Debug adapters are auto-installed through Mason in the background, and nvim-dap itself only loads the first time you press a `<leader>d` key.

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

**Lua (Neovim config/plugins):**
Uses `osv` (one-small-step-for-vimkind), a pure-Lua plugin, nothing to install. Because it debugs Lua running *inside* Neovim (anything using the `vim` API), it's a two-instance workflow, the same as debugging Neovim Lua in any editor:

1. In the Neovim instance running the code you want to debug (the **debuggee**), press `<leader>dL` to start the debug server (`osv.launch` on port 8086).
2. In a **second** Neovim with the source file open (your editor/**client**), set breakpoints with `<leader>db` and press `<leader>dc` to attach.
3. Trigger the code in the debuggee (e.g. run the command or `:source` the file). The breakpoint hits and you step through from the client.

Attaching and launching are deliberately separate keys: if one instance both launched and attached, it would freeze itself on the first breakpoint with no client left to drive it. That two-instance split is inherent to debugging in-process Lua, not a nananvim quirk. For standalone `.lua` scripts run outside Neovim, osv isn't the right tool (it has no plain-interpreter mode).

**Panels too cramped?** The DAP UI panel sizes live at the top of the `config`
function in `lua/plugins/dap.lua` (`left_panel_width` / `bottom_panel_height`).
Bump either number and restart to give the sidebar or repl/console more room.

### DAP Keybindings

- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue/Start debugging (attach, for Lua)
- `<leader>di` - Step into function
- `<leader>do` - Step over function
- `<leader>dO` - Step out of function
- `<leader>dr` - Open REPL
- `<leader>dl` - Run last configuration
- `<leader>dL` - Launch the Lua debug server (run this in the debuggee, see Lua setup above)
- `<leader>dt` - Terminate debugging
- `<leader>du` - Toggle DAP UI
- `<leader>dh` - Hover to see variable values
- `<leader>dS` - Show scopes in a float

## Config Structure

If you want to understand how this is organized or modify it:

```
~/.config/nvim/
├── .github/
│   ├── smoke.lua          # CI smoke test: loads every plugin, fails on errors
│   └── workflows/
│       └── ci.yml         # CI: smoke test on stable + nightly nvim, StyLua, ShellCheck
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
│   │   ├── commands.lua   # :TokenCount, :FormatToggle, :NananvimUpdate
│   │   ├── extras.lua     # Master switch: cmp UI / lint / DAP / test / ui2 flags
│   │   ├── user.lua       # Reads local.lua (you don't edit this one)
│   │   ├── local.example.lua  # Template for your personal settings
│   │   └── local.lua      # (optional, gitignored) your settings, AI opt-in, extra plugins
│   ├── nananvim/
│   │   └── health.lua     # :checkhealth nananvim
│   └── plugins/
│       ├── colorscheme.lua    # Rose Pine Moon theme
│       ├── theme-switcher.lua # Live theme preview + blackout toggle
│       ├── nanabrowser.lua    # Browser │ Terminal │ TODO workspace
│       ├── ui.lua             # Snacks (dashboard/picker/terminal/toggles), bufferline, lualine
│       ├── editor.lua         # neo-tree, oil, which-key, flash, grug-far, harpoon, multicursor, sessions
│       ├── coding.lua         # blink.cmp, autopairs, autotag, ts-comments, surround, Windsurf, Avante
│       ├── lsp.lua            # LSP servers, Mason, lazydev, SchemaStore, conform formatters
│       ├── lint.lua           # nvim-lint (gated by extras.lint)
│       ├── treesitter.lua     # Parsers, text objects, sticky context
│       ├── git.lua            # Gitsigns, diffview, lazygit and git pickers
│       ├── diagnostics.lua    # Trouble, quicker (quickfix), todo-comments
│       ├── test.lua           # neotest (gated by extras.test)
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
- `<leader>fw` - Grep the word under the cursor
- `<leader>sr` - Search and replace across the project (grug-far)
- `s` - Flash jump: type 1-2 characters, then the label
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

- `gd` - Go to definition (picker with preview)
- `gr` - Find references (picker with preview)
- `K` - Show hover documentation
- `gI` / `gy` - Go to implementation / type definition
- `<leader>ca` - Code actions (quick fixes)
- `<leader>rn` - Rename symbol
- `<leader>cf` - Format current buffer (`<leader>uf` toggles format on save)
- `<leader>cR` - Rename the file (imports update)
- `<leader>ih` - Toggle inlay hints

### Debugging (DAP)

- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue/Start debugging (attach, for Lua)
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dr` - Open REPL
- `<leader>dl` - Run last configuration
- `<leader>dL` - Launch Lua debug server (debuggee)
- `<leader>dt` - Terminate debugging
- `<leader>du` - Toggle DAP UI
- `<leader>dh` - Hover variables
- `<leader>dS` - Show scopes (float)

### Git

- `]h` / `[h` - Next/previous git hunk
- `<leader>hs` - Stage / unstage hunk (toggle, run it again on a staged hunk to undo)
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage entire buffer
- `<leader>hp` - Preview hunk
- `<leader>hb` - Git blame for current line
- `<leader>hd` - Diff this
- `<leader>gg` - Lazygit
- `<leader>gs` / `<leader>gc` / `<leader>gb` - Git status / commits / branches pickers
- `<leader>gB` - Open the file on GitHub

### Buffer Management

- `[b` / `]b` - Previous/next buffer (bare `H`/`L` are left as their native top/bottom-of-screen motions)
- `<leader>bd` - Delete buffer (keeps your window layout)
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

**Windsurf / Codeium (only when AI is enabled via `local.lua`):**
- `<Tab>` - Accept suggestion (the completion menu gets `<Tab>` first while it's open)
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
- `af` / `if`, `ac` / `ic`, `aa` / `ia` - Function / class / argument text objects (`]f` / `[f` to jump between functions)
- `<C-Space>` - Expand selection by syntax node (`<BS>` shrinks)
- `<leader>u` - UI toggles (wrap, spell, diagnostics, zen...)
- `-` - Open the parent folder in oil (edit files like text)
- `<C-n>` - Add a cursor at the next match (`<Esc>` clears)
- `<leader>H` / `<leader>j` / `<leader>1`-`5` - Harpoon: mark file / list / jump
- `<leader>Ss` - Restore this folder's session
- `<leader>Tr` / `<leader>Tt` - Run nearest test / file
- `<leader>gd` / `<leader>gh` - Diff view / file history
- `<leader>.` - Scratch buffer
- `<leader>-` / `<leader>|` - Split below / right
- `]e` / `[e` - Next / previous error
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

- LSP servers start a minute late on first startup, Mason installs them in the background. Watch progress in `:Mason`
- Treesitter parsers compile on first launch; if highlighting is missing, check that `tree-sitter` and a C compiler are installed (`:checkhealth nananvim`)
- On some systems, fd might be called `fdfind` - the Ubuntu install command handles this but if you install manually you might need to symlink it

## Updating

```vim
:NananvimUpdate
```

Pulls the latest nananvim and puts every plugin on the version CI tested, then `:restart`. Your `lua/config/local.lua` is never touched. If you edited a tracked file, it stops and tells you which one instead of making a mess.

## Making This Config Your Own

Put your changes in `lua/config/local.lua` (copy `local.example.lua`) and updates never conflict: options and keymaps at the top, then `extras`, `linters_by_ft` and `plugins` (new plugins, or `opts` for any built-in one) in the returned table. Want to go deeper? Fork it. The [Customization Guide](docs/customization-guide.md) covers:

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
- [mason.nvim](https://github.com/mason-org/mason.nvim) - LSP installer
- [blink.cmp](https://github.com/Saghen/blink.cmp) - Completion
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug Adapter Protocol
- [flash.nvim](https://github.com/folke/flash.nvim) - Jump anywhere
- [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) - Search and replace
- [oil.nvim](https://github.com/stevearc/oil.nvim) - Edit the file system like a buffer
- [neotest](https://github.com/nvim-neotest/neotest) - Test runner
- [diffview.nvim](https://github.com/dlyongemallo/diffview.nvim) - Diffs and merge conflicts
- [multicursor.nvim](https://github.com/jake-stewart/multicursor.nvim) - Multiple cursors
- [windsurf.vim](https://github.com/Exafunction/windsurf.vim) - Free AI suggestions
- [avante.nvim](https://github.com/yetone/avante.nvim) - AI chat
- And many more listed in the plugin files

## License

MIT - Do whatever you want with this config. No attribution needed but appreciated if you fork it or build something cool with it!

---

Made with ❤️ (and way too much caffeine).
