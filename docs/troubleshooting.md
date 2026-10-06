# Troubleshooting Guide

Common issues and their solutions for nananvim.

**First step for anything:** run `:checkhealth nananvim`. It checks every external tool this config uses and says what each one is for.

## LSP Not Working

### General

1. See which servers are attached: `:checkhealth vim.lsp`. The status line also lists them on the right.
2. Restart servers: `:lsp restart`
3. Open `:Mason` and check that the server is installed. Mason installs all servers in the background on first launch, so wait a minute on a fresh install.

### Python (basedpyright / ruff) Issues

**Problem:** basedpyright or ruff not starting

**Solutions:**
1. Make sure Python 3 is installed: `python3 --version`
2. Let Mason install them: `:Mason`
3. On Ubuntu/Pop!_OS, Mason needs venv support: `sudo apt install python3-venv`

**Problem:** Too many type errors

basedpyright runs in "standard" mode (same as Pyright). If you changed it, set `typeCheckingMode = "standard"` again in `lua/plugins/lsp.lua`.

### TypeScript/JavaScript LSP Issues

**Problem:** vtsls (TypeScript) not working

**Solutions:**
1. Install Node.js 20+: `node --version`
2. Restart nvim and check: `:Mason`
3. For project-specific issues, ensure you have `package.json` in your project root

### Clangd Issues

**Problem:** C/C++ LSP not working

**Solutions:**
1. Install clang: `sudo pacman -S clang` (Arch) or `sudo apt install clang` (Ubuntu). Mason also installs clangd.
2. For compile_commands.json: Use CMake with `-DCMAKE_EXPORT_COMPILE_COMMANDS=1` or use bear
3. Restart LSP: `:lsp restart`

## NixOS

**Problem:** LSP servers or debuggers from Mason don't start

Mason downloads prebuilt binaries, and on NixOS those need nix-ld (it gives them the normal Linux loader). Add this to `configuration.nix`, then `sudo nixos-rebuild switch`:

```nix
programs.nix-ld.enable = true;
```

`:checkhealth nananvim` tells you whether nix-ld is on. The installer puts the other dependencies in your user profile with `nix profile`; move them to `configuration.nix` or home-manager if you prefer.

## Image Previews Not Working

**Problem:** Can't see images in Snacks picker

**Solutions:**
1. Use a terminal with the kitty graphics protocol: Kitty, Ghostty or WezTerm
2. Install ImageMagick: `sudo pacman -S imagemagick` or `sudo apt install imagemagick`
3. Run `:checkhealth snacks` and read the `Snacks.image` section

## Plugins Not Loading

**Problem:** Lazy.nvim shows errors or plugins won't install

**Solutions:**
1. Delete the plugin data: `rm -rf ~/.local/share/nvim/lazy`
2. Restart nvim, it will reinstall everything
3. Check internet connection
4. Restore the tested plugin versions: `:Lazy restore`

## Treesitter Errors

**Problem:** Syntax highlighting broken or treesitter errors

nananvim uses the `main` branch of nvim-treesitter. It compiles parsers with the `tree-sitter` CLI and a C compiler.

**Solutions:**
1. Check the CLI and compiler: `tree-sitter --version` and `cc --version`
2. Update parsers: `:TSUpdate`
3. Install one parser: `:TSInstall <language>`
4. Read the install log: `:TSLog`
5. On Ubuntu: `sudo apt install build-essential`, then install the tree-sitter CLI (the installer does this)

## Mason Install Failures

**Problem:** Mason can't install language servers

**Solutions:**
1. Check internet connection
2. Install the unpack tools: `sudo apt install unzip curl` (Ubuntu) or `sudo pacman -S unzip curl` (Arch)
3. Clear Mason data: `rm -rf ~/.local/share/nvim/mason`
4. Restart nvim and run: `:Mason`

## Format On Save

**Problem:** A file isn't formatted when you save it

**Solutions:**
1. Check if format on save is on: `<leader>uf` shows the state, `:FormatToggle` changes it
2. See which formatter conform picked: `:ConformInfo`
3. Format manually: `<leader>cf`

**Problem:** You don't want a project formatted

Run `:FormatToggle!` (with `!`) to turn it off for the current buffer only.

## Performance Issues

**Problem:** Neovim is slow or laggy

**Solutions:**
1. Large files are detected automatically (snacks.bigfile turns off heavy features)
2. Turn off a whole feature layer in `lua/config/extras.lua`
3. Check `:Lazy profile` to see what loads at startup
4. Toggle inlay hints off: `<leader>ih`

## Git Integration Not Working

**Problem:** Gitsigns not showing or git commands fail

**Solutions:**
1. Make sure you're in a git repository: `git status`
2. Install git: `sudo pacman -S git` or `sudo apt install git`
3. Check gitsigns: `:Gitsigns`

**Problem:** `<leader>gg` says lazygit not installed

Install lazygit (`sudo pacman -S lazygit`, `brew install lazygit`, or let the installer download it).

## Updating

**Problem:** `:NananvimUpdate` says you changed files

