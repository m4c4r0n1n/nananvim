return {
  -- Rose Pine Moon is the default theme. Use <leader>th to select a different theme.
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        -- Keep the background. theme-switcher controls the background mode.
      })
      -- Apply the theme later. This prevents an interrupt in the ColorSchemePre event.
      vim.schedule(function()
        vim.cmd.colorscheme("rose-pine-moon")
      end)
    end,
  },
}
