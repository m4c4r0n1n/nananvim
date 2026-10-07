# Features

Everything in the box.

- **Snacks.nvim**: Dashboard, fuzzy picker (files, grep, LSP, git, undo history, keymaps...) that can preview images, PDFs and more right in your terminal (Kitty or Ghostty, anything with the kitty graphics protocol), notifications, indent guides, lazygit, terminal, zen mode and `<leader>u` UI toggles
- **Treesitter** (`main` branch): highlighting and indent for 30+ languages out of the box, and any other parser installs itself the first time you open that file type. Function/class/argument text objects and motions, plus a sticky context line
- **LSP**: Native Neovim 0.12 LSP, servers auto-install through Mason (Lua, Python via basedpyright + ruff, TypeScript/JavaScript via vtsls + eslint, HTML/CSS/Tailwind, Vue, Svelte, Astro, JSON/YAML with SchemaStore, Bash, Markdown, C/C++). Definitions and references open in a picker with preview, folds come from the server when it has them, and a spinner shows what the server is doing
- **Completion**: blink.cmp with kind icons, bordered menu/docs, ghost text, signature help, friendly-snippets, cmdline completion, and a hook to append your own sources
- **Formatting**: conform.nvim formats on save (ruff, stylua, prettier, shfmt, clang-format); `<leader>uf` toggles it
- **Linting**: nvim-lint layered on top of LSP (shellcheck, markdownlint, hadolint, yamllint auto-installed); add a linter by adding one table entry
- **DAP**: Debug Adapter Protocol support for Python, C/C++/Rust (via codelldb), Bash/sh, JavaScript/TypeScript, and Lua (Neovim config/plugins, via osv) with DAP UI, and automatic `.vscode/launch.json` loading per project
- **Testing**: neotest runs the test under the cursor, the file or the whole project (pytest, vitest, jest), results inline, debug a test with DAP
- **Motion and search**: flash.nvim jumps (`s`), grug-far project-wide search and replace with live preview (`<leader>sr`), harpoon for your 5 most-used files, multiple cursors (`<C-n>`)
- **Files**: neo-tree, plus oil.nvim (`-`) to rename/move/delete files by editing them like text
- **Git**: gitsigns (stage lines, blame, hunk text object), lazygit (`<leader>gg`), diffview for side-by-side diffs, file history and merge conflicts, git pickers, open on GitHub
- **Sessions**: every folder remembers its open files and splits; restore from the dashboard (`s`)
- **Markdown**: rendered right in the buffer (headings, tables, checkboxes); the raw text shows on the cursor line
- **Rose Pine Moon**: Default theme, blacked out by default
- **AI (opt-in)**: Windsurf (Codeium) inline suggestions + Avante chat (Claude Sonnet 5.5 by default), both off by default, flip them on with a `lua/config/local.lua` (see [AI Setup](ai-setup.md))
- **Other stuff**: Bufferline for tabs, trouble for diagnostics, an editable quickfix list, todo-comments, autopairs + auto-closing HTML/JSX tags, Emmet (`<C-z>,`), surround motions, lualine status bar (git diff, LSP servers, macro recording, plugin updates), which-key with labeled groups, scratch buffers, `nvim file.lua:42` opens at line 42, `:SudaWrite` for root files, tmux pane navigation, Neovide support, `:TokenCount` with exact Claude token counts

## Credits

This config wouldn't exist without these amazing projects:

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager by folke
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Dashboard, picker & utilities
- [rose-pine](https://github.com/rose-pine/neovim) - Theme
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configs
- [mason.nvim](https://github.com/mason-org/mason.nvim) - LSP installer
- [blink.cmp](https://github.com/Saghen/blink.cmp) - Completion
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug Adapter Protocol
- [flash.nvim](https://github.com/folke/flash.nvim) - Jump anywhere
- [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) - Search and replace
- [oil.nvim](https://github.com/stevearc/oil.nvim) - Edit the file system like a buffer
- [neotest](https://github.com/nvim-neotest/neotest) - Test runner
- [diffview.nvim](https://github.com/dlyongemallo/diffview.nvim) - Diffs and merge conflicts
- [multicursor.nvim](https://github.com/jake-stewart/multicursor.nvim) - Multiple cursors
- [windsurf.vim](https://github.com/Exafunction/windsurf.vim) - Free AI suggestions
- [avante.nvim](https://github.com/yetone/avante.nvim) - AI chat
- And many more listed in the plugin files