It stops instead of overwriting your edits to tracked files. Move those changes to `lua/config/local.lua` (see `lua/config/local.example.lua`), then run `git -C ~/.config/nvim checkout -- .` and update again. Or keep them with `git -C ~/.config/nvim stash` and `stash pop` afterward.

**Problem:** Something broke after `:Lazy update`

`:Lazy update` moves plugins past the versions CI tested. `:Lazy restore` (or `:NananvimUpdate`) puts them back on the tested versions.

## Copilot Issues

**Problem:** No Copilot suggestions

1. Check `lua/config/local.lua` has `suggestions = "copilot"`
2. Sign in once: `:LspCopilotSignIn`
3. Copilot needs `node` on your PATH
4. Check the server is attached: `:checkhealth vim.lsp` should list `copilot`

## Tests (neotest)

**Problem:** No tests found

The adapters look for pytest (`test_*.py` / `*_test.py`), vitest and jest in the project. The treesitter parser for the language must be installed (it installs itself when you open the file). For Python, pytest must be installed in the active venv.

## Windsurf (Codeium) Issues

**Problem:** No AI suggestions

**Solutions:**
1. Windsurf only loads if `lua/config/local.lua` exists (`return {}` is enough)
2. Log in once: `:Codeium Auth`
3. Check if plugin is loaded: `:Lazy` and look for `windsurf.vim`
4. Restart nvim if suggestions stop appearing

**Problem:** Windsurf suggestions interfering with regular completion

**Solutions:**
1. While the completion menu is open, `<Tab>` moves in the menu. Windsurf only gets `<Tab>` when the menu is closed.
2. Use `<C-]>` to dismiss a suggestion
3. Remap the accept key in `lua/plugins/coding.lua`

## Avante (AI Chat) Issues

**Problem:** Avante not working or showing errors

**Solutions:**
1. Make sure you've created `~/.config/nvim/lua/config/local.lua` (with your provider config, or `return {}` for the Claude default)
2. Check that your API key is set in environment: `echo $ANTHROPIC_API_KEY` or `echo $GROQ_API_KEY`
3. Verify the API key is valid
4. Check `:messages` and `<leader>sn` (notification history) for errors
5. Try `:AvanteToggle` to open/close the window

**Problem:** Avante build fails

Avante needs `make` and `curl` to download its prebuilt binary. Install them, then run `:Lazy build avante.nvim`.

**Problem:** API errors or connection issues

**Solutions:**
1. Check your internet connection
2. Verify your API endpoint is correct in `local.lua`
3. Make sure you haven't exceeded your API rate limits
4. For Groq free tier, check if you've hit daily limits

## Config Won't Load

**Problem:** Neovim shows errors on startup

**Solutions:**
1. Run the same smoke test CI runs: `nvim --headless -c "luafile ~/.config/nvim/.github/smoke.lua"`
2. View startup errors: `:messages` and `<leader>sn`
3. Backup and reset: `mv ~/.config/nvim ~/.config/nvim.bak` then reinstall
4. Check lazy.nvim: `:Lazy`

## Can't Find Commands

**Problem:** Custom commands like `<leader>cf` not working

**Solutions:**
1. Check if leader is set to space: `:echo mapleader` (should show a space)
2. Search all keymaps: `<leader>fk`
3. Show the keymaps for this buffer: `<leader>?`
4. Check keymap file: `~/.config/nvim/lua/config/keymaps.lua`

## Completion Not Working

**Problem:** No autocomplete suggestions appearing

**Solutions:**
1. Make sure LSP is running: `:checkhealth vim.lsp`
2. Check blink.cmp: `:checkhealth blink.cmp` (it also says if the fast Rust matcher downloaded)
3. Try manually triggering: `<C-Space>` in insert mode
4. Check `:messages` for errors

## Inlay Hints Not Showing

**Problem:** Type hints not appearing inline

**Solutions:**
1. Toggle them on: `<leader>ih`
2. Make sure your LSP supports inlay hints
3. Check `:checkhealth vim.lsp` to see if the server is running
4. Some languages don't support inlay hints

## Terminal Not Opening

**Problem:** `<C-\>` doesn't open terminal

**Solutions:**
1. Check if snacks.nvim is loaded: `:Lazy`
2. Try the command directly: `:lua Snacks.terminal.toggle()`
3. Check for conflicting keybindings: `:verbose map <C-\>`
4. Restart nvim

## Buffer Line Not Showing

**Problem:** No tab line at top

**Solutions:**
1. You need multiple buffers open
2. Check setting: `always_show_bufferline = false` only shows with 2+ buffers
3. Open another file to see it appear

## Still Having Issues?

1. Run `:checkhealth nananvim`
2. Run `:checkhealth` and look for errors
3. Check the output from `:messages` for recent errors
4. Try with minimal config to isolate the issue
5. Check the GitHub issues: https://github.com/m4c4r0n1n/nananvim/issues
6. Open a new issue with:
   - Your OS and version
   - Neovim version: `nvim --version`
   - Error messages from `:messages`
   - Output from `:checkhealth nananvim`
   - Steps to reproduce the issue
