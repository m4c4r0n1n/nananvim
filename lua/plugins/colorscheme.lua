return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        disable_background = true, -- Keeps your black background
      })
      vim.cmd.colorscheme("rose-pine-moon")
    end,
  },
}
