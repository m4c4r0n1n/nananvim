-- Extras: the optional IDE layer.
-- All of these features load lazily. A flag only sets the trigger
-- (InsertEnter, BufWritePost or the debug keys). A flag does not load a
-- plugin at startup. Set a flag to false to remove that feature fully.
return {
  cmp_rich = true, -- Rich completion menu: kind icons, borders, ghost text, documentation
  lint = true, -- nvim-lint linters, added to the LSP diagnostics
  dap = true, -- nvim-dap, dap-ui and automatic .vscode/launch.json support

  -- Add more blink.cmp sources here. You do not have to change coding.lua.
  -- Each entry is a source name and its provider table.
  -- Example: { emoji = { module = "blink-emoji", name = "Emoji" } }
  -- Add the source plugin as a dependency of blink.cmp in lua/plugins/coding.lua.
  cmp_extra_sources = {},
}
