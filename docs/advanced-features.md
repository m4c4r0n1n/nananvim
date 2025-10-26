# Advanced Features

Power user features and tips for nananvim.

## DAP (Debugging)

nananvim includes full debugging support with nvim-dap, dap-ui, and virtual text display.

### Quick Start

1. **Set a breakpoint**: Place cursor on line and press `<leader>db`
2. **Start debugging**: Press `<leader>dc` to begin
3. **Step through code**: 
   - `<leader>di` - Step into function
   - `<leader>do` - Step over function
   - `<leader>dO` - Step out of function
4. **View variables**: Press `<leader>dh` to hover over variables
5. **Toggle UI**: Press `<leader>du` to open/close debug windows

### All DAP Keybindings

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue/start debugging |
| `<leader>di` | Step into function |
| `<leader>do` | Step over function |
| `<leader>dO` | Step out of function |
| `<leader>dr` | Open debug REPL |
| `<leader>dl` | Re-run last debug configuration |
| `<leader>dt` | Terminate debugging session |
| `<leader>du` | Toggle DAP UI windows |
| `<leader>dh` | Hover to show variable values |
| `<leader>dS` | Show scope variables |

### Language-Specific Setup

#### Python

Install debugpy in your environment:

```bash
# Global install
pip install debugpy

# Or in your project's venv
source .venv/bin/activate
pip install debugpy
```

The config automatically detects virtual environments.

**Debug a Python script:**
1. Open your Python file
2. Set breakpoints with `<leader>db`
3. Press `<leader>dc` to start
4. DAP UI will open automatically

#### C/C++/Rust

Debug adapter (codelldb) is auto-installed via Mason.

For better experience:
```bash
# Arch
sudo pacman -S lldb

# Ubuntu
sudo apt install lldb
```

**Debug a C/C++ program:**
1. Compile with debug symbols: `gcc -g main.c -o main`
2. Open the source file in nvim
3. Set breakpoints
4. Press `<leader>dc`
5. When prompted, enter the path to your executable

**For CMake projects:**
```bash
cmake -DCMAKE_BUILD_TYPE=Debug -B build
cmake --build build
```

#### JavaScript/TypeScript

Debug adapter (node2) is auto-installed via Mason.

**Debug Node.js:**
1. Open your JavaScript/TypeScript file
2. Set breakpoints
3. Press `<leader>dc`
4. Select "Launch" to run current file

**Debug with npm scripts:**
Edit `lua/plugins/dap.lua` and add:

```lua
{
  name = "npm start",
  type = "node2",
  request = "launch",
  runtimeExecutable = "npm",
  runtimeArgs = { "start" },
  cwd = vim.fn.getcwd(),
}
```

### Understanding the UI

When you start debugging, you'll see:

**Left sidebar (40 columns):**
- **Scopes**: Local and global variables
- **Breakpoints**: All set breakpoints
- **Stacks**: Call stack trace
- **Watches**: Expressions you're watching

**Bottom panel (10 lines):**
- **REPL**: Interactive debug console
- **Console**: Program output

**Main buffer:**
- Shows your code with a blue arrow (󰁕) at current execution line
- Breakpoints marked with red dot ()

### Virtual Text

Variable values appear inline as you step through code. Toggle this in `lua/plugins/dap.lua`:

```lua
require("nvim-dap-virtual-text").setup({
  enabled = true,  -- Set to false to disable
})
```

### Conditional Breakpoints

Set a conditional breakpoint:
1. Move cursor to line
2. Run: `:lua require('dap').set_breakpoint(vim.fn.input('Condition: '))`
3. Or create a keymap in `lua/config/keymaps.lua`:

```lua
keymap("n", "<leader>dB", function()
  require('dap').set_breakpoint(vim.fn.input('Condition: '))
end, { desc = "Conditional Breakpoint" })
```

### Log Points

Add a log point instead of stopping:

```lua
keymap("n", "<leader>dL", function()
  require('dap').set_breakpoint(nil, nil, vim.fn.input('Log message: '))
end, { desc = "Log Point" })
```

### REPL Commands

When in debug REPL (`<leader>dr`):
- `.exit` - Close REPL
- `.c` - Continue
- `.n` - Next
- Evaluate any expression by just typing it

### Adding More Languages

To add support for other languages, edit `lua/plugins/dap.lua`.

**Example - Go (delve):**

1. Install delve: `go install github.com/go-delve/delve/cmd/dlv@latest`

2. Add to `lua/plugins/dap.lua`:

```lua
-- After other adapters
dap.adapters.go = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = {'dap', '-l', '127.0.0.1:${port}'},
  }
}

dap.configurations.go = {
  {
    type = 'go',
    name = 'Debug',
    request = 'launch',
    program = '${file}'
  },
}
```

### Troubleshooting DAP

**Adapter not found:**
- Check `:Mason` to ensure debug adapter is installed
- Run `:checkhealth dap`

**Breakpoints not hitting:**
- Make sure you compiled with debug symbols (`-g` flag)
- Check that the file path matches the source

**UI not opening:**
- Press `<leader>du` to manually toggle
- Check `:messages` for errors

**Python venv not detected:**
- Activate your venv before starting nvim
- Or set `VIRTUAL_ENV` environment variable

## Telescope Advanced Usage

### Live Grep with Filters

Search only in specific file types:

```vim
:Telescope live_grep
" Then type your search and add glob patterns:
" search term -- *.lua *.md
```

### Find in Current Buffer

```vim
:Telescope current_buffer_fuzzy_find
```

### Search Command History

```vim
<leader>:
```

### Custom Searches

Add to `lua/config/keymaps.lua`:

