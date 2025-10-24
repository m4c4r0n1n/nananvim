# Language-Specific Setup

Detailed setup instructions for specific programming languages.

## Python

### Basic Setup

nananvim includes Pyright LSP out of the box. For the best experience:

```bash
# Install Python 3.10+
python3 --version

# Install pip
sudo pacman -S python-pip  # Arch
sudo apt install python3-pip  # Ubuntu
```

### Virtual Environments

Pyright automatically detects virtual environments. To use one:

```bash
# Create venv in your project
python3 -m venv .venv

# Activate it
source .venv/bin/activate

# Install packages
pip install your-packages

# Restart nvim - Pyright will detect the venv
```

### Additional Tools

For best experience, install these in your project:

```bash
pip install black isort  # Auto-installed by Mason, but useful locally
pip install pylint flake8  # Additional linting
```

## Rust

### Setup

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add rust-analyzer to LSP config
# Edit lua/plugins/lsp.lua and add "rust_analyzer" to ensure_installed
```

### Features

- Auto-complete with cargo metadata
- Inline type hints (toggle with `<leader>th`)
- Clippy lints
- Auto-formatting with rustfmt

### Project Setup

```bash
cargo new my-project
cd my-project
nvim src/main.rs  # LSP will auto-start
```

## JavaScript/TypeScript

### Setup

```bash
# Install Node.js 18+
node --version

# For project dependencies
npm install  # or yarn install
```

### Features Included

- TypeScript LSP (ts_ls)
- Prettier formatting
- Auto-imports
- JSDoc support

### React/Vue/Svelte

TypeScript LSP handles these out of the box. For better support:

```bash
# In your project
npm install -D @types/react @types/react-dom  # React
npm install -D @types/node  # Node types
```

## Go

### Setup

```bash
# Install Go
sudo pacman -S go  # Arch
# or download from golang.org

# Add gopls to LSP config
# Edit lua/plugins/lsp.lua:
# - Add "gopls" to ensure_installed
# - Add "gopls" to simple_servers
# - Add go = { "gofmt", "goimports" } to formatters
```

### Project Setup

```bash
go mod init myproject
nvim main.go  # LSP auto-starts
```

## C/C++

### Setup (Already Included!)

Clangd is pre-configured. For the best experience:

```bash
# Make sure clang is installed
clang --version

# For CMake projects
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
# This creates compile_commands.json for clangd
```

### Features

- Inlay hints for parameters and types
- Clang-tidy integration
- Header insertion
- Cross-references

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
# Install JDK 17+
sudo pacman -S jdk-openjdk  # Arch
sudo apt install openjdk-17-jdk  # Ubuntu

# Add jdtls to LSP config
# Edit lua/plugins/lsp.lua and add "jdtls"
```

### Maven/Gradle Projects

JDTLS auto-detects Maven and Gradle:

```bash
nvim src/main/java/Main.java  # LSP auto-starts
```

## Ruby

### Setup

```bash
# Install Ruby
rbenv install 3.2.0  # or rvm

# Add solargraph to LSP config
# Edit lua/plugins/lsp.lua and add "solargraph"

# Install solargraph gem
gem install solargraph
```

## PHP

### Setup

```bash
# Install PHP
sudo pacman -S php  # Arch
sudo apt install php  # Ubuntu

# Add intelephense to LSP config
# Edit lua/plugins/lsp.lua and add "intelephense"
```

### Composer Projects

```bash
composer install
nvim index.php  # LSP auto-starts
```

## HTML/CSS

### Setup (Already Included!)

HTML and CSS LSPs are pre-configured:
- `html` - HTML language server
- `cssls` - CSS language server
- `tailwindcss` - Tailwind CSS IntelliSense

### Emmet

For Emmet support, add this plugin to `lua/plugins/coding.lua`:

```lua
{
  "mattn/emmet-vim",
  event = "InsertEnter",
  ft = { "html", "css", "javascript", "javascriptreact", "typescriptreact" },
}
```

## JSON/YAML

### Setup (Already Included!)

JSON LSP is pre-configured. For YAML:

```bash
# Add yamlls to LSP config
# Edit lua/plugins/lsp.lua and add "yamlls"
```

### Schema Support

YAML LSP auto-detects schemas for:
- Kubernetes manifests
- GitHub Actions
- Docker Compose
- And more

## Lua (Neovim Config)

### Setup (Already Included!)

Perfect for editing your nvim config:
- Full Neovim API autocomplete
- Diagnostics for vim globals
- Documentation on hover

### Features

Press `K` over any vim/nvim function to see docs!

## Database (SQL)

### Setup

```bash
# Add sqlls to LSP config
# Edit lua/plugins/lsp.lua and add "sqlls"
```

For better SQL support, consider adding:

```lua
{
  "tpope/vim-dadbod",
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
    "kristijanhusak/vim-dadbod-completion",
  },
}
```

## Adding More Languages

1. Find the LSP server name: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
2. Add to `ensure_installed` in `lua/plugins/lsp.lua`
3. Add to `simple_servers` list
4. (Optional) Add formatter to `formatters_by_ft`
5. Restart nvim

That's it! Mason handles the rest.
