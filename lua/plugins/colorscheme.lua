-- lua/plugins/colorscheme.lua
return {
  -- Rose Pine (installed but not auto-applied - use theme-switcher)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        -- Don't disable background - let theme-switcher control it
      })
      -- Defer to avoid getcompletion interrupt during ColorSchemePre phase
      vim.schedule(function()
        vim.cmd.colorscheme("rose-pine-moon")
      end)
    end,
  },
}
