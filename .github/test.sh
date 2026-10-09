#!/usr/bin/env bash
# CI test: install nananvim with install.sh, install the plugins and the
# parsers, then run the smoke test.
# NANANVIM_REPO is the folder with the code. NANANVIM_REF selects a commit (optional).
# NVIM_NIGHTLY=1 replaces Neovim with the nightly build after the install.
set -euo pipefail

git config --global --add safe.directory '*'

# CI downloads the commit as an archive, without .git. install.sh clones a git
# repository, thus make one from the files.
repo=${NANANVIM_REPO:?set NANANVIM_REPO to the folder with the code}
if [ ! -d "$repo/.git" ]; then
  git -C "$repo" init -q
  git -C "$repo" add -A
  git -c user.name=ci -c user.email=ci@localhost -C "$repo" commit -qm ci
  NANANVIM_REF=$(git -C "$repo" rev-parse HEAD)
  export NANANVIM_REF
fi
bash "$repo/install.sh"

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
