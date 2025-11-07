-- Side-by-side panel system: Browser │ Terminal │ TODO
return {
  {
    "m4c4r0n1n/nanabrowser.nvim",
    lazy = false,
    config = function()
      require("nanabrowser").setup({
        browser = "w3m",
        external_browser = "firefox", -- or "chromium", "brave", "google-chrome", etc.
        height = 20,
        browser_width = 40,
        terminal_width = 30,
        todo_width = 30,
        borders = true, -- Enable Telescope-style borders
        border_style = "rounded", -- Options: "rounded", "solid", "double", "none"
      })
    end,
    keys = {
      -- Toggle all panels
      { "<leader>p", function() require("nanabrowser").toggle_panels() end, desc = "Toggle panels" },
      -- Browser (w3m - text browser)
      { "<leader>wb", function() require("nanabrowser").open_browser_prompt() end, desc = "Browse URL (w3m)" },
      -- External browser (Firefox/Chrome/etc)
      { "<leader>wo", function() require("nanabrowser").open_external_prompt() end, desc = "Open URL (external)" },
      { "gx", function() require("nanabrowser").open_external_cursor() end, desc = "Open URL in browser", mode = { "n", "v" } },
      -- Terminal
      { "<leader>tt", function() require("nanabrowser").open_terminal() end, desc = "Open terminal" },
      -- TODO
      { "<leader>td", function() require("nanabrowser").focus_todo() end, desc = "Focus TODO" },
    },
  },
}
