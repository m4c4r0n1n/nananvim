# Changelog

Notable changes, newest first. If you use this config and something breaks after an update, open an issue and I **WILL** fix it.

## 2026-07-02

- README overhauled; this changelog split out of it
- New `:checkhealth nananvim`, checks every external tool the config leans on (rg/fd/tree-sitter, kitty-graphics terminal, ImageMagick, text browsers, AI gate) so missing-dependency issues diagnose themselves
- which-key group labels for all leader prefixes (`<leader>f` find, `<leader>d` debug, `<leader>h` git hunks, ...)
- Fixed a pile of deprecated APIs (diagnostic float `source`, conform `lsp_fallback`, legacy sign_define, LspAttach client lookup)
- Fixed shellcheck being run on zsh files (SC1071 on every file), duplicate DAP picker entries from mason-nvim-dap's automatic setup, and stylua never being installed despite conform using it
- Avante Claude fallback bumped to `claude-sonnet-5` (old model retired 2026-06-15)
- CI resurrected (GitHub had auto-disabled it for inactivity), now tests **stable and nightly** Neovim and supports manual dispatch
- Ghostty tab now shows the file being edited
- Installer no longer demands kitty when ghostty is already present

## 2026-07-01

- New **extras switch** (`lua/config/extras.lua`): rich completion UI, nvim-lint layer, and the whole DAP stack behind per-feature flags, on by default, one `false` to strip any of them
- nanabrowser: adaptive auto layout + `<leader>pz` panel zoom
- Blackout background by default; snacks terminal replaces toggleterm
- Picker moved to snacks.picker; telescope dropped

## 2026-06-30, nanabrowser core updates

- Future-proofed for Neovim 0.11/0.12: `termopen()` → `jobstart({term=true})`, `nvim_buf_set_option` → `nvim_set_option_value`, added an nvim-0.10+ version guard
- New float layout (default): one centered, tabbed window (`<Tab>`/`<S-Tab>` to cycle Browser/Terminal/TODO), no permanent column theft. Classic split layout still available, now sized as a fraction of the screen and reflows correctly
- Browser auto-detects a text browser (w3m → lynx → elinks) and gracefully falls back to the external browser if none is installed (previously it just errored)
- Optional reader mode (`-dump` into a real buffer) for readable docs
- External-browser detection via `$BROWSER` → xdg-open → common browsers; browser commands use arg-lists (no shell-quoting breakage)
- Fixed dead user commands (`NanaTodos`, `NanaTodosToggle`, `NanaTerminalToggle` now resolve)
- Command-line completion on `:NanaBrowser` (URL history) and `:NanaPanel` (panel names); `:NanaPanels` / `:NanaZoom` commands; `register_panel()` extension API for adding your own panels
