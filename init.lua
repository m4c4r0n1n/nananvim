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

require("lazy").setup("plugins", {
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
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
