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
| `<leader>dL` | Launch the Lua debug server (osv, run in the debuggee) |
| `<leader>dt` | Terminate debugging session |
| `<leader>du` | Toggle DAP UI windows |
| `<leader>dh` | Hover to show variable values |
| `<leader>dS` | Show scope variables |

### Language-Specific Setup

#### Python

debugpy is auto-installed via Mason into its own venv, so there is nothing to `pip install`. Your program still runs on your project interpreter: the active `$VIRTUAL_ENV`, else `python3` on your PATH.

**Debug a Python script:**
1. Open your Python file
2. Set breakpoints with `<leader>db`
3. Press `<leader>dc` to start
4. DAP UI will open automatically

#### C/C++/Rust

Debug adapter (codelldb) is auto-installed via Mason. No system lldb needed.

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

Debug adapter (`js-debug-adapter` / vscode-js-debug, type `pwa-node`) is auto-installed via Mason. Needs `node` on your PATH.

**Debug Node.js:**
1. Open your JavaScript/TypeScript file
2. Set breakpoints
3. Press `<leader>dc`
4. Select "Launch" to run current file

**Debug with npm scripts:**
Add a `.vscode/launch.json` to the project (nvim-dap reads it automatically), or edit `lua/plugins/dap.lua` and add this to the JS/TS configurations:

```lua
{
  name = "npm start",
  type = "pwa-node",
  request = "launch",
  runtimeExecutable = "npm",
  runtimeArgs = { "start" },
  cwd = vim.fn.getcwd(),
}
```

#### Lua (Neovim config/plugins)

Uses `osv` (one-small-step-for-vimkind), a pure-Lua plugin with nothing to install. It debugs Lua that runs *inside* Neovim (config, plugins, anything touching the `vim` API), which makes it a **two-instance** workflow, the same as debugging Neovim Lua in any editor:

1. In the Neovim running the code you want to debug (the **debuggee**), press `<leader>dL`. This starts the debug server (`osv.launch` on port 8086); you'll see "Server started on port 8086".
2. In a **second** Neovim with the source file open (the **client**/editor), set a breakpoint with `<leader>db`, then press `<leader>dc` to attach.
3. Trigger the code in the debuggee (run the plugin command, or `:source %`). Execution stops at your breakpoint and you step through from the client.

Why two instances? osv installs a debug hook in the debuggee and freezes it when a breakpoint hits, exactly what a debugger should do. The client that drives stepping has to be a *separate* live instance, otherwise the one instance freezes itself with nothing left to continue it. This is inherent to in-process Lua debugging, not specific to nananvim. For standalone `.lua`/LuaJIT scripts run outside Neovim, osv doesn't apply.

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

Add a log point instead of stopping (`<leader>dL` is already taken by the Lua
debug-server launch, so this example uses `<leader>dP`):

