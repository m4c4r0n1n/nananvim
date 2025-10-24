# Advanced Features

Power user features and tips for nananvim.

## GitHub Copilot

### Setup

```bash
# Authenticate (first time only)
:Copilot auth
```

Follow the browser prompt to authenticate with GitHub.

### Usage

Copilot suggestions appear automatically as you type (ghost text).

**Keybindings:**
- `<C-y>` - Accept suggestion
- `<M-]>` - Next suggestion
- `<M-[>` - Previous suggestion
- `<C-]>` - Dismiss suggestion

### Copilot Chat

Open an AI chat interface:

```vim
:CopilotChat
```

Ask questions about your code, get refactoring suggestions, explanations, etc.

### Tips

- Write a comment describing what you want, Copilot will suggest the implementation
- Copilot learns from your project context
- Works best with descriptive function/variable names

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

## DAP (Debugging)

Not included by default, but here's how to add it:

```lua
-- Add to lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      dapui.setup()
      require("nvim-dap-virtual-text").setup()
      
      -- Auto-open UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
    end,
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
    },
  },
}
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
