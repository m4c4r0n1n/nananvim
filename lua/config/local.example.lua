-- Personal settings. Copy this file to lua/config/local.lua and change it:
--   cp ~/.config/nvim/lua/config/local.example.lua ~/.config/nvim/lua/config/local.lua
-- Git ignores local.lua. Thus :NananvimUpdate does not change your settings.
--
-- local.lua runs after options.lua, keymaps.lua and autocmds.lua.
-- Thus you can also change options and keymaps here, at the top of the file.

-- vim.opt.relativenumber = false
-- vim.keymap.set("n", "<leader>cm", "<cmd>make<cr>", { desc = "Run make" })
-- vim.o.guifont = "JetBrainsMono Nerd Font:h13" -- Neovide only

return {
  -- AI is on when this file exists. Set false to keep this file without AI.
  ai = true,

  -- Inline suggestions: "windsurf" (free, run :Codeium Auth one time),
  -- "copilot" (run :LspCopilotSignIn one time) or false (no suggestions).
  suggestions = "windsurf",

  -- Avante chat. Remove this table to use the default (Claude, ANTHROPIC_API_KEY).
  -- Set avante = false to turn Avante off.
  -- avante = {
  --   provider = "claude",
  --   providers = {
  --     claude = {
  --       endpoint = "https://api.anthropic.com",
  --       model = "claude-sonnet-5-5",
  --       extra_request_body = { max_tokens = 16000 },
  --     },
  --   },
  -- },

  -- Change the flags in lua/config/extras.lua.
  extras = {
    -- dap = false,
    -- test = false,
    -- ui2 = true,
  },

  -- More linters for nvim-lint, by file type.
  linters_by_ft = {
    -- python = { "mypy" },
  },

  -- More plugins, or changes to the plugins of nananvim. These specs load
  -- after lua/plugins, thus they can change the opts of any plugin.
  plugins = {
    -- { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
    -- { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "rust", "go" } } },
    -- { "folke/flash.nvim", enabled = false },
  },
}