```lua
keymap("n", "<leader>dP", function()
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

## Picker Advanced Usage (snacks.picker)

Searching is powered by [snacks.nvim](https://github.com/folke/snacks.nvim)'s picker.

### Live Grep

```vim
<leader>fg
```

Or scope a grep to open buffers only:

```lua
:lua Snacks.picker.grep_buffers()
```

### Find in Current Buffer

Fuzzy-find lines in the buffer you're editing:

```lua
:lua Snacks.picker.lines()
```

### Search Command History

```vim
<leader>:
```

### Built-in Pickers

| Key | Picker |
|-----|--------|
| `<leader>f` | Files (cwd) |
| `<leader>fg` | Live grep |
| `<leader>fw` | Grep word under cursor (or selection) |
| `<leader>fc` | Config files |
| `<leader>fk` | Keymaps |
| `<leader>fp` | Projects |
| `<leader>sb` | Lines in buffer |
| `<leader>sd` | Diagnostics |
| `<leader>su` | Undo history |
| `<leader>st` | TODO comments |
| `<leader>gs` | Git status |

### Custom Searches

Add to `lua/config/keymaps.lua`:

```lua
keymap("n", "<leader>fn", function()
  Snacks.picker.files({ cwd = "~/notes", title = "Notes" })
end, { desc = "Find notes" })
```

## Search and Replace (grug-far)

`<leader>sr` opens grug-far: a live, project-wide search and replace buffer with a preview of every change. It prefills the file filter with the current file type. In visual mode it searches for the selection.

## Flash (Jump Anywhere)

- `s` then 1-2 characters: labels appear on every match on screen, press the label to jump
- `S`: select a treesitter node (function, block, argument) by label
- `r` in operator mode: act on a remote spot, for example `yr` + jump + `iw` yanks a word without moving
- `<C-s>` in a `/` search: toggle flash labels for the search

`f`, `F`, `t` and `T` stay native.

## Treesitter Text Objects

### Selection

Incremental selection is built in to Neovim 0.12 (`an` / `in` in visual mode). nananvim maps it to:

- `<C-space>` - Start selection (normal), expand to the parent node (visual)
- `<BS>` - Shrink selection (visual)

### Text Objects (Already Included!)

| Key | Selects |
|-----|---------|
| `af` / `if` | Around / inside function |
| `ac` / `ic` | Around / inside class |
| `aa` / `ia` | Around / inside argument |
| `ih` | Inside git hunk |

Use them with any operator: `vif` selects inside a function, `daa` deletes an argument, `yac` yanks a class.

### Navigation (Already Included!)

| Key | Jumps to |
|-----|----------|
| `]f` / `[f` | Next / previous function start |
| `]F` / `[F` | Next / previous function end |
| `]c` / `[c` | Next / previous class start (in diff mode: next / previous change) |
| `]a` / `[a` | Next / previous argument |
| `[x` | Top of the current context (the line pinned at the top of the window) |
| `]]` / `[[` | Next / previous reference of the word under the cursor |

## LSP Advanced Features

### Inlay Hints

Toggle type hints inline (`<leader>th` is the theme switcher):

```vim
<leader>ih
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

### LSP Pickers

`gd`, `gr`, `gi`, `gy` and `gD` open in the snacks picker with a preview, so a symbol with many references is easy to filter. `<leader>xl` shows definitions and references in a Trouble side panel instead.

### Rename a File

`<leader>cR` renames the current file and tells the LSP servers, so imports in other files update. Renaming or moving a file in neo-tree does the same.

### Workspace Symbols

Search for symbols across your entire project: `<leader>sS`

### Document Symbols

Search for symbols in current file: `<leader>ss` (or `<leader>xs` for a Trouble outline)

## Snippets

### Using Snippets

blink.cmp expands snippets with Neovim's built-in `vim.snippet`. friendly-snippets supplies snippets for most languages.

1. Start typing a snippet trigger
2. Suggestions appear in completion menu
3. Select it and press `<CR>` to expand
4. Use `<Tab>` / `<S-Tab>` to jump between placeholders

### Adding Custom Snippets

Put VS Code style JSON files in `~/.config/nvim/snippets/`, one per filetype (`all.json` applies everywhere). blink.cmp reads them automatically.

`~/.config/nvim/snippets/lua.json`:

```json
{
  "require": {
    "prefix": "req",
    "body": ["local ${1:module} = require(\"${2:$1}\")"],
    "description": "Require a module"
  }
}
```

`~/.config/nvim/snippets/python.json`:

```json
{
  "if main": {
    "prefix": "ifmain",
    "body": ["if __name__ == \"__main__\":", "    ${1:main()}"]
  }
}
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

## Sessions (Already Included!)

persistence.nvim saves the open files, splits and cursor positions for each folder when you quit.

| Key | Action |
|-----|--------|
| `s` (dashboard) | Restore this folder's session |
| `<leader>Ss` | Restore this folder's session |
| `<leader>Sl` | Restore the last session (any folder) |
| `<leader>SS` | Pick a session |
| `<leader>Sd` | Don't save the session this time |

### Manual Sessions

```vim
:mksession ~/my-session.vim
:source ~/my-session.vim
```

## Terminal Integration

Two terminals are built in:

- `<C-\>`: quick floating terminal (snacks.terminal), toggles from normal or terminal mode
- `<leader>tt`: the nanabrowser panel terminal (lives in the Browser │ Terminal │ TODO workspace, `<leader>p`)

Press `<Esc><Esc>` to leave terminal mode. One `<Esc>` still goes to the program (useful for shells in vi mode).

### Multiple Terminals

snacks.terminal keys instances by command and cwd, so different invocations get their own terminal:

```lua
:lua Snacks.terminal.toggle()          -- default shell
:lua Snacks.terminal.toggle("btop")    -- separate instance running btop
```

### Lazygit Integration (Already Included!)

| Key | Action |
|-----|--------|
| `<leader>gg` | Lazygit (floating, uses your colorscheme) |
| `<leader>gl` | Lazygit log for the current file |
| `<leader>gB` | Open the file/selection on GitHub (or GitLab, etc.) |

Needs the `lazygit` binary (the installer adds it).

## Edit Files Like Text (oil.nvim)

Press `-` to open the current file's folder as a buffer. Rename a file by editing its name, delete with `dd`, move by cutting and pasting into another folder, create with a new line (end it with `/` for a folder). `:w` applies it all. `-` goes up a folder, `q` closes. neo-tree stays the sidebar.

## Harpoon (Your Most-Used Files)

| Key | Action |
|-----|--------|
| `<leader>H` | Mark the current file |
| `<leader>j` | Show the marked files (reorder or delete lines to edit the list) |
| `<leader>1`-`<leader>5` | Jump to marked file 1 to 5 |

## Multiple Cursors

| Key | Action |
|-----|--------|
| `<C-n>` | Add a cursor at the next match of the word (or selection) |
| `<C-p>` | Skip this match |
| `<leader>M` | Add cursors at every match |
| `<C-q>` | Add or remove a cursor right here |
| `<Left>` / `<Right>` | Move between cursors (while there are several) |
| `<leader>X` | Delete the current cursor |
| `<Esc>` | Back to one cursor |

Then edit normally: `ciw`, `A`, `dd`, anything, and it happens at every cursor.

## Testing (neotest)

| Key | Action |
|-----|--------|
| `<leader>Tr` | Run the nearest test |
| `<leader>Tt` | Run the tests in this file |
| `<leader>TT` | Run all tests |
| `<leader>Tl` | Run the last test again |
| `<leader>Td` | Debug the nearest test (DAP) |
| `<leader>Tw` | Watch the file: rerun on save |
| `<leader>Ts` | Summary tree |
| `<leader>To` / `<leader>TO` | Output of the test / output panel |
| `]T` / `[T` | Next / previous failed test |

Pass/fail shows as signs and virtual text next to each test. Adapters for pytest, vitest and jest are included. Turn the whole thing off with `extras = { test = false }` in `local.lua`.

## Scratch Buffers

`<leader>.` opens a floating scratch buffer for the current file type, and it's saved for next time. `<leader>s.` picks between your scratch buffers. Good for notes and trying out code.

## Diff View

### Built-in Diffing

```vim
:windo diffthis  " Diff all windows
:diffoff         " Turn off diff
```

### diffview

| Key | Action |
|-----|--------|
| `<leader>gd` | All changes side by side (and a 3-way merge view during a conflict) |
| `<leader>gh` | History of the current file |
| `<leader>gH` | History of the branch |
| `q` | Close the diff view |

### Git Diff

Using gitsigns:

```vim
<leader>hd  " Diff current file against the index
<leader>hD  " Diff current file against the last commit
<leader>hp  " Preview hunk inline
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

Built-in commands:

- `:TokenCount [model]`: exact Claude token count for the buffer or a visual selection (uses the free Anthropic `count_tokens` endpoint when `ANTHROPIC_API_KEY` is set, default model `claude-opus-5-5`). Without a key it falls back to a rough tiktoken estimate and says so.
- `:FormatToggle` / `:FormatToggle!`: format on save on or off, globally or for the current buffer.

Add more in `lua/config/commands.lua`:

```lua
-- Count words
vim.api.nvim_create_user_command("WordCount", function()
  local words = vim.fn.wordcount().words
  print("Words: " .. words)
end, {})

-- Open config directory
vim.api.nvim_create_user_command("EditConfig", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, {})

-- Format with conform, even when format on save is off
vim.api.nvim_create_user_command("FormatAndSave", function()
  require("conform").format({ lsp_format = "fallback" })
  vim.cmd("write")
end, {})
```

## Performance Tuning

### Disable Features for Large Files

Bigfile detection is enabled. Customize the size limit in `lua/plugins/ui.lua`:

```lua
bigfile = {
  enabled = true,
  size = 1024 * 1024, -- 1MB
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

### Git Blame

```vim
<leader>hb  " Blame current line (full commit message)
<leader>hB  " Blame the whole buffer in a side window
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
