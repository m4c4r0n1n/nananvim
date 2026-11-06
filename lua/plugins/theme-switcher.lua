-- Theme switcher: look at and apply colorschemes.
return {
  {
    "m4c4r0n1n/theme-switcher.nvim",
    lazy = false,
    config = function()
      require("theme-switcher").setup({
        width = 50,
        height = 25,
        border = "rounded",
        default_bg = "glass",
        exclude = {
          "rose-pine",
          "rose-pine-main",
          "ron",
          "koehler",
          "pablo",
          "evening",
          "shine",
          "zellner",
          "quiet",
        },
      })
    end,
    keys = {
      {
        "<leader>th",
        function()
          require("theme-switcher").toggle()
        end,
        desc = "Theme switcher",
      },
      {
        "<leader>tb",
        function()
          require("theme-switcher").background_menu()
        end,
        desc = "Background menu",
      },
    },
  },
}
