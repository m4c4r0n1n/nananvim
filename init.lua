-- Install lazy.nvim if it is not on the disk.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load the options and the keymaps before the plugins.
-- The leader key must be set before lazy.nvim reads the plugin keys.
require("config")

-- Load lua/config/local.lua after the defaults. Thus its settings win.
local user = require("config.user")

-- Neovim 0.12 message UI (experimental). Turn it on in lua/config/extras.lua.
if require("config.extras").ui2 then
  local ok, ui2 = pcall(require, "vim._core.ui2")
  if ok then
    ui2.enable({})
  end
end

-- Plugin specs: the files in lua/plugins, then the plugins from local.lua.
-- local.lua specs load last. Thus they can change the opts of any plugin.
local spec = { { import = "plugins" } }
if type(user.settings.plugins) == "table" then
  table.insert(spec, user.settings.plugins)
end

require("lazy").setup({
  spec = spec,
  defaults = { lazy = true },
  install = { colorscheme = { "rose-pine-moon", "habamax" } },
  -- Check for plugin updates in the background. Do not show a message.
  -- The lualine status bar shows the number of updates.
  checker = { enabled = true, notify = false, frequency = 86400 },
  change_detection = { notify = false },
  -- No plugin in this config needs luarocks. This prevents a health warning.
  rocks = { enabled = false },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
