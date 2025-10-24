# Troubleshooting Guide

Common issues and their solutions for nananvim.

## LSP Not Working

### Python LSP (Pyright) Issues

**Problem:** Pyright not starting or showing errors

**Solutions:**
1. Make sure Python 3 is installed: `python3 --version`
2. Restart nvim and let Mason install pyright: `:Mason`
3. Check LSP status: `:LspInfo`
4. On Ubuntu/Pop!_OS, you might need: `sudo apt install python3-dev`

### TypeScript/JavaScript LSP Issues

**Problem:** ts_ls not working

**Solutions:**
1. Install Node.js 18+: `node --version`
2. Restart nvim and check: `:Mason`
3. For project-specific issues, ensure you have `package.json` in your project root

### Clangd Issues

**Problem:** C/C++ LSP not working

**Solutions:**
1. Install clang: `sudo pacman -S clang` (Arch) or `sudo apt install clang` (Ubuntu)
2. For compile_commands.json: Use CMake with `-DCMAKE_EXPORT_COMPILE_COMMANDS=1` or use bear
3. Restart LSP: `:LspRestart`

## Image Previews Not Working

**Problem:** Can't see images in Snacks picker

**Solutions:**
1. Make sure you're using Kitty terminal: `echo $TERM` (should show `xterm-kitty`)
2. Install ImageMagick: `sudo pacman -S imagemagick` or `sudo apt install imagemagick`
3. Check Snacks config in `lua/plugins/ui.lua` - make sure `image = { enabled = true }`

## Plugins Not Loading

**Problem:** Lazy.nvim shows errors or plugins won't install

**Solutions:**
1. Delete lazy cache: `rm -rf ~/.local/share/nvim`
2. Restart nvim - it will reinstall everything
3. Check internet connection
4. If specific plugin fails, check its GitHub page for dependencies

## Treesitter Errors

**Problem:** Syntax highlighting broken or treesitter errors

**Solutions:**
1. Update parsers: `:TSUpdate`
2. Install all parsers: `:TSInstall all`
3. Check for C compiler: `gcc --version` or `clang --version`
4. On Ubuntu: `sudo apt install build-essential`

## Mason Install Failures

**Problem:** Mason can't install language servers

**Solutions:**
1. Check internet connection
2. On Ubuntu, install: `sudo apt install unzip wget curl`
3. Clear Mason cache: `rm -rf ~/.local/share/nvim/mason`
4. Restart nvim and run: `:Mason`

## Performance Issues

**Problem:** Neovim is slow or laggy

**Solutions:**
1. Check for large files - bigfile detection should help
2. Disable unused plugins in `lua/plugins/`
3. Check `:checkhealth` for issues
4. Consider disabling inlay hints: `<leader>th`

## Git Integration Not Working

**Problem:** Gitsigns not showing or git commands fail

**Solutions:**
1. Make sure you're in a git repository: `git status`
2. Install git: `sudo pacman -S git` or `sudo apt install git`
3. Check gitsigns: `:Gitsigns`

## Copilot Issues

**Problem:** GitHub Copilot not suggesting or errors

**Solutions:**
1. Authenticate: `:Copilot auth`
2. Check status: `:Copilot status`
3. Make sure you have an active GitHub Copilot subscription
4. Restart copilot: `:Copilot disable` then `:Copilot enable`

## Config Won't Load

**Problem:** Neovim shows errors on startup

**Solutions:**
1. Check for syntax errors: `nvim --headless "+checkhealth" +qa`
2. View startup errors: `:messages`
3. Backup and reset: `mv ~/.config/nvim ~/.config/nvim.bak` then reinstall
4. Check lazy.nvim: `:Lazy`

## Can't Find Commands

**Problem:** Custom commands like `<leader>cf` not working

**Solutions:**
1. Check if leader is set to space: `:echo mapleader` (should show space)
2. View all keymaps: `:WhichKey`
3. Check keymap file: `~/.config/nvim/lua/config/keymaps.lua`

## Still Having Issues?

1. Run `:checkhealth` and look for errors
2. Check the GitHub issues: https://github.com/m4c4r0n1n/nananvim/issues
3. Open a new issue with:
   - Your OS and version
   - Neovim version: `nvim --version`
   - Error messages from `:messages`
   - Output from `:checkhealth`
