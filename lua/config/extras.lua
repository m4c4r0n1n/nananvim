-- ── Extras: the heavier IDE layer ───────────────────────────────────────────
-- Master switch for the optional "community-grade" features. Everything here is
-- still LAZY-LOADED — these flags only decide whether a feature's trigger is
-- armed (InsertEnter / BufWritePost / debug keys), NOT whether it loads at
-- startup. Flip a flag to false to make that feature genuinely gone on a given
-- machine; the core config stays lean either way.
return {
  cmp_rich = true, -- richer nvim-cmp UI: kind icons, bordered menu/docs, ghost text
  lint = true, -- nvim-lint standalone linters, layered on top of LSP diagnostics
  dap = true, -- nvim-dap + dap-ui + automatic .vscode/launch.json debugging

  -- Drop-in hook: extra nvim-cmp sources to append without touching coding.lua.
  -- e.g. { { name = "nvim_lua" }, { name = "emoji" } } once those plugins exist.
  cmp_extra_sources = {},
}
