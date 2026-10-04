#!/usr/bin/env bash
# CI test: install nananvim with install.sh, install the plugins and the
# parsers, then run the smoke test.
# NANANVIM_REPO and NANANVIM_REF select the commit to install.
# NVIM_NIGHTLY=1 replaces Neovim with the nightly build after the install.
set -euo pipefail

git config --global --add safe.directory '*'
bash "$NANANVIM_REPO/install.sh"

if [ -n "${NVIM_NIGHTLY:-}" ]; then
  curl -fsSL -o /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
  tar -xzf /tmp/nvim.tar.gz -C /tmp
  export PATH="/tmp/nvim-linux-x86_64/bin:$PATH"
fi
nvim --version | head -n 1

nvim --headless "+Lazy! restore" +qa
nvim --headless -c 'lua
  local spec = require("lazy.core.config").plugins["nvim-treesitter"]
  local opts = require("lazy.core.plugin").values(spec, "opts", false)
  require("nvim-treesitter").install(opts.ensure_installed):wait(900000)' -c qa

nvim --headless "+checkhealth nananvim" "+w! /tmp/health.log" +qa || true
cat /tmp/health.log || true

nvim --headless -c "luafile $HOME/.config/nvim/.github/smoke.lua"
