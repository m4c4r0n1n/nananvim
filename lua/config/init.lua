vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("mason")
    require("mason-lspconfig")
  end,
})
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
