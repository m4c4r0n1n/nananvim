# Language-Specific Setup

Detailed setup instructions for specific programming languages.

**How adding a language works (every section below follows this):**

1. Add the server name to the `servers` list at the top of `lua/plugins/lsp.lua`
2. (Optional) Add a formatter to `formatters_by_ft` in the same file
3. Restart nvim. Mason installs it, `vim.lsp.enable()` starts it, the treesitter parser installs itself the first time you open a file of that type

## Python

### Basic Setup (Already Included!)

nananvim ships two Python servers that work together:

- **basedpyright**: types, go to definition, hover, inlay hints (a faster, maintained fork of Pyright, set to the same "standard" checks)
- **ruff**: lint diagnostics and quick fixes, plus formatting on save (`ruff format` + import sorting, a drop-in for black + isort)

```bash
# Install Python 3.10+
python3 --version

# Install pip and venv
sudo pacman -S python-pip  # Arch
sudo apt install python3-pip python3-venv  # Ubuntu
```

### Virtual Environments

basedpyright detects a `.venv` / `venv` in the project root, or the active `$VIRTUAL_ENV`:

```bash
# Create venv in your project
python3 -m venv .venv

# Activate it
source .venv/bin/activate

# Install packages
pip install your-packages

# Start nvim from the activated shell
```

### Stricter Type Checking

Want more warnings? In `lua/plugins/lsp.lua`, change `typeCheckingMode = "standard"` to `"recommended"` (or `"strict"`).

### Ruff Settings

Ruff reads `pyproject.toml` / `ruff.toml` in your project, so line length, rules and import style follow the project, not the editor.

## Rust

### Setup

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Then add `"rust_analyzer"` to `servers` in `lua/plugins/lsp.lua`, and `rust = { "rustfmt" }` to `formatters_by_ft`.

### Features

- Auto-complete with cargo metadata
- Inline type hints (toggle with `<leader>ih`)
- Clippy lints
- Auto-formatting with rustfmt
- Debugging with codelldb (already installed, `<leader>dc`)

### Project Setup

```bash
cargo new my-project
cd my-project
nvim src/main.rs  # LSP will auto-start
```

## JavaScript/TypeScript

### Setup (Already Included!)

```bash
# Install Node.js 20+
node --version

# For project dependencies
npm install  # or pnpm install / yarn install
```

### Features Included

- TypeScript LSP (vtsls: the VS Code TypeScript engine, with move-to-file refactors and import updates when you move files)
- ESLint (diagnostics and fixes, starts only in projects with an ESLint config)
- Prettier formatting (prettierd when available) for JS, TS, JSX, TSX, Vue, Svelte, JSON, YAML, Markdown, HTML, CSS
- Auto-imports
- JSDoc highlighting
- Debugging with js-debug-adapter (`<leader>dc`)
- Tests with neotest (vitest and jest are detected automatically, `<leader>Tr` runs the nearest test)

### React/Vue/Svelte

vtsls handles JSX/TSX out of the box, and HTML/JSX tags close and rename themselves (nvim-ts-autotag). For better support:

```bash
# In your project
npm install -D @types/react @types/react-dom  # React
npm install -D @types/node  # Node types
```

Vue (`vue_ls`), Svelte (`svelte`) and Astro (`astro`) servers are included. In `.vue` files, vtsls reads the script part, so types work in the template too. `.mdx` files get markdown highlighting.

## Go

### Setup

```bash
# Install Go
sudo pacman -S go  # Arch
# or download from go.dev
```

Then in `lua/plugins/lsp.lua`:

- Add `"gopls"` to `servers`
- Add `go = { "goimports", "gofmt" }` to `formatters_by_ft`
- Add `"goimports"` to the mason-tool-installer `tools` list

### Project Setup

```bash
go mod init myproject
nvim main.go  # LSP auto-starts
```

## C/C++

### Setup (Already Included!)

clangd is pre-configured. For the best experience:

```bash
# Make sure clang is installed
clang --version

# For CMake projects
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
# This creates compile_commands.json for clangd
```

### Features

- Inlay hints for parameters and types
- clang-tidy integration
- Header insertion
- Cross-references
- Debugging with codelldb

### Include Paths

If clangd can't find headers, create `.clangd` in project root:

```yaml
CompileFlags:
  Add:
    - -I/path/to/includes
    - -std=c++20
```

## Java

### Setup

```bash
# Install JDK 21+
sudo pacman -S jdk-openjdk  # Arch
sudo apt install openjdk-21-jdk  # Ubuntu
```

Then add `"jdtls"` to `servers` in `lua/plugins/lsp.lua`.

### Maven/Gradle Projects

jdtls auto-detects Maven and Gradle:

```bash
nvim src/main/java/Main.java  # LSP auto-starts
```

## Ruby

### Setup

```bash
# Install Ruby
rbenv install 3.4.0  # or mise / rvm
```

Then add `"ruby_lsp"` to `servers` in `lua/plugins/lsp.lua`.

## PHP

### Setup

```bash
# Install PHP
sudo pacman -S php  # Arch
sudo apt install php  # Ubuntu
```

Then add `"intelephense"` to `servers` in `lua/plugins/lsp.lua`.

### Composer Projects

```bash
composer install
nvim index.php  # LSP auto-starts
```

## HTML/CSS

### Setup (Already Included!)

HTML and CSS LSPs are pre-configured:
- `html` - HTML language server (also renames the closing tag when you edit the opening tag)
- `cssls` - CSS language server
- `tailwindcss` - Tailwind CSS IntelliSense

### Emmet (Already Included!)

emmet-vim loads for HTML, CSS, SCSS, Less, JS/TS, JSX/TSX, Vue, Svelte and Astro. Type an abbreviation, then press `<C-z>,`.

## JSON/YAML

### Setup (Already Included!)

`jsonls` and `yamlls` are pre-configured with SchemaStore.nvim, so you get validation and completion for hundreds of file types without setup:
- package.json, tsconfig.json, .eslintrc
- GitHub Actions workflows
- Docker Compose
- Kubernetes manifests
- And more

yamllint also runs on YAML files through nvim-lint.

## Shell (bash/sh)

### Setup (Already Included!)

- `bashls` - completion, hover and go to definition
- `shellcheck` - lint diagnostics (through nvim-lint)
- `shfmt` - formatting on save
- `bash-debug-adapter` - debugging (`<leader>dc`)

## Markdown

### Setup (Already Included!)

- `marksman` - links, headings, references across notes
- `markdownlint` - lint diagnostics (through nvim-lint)
- prettier - formatting on save
- Wrap and spell check turn on automatically for Markdown files

## Lua (Neovim Config)

### Setup (Already Included!)

Perfect for editing your nvim config:
- Full Neovim API autocomplete through lazydev.nvim (loads only the library types you use, so lua_ls stays fast)
- Completion for `Snacks` and `vim.uv`
- Documentation on hover
- stylua formatting on save

### Features

Press `K` over any vim/nvim function to see docs!

## Database (SQL)

### Setup

Add `"sqlls"` to `servers` in `lua/plugins/lsp.lua`.

For better SQL support, consider adding:

```lua
{
  "tpope/vim-dadbod",
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
  },
  cmd = { "DBUI" },
}
```

## Adding More Languages

1. Find the LSP server name: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
2. Add it to `servers` in `lua/plugins/lsp.lua`
3. (Optional) Add settings with `vim.lsp.config("<name>", { ... })` in the same file
4. (Optional) Add a formatter to `formatters_by_ft`
5. Restart nvim

That's it! Mason handles the rest.
