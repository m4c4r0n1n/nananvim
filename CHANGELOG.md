# Changelog

Notable changes, newest first. If you use this config and something breaks after an update, open an issue and I **WILL** fix it.

## 2026-10-04, QOL round

Went through everything people end up bolting onto their configs and put it in, all lazy-loaded so startup is still ~30ms.

**New**
- **Sessions** (persistence.nvim): every folder remembers its files and splits, restore from the dashboard (`s`) or `<leader>Ss`
- **oil.nvim** on `-`: rename/move/delete files by editing them like text, `:w` applies it
- **Harpoon**: `<leader>H` marks a file, `<leader>1`-`5` jumps to it, `<leader>j` shows the list
- **Multiple cursors** (multicursor.nvim): `<C-n>` next match, `<leader>M` all matches, `<Esc>` back to one
- **diffview** (the maintained fork): `<leader>gd` side-by-side diff and 3-way merge for conflicts, `<leader>gh` file history
- **neotest**: run the nearest test/file/project, results inline, debug a test with DAP (`<leader>T`). pytest, vitest and jest out of the box, behind `extras.test`
- **Markdown renders in the buffer** (render-markdown), `<leader>um` toggles it
- HTML/JSX tags close and rename themselves (nvim-ts-autotag)
- **Editable quickfix** (quicker.nvim), `<leader>xq`, `>`/`<` for more context
- **Copilot** as a suggestions option: `suggestions = "copilot"` in local.lua, runs on nvim 0.12's built-in inline completion, no plugin
- TypeScript is **vtsls** now (VS Code's engine: move-to-file, imports follow file moves) plus **eslint**
- Folds come from the LSP server when it has them, and an LSP progress spinner
- **`lua/config/local.lua` grew up**: options/keymaps at the top, then `extras`, `plugins` (add plugins or change any built-in one's opts) and `ai = false`. Template in `local.example.lua`. Git ignores it so updates never fight you
- **`:NananvimUpdate`**: git pull + tested plugin versions, refuses to run over your edits
- Opt-in nvim 0.12 message UI (`extras.ui2`), no more "Press ENTER"
- Keymaps: centered `<C-d>`/`<C-u>`, `J` keeps the cursor, `gco`/`gcO`, `]e`/`[e` errors, `]w`/`[w` warnings, `<leader>-`/`<leader>|` splits, `<leader>fy` copy path, undo steps at `,` `.` `;`, DAP conditional breakpoints/log points/run to cursor
- Toggles: diagnostic lines (`<leader>uv`), git blame line (`<leader>ub`), zoom (`<leader>uZ`), smooth scroll (`<leader>uS`)
- Pickers for registers, marks, jumps, commands, highlights, quickfix; scratch buffers on `<leader>.`
- `nvim file.lua:42` opens at line 42, `:SudaWrite` for root-owned files, tmux pane navigation (only loads in tmux), Neovide zoom/paste keys
- Lualine shows `recording @q` while you record a macro (showmode is off so you couldn't see it before)
- matchparen is back on

## 2026-10-03, full update and upgrade

Every plugin updated to its latest version, and the stack moved to what Neovim 0.12 does natively.

**New**
- **blink.cmp** replaces nvim-cmp + LuaSnip (Rust fuzzy matcher, signature help, ghost text, friendly-snippets, cmdline completion). Same keys: `<CR>` accepts only a selected item, `<Tab>`/`<S-Tab>` cycle
- **flash.nvim** (`s` / `S` jumps, `f`/`t` stay native) and **grug-far** project-wide search and replace (`<leader>sr`)
- **Treesitter text objects and motions** finally wired up: `af`/`if`, `ac`/`ic`, `aa`/`ia`, `]f`/`[f`, `]c`/`[c`, `]a`/`[a`, plus a sticky context line (nvim-treesitter-context, `[x`)
- Parsers now **auto-install** the first time you open a file type, and 27 install up front
- **Lazygit and git pickers** (`<leader>gg`, `gl`, `gs`, `gc`, `gb`, `gB` open on GitHub), gitsigns gets visual-line staging, buffer blame, `ih` hunk text object, staged-sign colors
- **LSP pickers**: `gd`/`gr`/`gi`/`gy`/`gD` open in snacks.picker with preview; `<leader>ss`/`sS` symbols; `<leader>cR` renames a file and updates imports (neo-tree renames do too)
- **More servers**: basedpyright + ruff (Python), bashls, yamlls, marksman; JSON/YAML get SchemaStore schemas; Lua gets lazydev.nvim (faster, accurate Neovim API completion)
- **Formatters**: ruff replaces black + isort, shfmt for shell, prettier now also covers JSX/TSX/Vue/Svelte/YAML/Markdown/SCSS
- **`<leader>u` UI toggles** (format on save, wrap, spell, numbers, diagnostics, inlay hints, indent guides, treesitter, dim, zen) and **`:FormatToggle[!]`**
- `:TokenCount` gives an **exact Claude count** through the Anthropic `count_tokens` endpoint when `ANTHROPIC_API_KEY` is set (tiktoken is only a labeled fallback), and works on a visual selection
- New pickers: `<leader>fw` grep word, `<leader>fc` config files, `<leader>fk` keymaps, `<leader>fp` projects, `<leader>su` undo history, `<leader>sn` notifications, `<leader>st` TODOs
- Quality-of-life autocommands: restore cursor position, reload files changed outside nvim, equalize splits on resize, close help/qf/etc. with `q`, wrap + spell for Markdown and commits, create missing folders on save
- `<leader>l` (Lazy) and `<leader>m` (Mason) now exist (they were documented but never mapped); project `.nvim.lua` files work (`exrc`)
- Lualine shows git diff and attached LSP servers; lazy.nvim checks for updates in the background so the update counter actually works

**Changed**
- Native Neovim 0.12 features instead of plugins: built-in `gc` commenting (Comment.nvim removed, ts-comments.nvim adds embedded-language support), built-in treesitter incremental selection, global `winborder`, linked HTML tag editing
- snacks.indent replaces indent-blankline; snacks.input/picker replace dressing.nvim for Avante
- `mason-org/*` repositories (moved from williamboman); mason-nvim-dap removed, debug adapters install through mason-tool-installer, so nvim-dap truly loads only on `<leader>d` keys
- Codeium plugin is now **windsurf.vim** (same `codeium#` functions and keys)
- Avante default model is now **claude-sonnet-5-5** with 16k max tokens
- Mason, LSP and conform load on the first file instead of at startup: ~35ms startup, 6 plugins before the first screen
- `cmp_extra_sources` in `lua/config/extras.lua` now takes blink.cmp providers: `{ name = { module = "...", ... } }`
- Code comments rewritten to ASD-STE100 Simplified Technical English

**Fixed**
- Nerd Font icons for diagnostic signs, DAP breakpoints and gitsigns deletes had been stripped to blank spaces; they render again
- Installer: Ubuntu Neovim version check broke on the `v` prefix, `curl | bash` made the "replace config?" prompt read from the script itself, macOS installed the tree-sitter *library* instead of the CLI, Fedora failed on `lazygit` (not in Fedora repos). Also arm64 support, a tarball Neovim install (no FUSE), and `unzip`/`make` dependencies for Mason and Avante
- `]h`/`[h` and `]c`/`[c` keep their native meaning in diff mode
- CI: real smoke test that fails on startup errors (the old one could not fail), StyLua and ShellCheck enforced, no em dashes allowed, actions updated (checkout v7, upload-artifact v7, stylua-action v5), nightly failures no longer block

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
