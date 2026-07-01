-- Browser │ Terminal │ TODO panels (float or split layout)
return {
  {
    "m4c4r0n1n/nanabrowser.nvim",
    lazy = false,
    config = function()
      require("nanabrowser").setup({
        -- nil = auto-detect. text browser falls back to external if none installed.
        text_browser = nil, -- w3m > lynx > elinks
        external_browser = nil, -- $BROWSER > xdg-open > brave/chromium/firefox
        layout = "float", -- "float" (tabbed, no column theft) | "split"
        reader_mode = false, -- true = static readable dump, great for docs
        float = { width = 0.85, height = 0.85, border = "rounded" },
        split = { position = "botright", size = 0.35 }, -- fraction of screen height
        default_panels = { "browser", "terminal", "todo" },
      })
    end,
    keys = {
      { "<leader>p", function() require("nanabrowser").toggle_panels() end, desc = "Toggle panels" },
      { "<leader>wb", function() require("nanabrowser").open_browser_prompt() end, desc = "Browse URL (in-editor)" },
      { "<leader>wo", function() require("nanabrowser").open_external_prompt() end, desc = "Open URL (external)" },
      { "gx", function() require("nanabrowser").open_external_cursor() end, desc = "Open URL in browser", mode = { "n", "v" } },
      { "<leader>tt", function() require("nanabrowser").open_terminal() end, desc = "Toggle terminal" },
      { "<leader>td", function() require("nanabrowser").focus_todo() end, desc = "Focus TODO" },
    },
  },
}
