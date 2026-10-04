-- Extras: the optional IDE layer.
-- All of these features load lazily. A flag only sets the trigger
-- (InsertEnter, BufWritePost or the debug keys). A flag does not load a
-- plugin at startup. Set a flag to false to remove that feature fully.
--
-- To change a flag without a change to this file, set it in
-- lua/config/local.lua: return { extras = { dap = false } }
local defaults = {
  cmp_rich = true, -- Rich completion menu: kind icons, borders, ghost text, documentation
  lint = true, -- nvim-lint linters, added to the LSP diagnostics
  dap = true, -- nvim-dap, dap-ui and automatic .vscode/launch.json support
  test = true, -- neotest test runner (pytest, vitest, jest) on <leader>T
  ui2 = false, -- Neovim 0.12 message UI: no "Press ENTER" prompts (experimental)

  -- Add more blink.cmp sources here. You do not have to change coding.lua.
  -- Each entry is a source name and its provider table.
  -- Example: { emoji = { module = "blink-emoji", name = "Emoji" } }
  -- Add the source plugin as a dependency of blink.cmp in lua/plugins/coding.lua.
  cmp_extra_sources = {},
}

local overrides = require("config.user").settings.extras
if type(overrides) == "table" then
  return vim.tbl_extend("force", defaults, overrides)
end
return defaults