```lua
keymap("n", "<leader>fc", function()
  require("telescope.builtin").find_files({
    cwd = "~/.config/nvim",
    prompt_title = "Nvim Config Files",
  })
end, { desc = "Find config files" })
```

## Treesitter Text Objects

### Selection

Use these in visual mode:

- `<C-space>` - Incrementally select node
- `<BS>` - Decrease selection

### Navigation

Jump between functions, classes, etc:

```lua
-- Add to lua/plugins/treesitter.lua
textobjects = {
  select = {
    enable = true,
    lookahead = true,
    keymaps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
    },
  },
},
```

Then use `vif` to select inside function, `vac` for class, etc.

## LSP Advanced Features

### Inlay Hints

Toggle type hints inline:

```vim
<leader>th
```

### Code Actions

Quick fixes and refactorings:

```vim
<leader>ca  " Show available code actions
```

Common actions:
- Auto-import missing symbols
- Add missing methods
- Extract to function
- Inline variable

### Workspace Symbols

Search for symbols across your entire project:

```vim
:Telescope lsp_workspace_symbols
```

### Document Symbols

Search for symbols in current file:

```vim
:Telescope lsp_document_symbols
```

## Snippets

### Using Snippets

Snippets are provided by LuaSnip:

1. Start typing a snippet trigger
2. Suggestions appear in completion menu
3. Press `<CR>` to expand
4. Use `<Tab>` to jump between placeholders

### Adding Custom Snippets

Create `lua/config/snippets.lua`:

```lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("lua", {
  s("req", {
    t('local '),
    i(1, "module"),
    t(' = require("'),
    i(2, "module"),
    t('")'),
  }),
})

-- More languages:
ls.add_snippets("python", {
  s("ifmain", {
    t({'if __name__ == "__main__":', '    '}),
    i(1, "main()"),
  }),
})
```

Then require it in `lua/config/init.lua`:

```lua
require("config.snippets")
```

## Macros and Registers

### Recording Macros

1. Press `q` + letter to start recording (e.g., `qa` records to register `a`)
2. Perform your actions
3. Press `q` to stop
4. Replay with `@a`, repeat last macro with `@@`

### Named Registers

Copy to specific register:

```vim
"ayy  " Yank line to register 'a'
"ap   " Paste from register 'a'
```

View all registers:

```vim
:registers
```

### System Clipboard

nananvim uses system clipboard by default (`clipboard=unnamedplus`).

To use a specific register:

```vim
"+y  " Yank to system clipboard (explicit)
"*y  " Yank to selection clipboard (X11)
```

## Sessions

### Auto-Save Sessions

Add to `lua/plugins/editor.lua`:

```lua
{
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
  },
}
```

### Manual Sessions

```vim
:mksession ~/my-session.vim
:source ~/my-session.vim
```

## Terminal Integration

### Multiple Terminals

```vim
:ToggleTerm  " Opens terminal 1
:2ToggleTerm " Opens terminal 2
```

### Send Commands to Terminal

Add to `lua/config/keymaps.lua`:

```lua
-- Send current line to terminal
keymap("n", "<leader>tl", ":ToggleTermSendCurrentLine<CR>")

-- Send visual selection
keymap("v", "<leader>ts", ":ToggleTermSendVisualSelection<CR>")
```

### Lazygit Integration

Add to `lua/plugins/git.lua`:

```lua
{
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
}
```

## Diff View

### Built-in Diffing

```vim
:windo diffthis  " Diff all windows
:diffoff         " Turn off diff
```

### Git Diff

Using gitsigns:

```vim
<leader>hd  " Diff current file
<leader>hp  " Preview hunk
```

## Marks

### Local Marks

- `ma` - Set mark 'a' in current file
- `'a` - Jump to mark 'a'
- `` `a`` - Jump to exact position of mark 'a'

### Global Marks

- `mA` - Set global mark 'A' (works across files)
- `'A` - Jump to file and line of mark 'A'

View all marks:

```vim
:marks
```

## Custom Commands

The `TokenCount` command is included. Add more in `lua/config/commands.lua`:

```lua
-- Count words
vim.api.nvim_create_user_command("WordCount", function()
  local words = vim.fn.wordcount().words
  print("Words: " .. words)
end, {})

-- Open config directory
vim.api.nvim_create_user_command("EditConfig", function()
  vim.cmd("cd ~/.config/nvim")
  vim.cmd("Telescope find_files")
end, {})

-- Format and save
vim.api.nvim_create_user_command("FormatAndSave", function()
  vim.lsp.buf.format()
  vim.cmd("write")
end, {})
```

## Performance Tuning

### Disable Features for Large Files

Bigfile detection is enabled, but you can customize it in `lua/plugins/ui.lua`:

```lua
bigfile = {
  enabled = true,
  size = 1024 * 1024, -- 1MB
  features = {
    "treesitter",
    "lsp",
    "syntax",
  },
},
```

### Lazy Loading

Most plugins are lazy-loaded. To make a plugin load faster:

```lua
{
  "plugin-name",
  lazy = false,  -- Load on startup
  priority = 1000,  -- Load before other plugins
}
```

### Profile Startup Time

```vim
:Lazy profile
```

## Advanced Git

### Interactive Rebase

```vim
:!git rebase -i HEAD~3
```

### Git Blame (Line-by-Line)

```vim
<leader>hb  " Blame current line
```

### Diff Against Branch

```vim
:!git diff main..HEAD
```

## Need More?

Check out:
- `:h nvim` - Neovim docs
- `:Lazy` - Plugin manager UI
- `:Mason` - LSP/tool installer UI
- `:checkhealth` - Diagnostic info
- `:checkhealth dap` - DAP-specific diagnostics
