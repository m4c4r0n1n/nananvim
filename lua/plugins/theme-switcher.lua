-- Theme Switcher - Browse and apply colorschemes
return {
  {
    "theme-switcher.nvim",
    dir = vim.fn.expand("~/projects/theme-switcher.nvim"),
    lazy = false,
    config = function()
      require("theme-switcher").setup({
        width = 50,
        height = 25,
        border = "rounded",
      })
    end,
    keys = {
      { "<leader>th", function() require("theme-switcher").toggle() end, desc = "Theme switcher" },
      { "<leader>tb", function() require("theme-switcher").toggle_background() end, desc = "Toggle background (Terminal/Blackout)" },
    },
  },
}
