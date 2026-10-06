# Changelog

Notable changes, newest first. If you use this config and something breaks after an update, open an issue and I **WILL** fix it.

## 2026-10-06, safer installer

`install.sh --dry-run` shows everything the installer would do (packages, backups, what it deletes) without changing anything. CI runs it too.

`:TokenCount` no longer puts your API key on the curl command line, where other programs on your machine could see it.

Web stuff: Vue, Svelte and Astro servers are in now, with types working in Vue templates. Emmet (`<C-z>,`) was set up but never actually turned on, so it works now, in Astro and SCSS too. `.mdx` files get highlighting, and the parsers for Vue, Svelte, Astro, SCSS and GraphQL install up front.

Fresh installs are cleaner: the installer adds wl-clipboard and xclip so yank reaches your system clipboard, and the Python provider is off (nothing used it, it only threw a health error). Panel zoom moved from `<leader>pz` to `<leader>z`, the same key it already was inside the panels, so `<leader>p` opens the panels without a delay.

Theme switcher: `j`/`k`/`q` work in the picker again, it remembers the exact variant you pick (rose-pine-dawn stays dawn), it doesn't spam a message on every move, and blackout now blacks out the selected tab, which-key, popups and menus too.

First launch (and the first start after an update with new parsers) is quieter: the treesitter parsers install with one message instead of a wall of text and a "Press ENTER" prompt. `:checkhealth nananvim` checks the clipboard too.

## 2026-10-04, works on more systems

The installer runs on Arch, Fedora, Debian, Ubuntu, NixOS, Void, Gentoo and macOS now (plus stuff based on them like Manjaro, Mint or Kali), and CI actually runs it on every one of those so it stays that way. If your distro ships an old Neovim or tree-sitter it grabs a newer one instead of breaking. Also fixed the installer banner.

The installer now also grabs a current Node.js if yours is too old (Ubuntu 22.04 ships 12, 24.04 ships 18), so the TypeScript, HTML, CSS, JSON and YAML servers install right. Your `avante` table in `local.lua` now only changes what you set instead of wiping the defaults, and the bash debugger works on NixOS.

## 2026-10-04, QOL round

I've added a bunch of quality of life stuff to make it nicer to live in day to day: sessions that remember your files per folder (`s` on the dashboard), oil on `-` so you can rename/move files like text, harpoon, multiple cursors on `<C-n>`, diffview for diffs and merge conflicts, a test runner on `<leader>T`, markdown that renders right in the buffer, auto-closing HTML/JSX tags, and an editable quickfix list. Plus a pile of small keymaps and `<leader>u` toggles.

Copilot works now too if that's your thing (`suggestions = "copilot"`), and TypeScript runs on vtsls + eslint.

Your own tweaks go in `lua/config/local.lua` (copy `local.example.lua`) so updates never step on them, and `:NananvimUpdate` grabs the latest version for you. Still loads in ~30ms.

## 2026-10-03, full update and upgrade

Updated every plugin and moved things over to what Neovim 0.12 does on its own. Completion is blink.cmp now (same keys, way faster), added flash for jumping (`s`), grug-far for search and replace, lazygit on `<leader>gg`, and the treesitter text objects (`af`, `if`, `]f`...) actually work now. Python uses basedpyright + ruff, and there's format on save you can turn off with `<leader>uf`.

Fixed the icons that had gone blank, a handful of installer bugs (Ubuntu, macOS, Fedora, arm64), and CI actually catches broken startups now. Heads up: `s` is flash now (use `cl` for the old one) and `gbc` is gone, use `gc` with a motion.

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
