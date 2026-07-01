-- Theme Switcher - Browse and apply colorschemes
return {
  {
    "m4c4r0n1n/theme-switcher.nvim",
    lazy = false,
    config = function()
      require("theme-switcher").setup({
        width = 50,
        height = 25,
        border = "rounded",
        default_bg = "blackout", -- start blacked out (theme text on pure black)
      })
    end,
    keys = {
      { "<leader>th", function() require("theme-switcher").toggle() end, desc = "Theme switcher" },
      { "<leader>tb", function() require("theme-switcher").toggle_background() end, desc = "Toggle blackout / theme background" },
    },
  },
}
