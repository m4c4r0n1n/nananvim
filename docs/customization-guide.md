# Customization Guide

How to make nananvim your own.

## Changing the Colorscheme

### Using the Theme Switcher (Easiest Way)

nananvim includes a theme switcher that lets you browse and preview all installed colorschemes:

1. Press `<leader>th` to open the theme picker
2. Use `j`/`k` or arrow keys to navigate
3. Themes preview automatically as you navigate
4. Press `<Space>` or `<Enter>` to apply a theme
5. Use `/` to search for specific themes
6. Press `<leader>tb` to toggle between Blackout and the theme's own background

**Built-in themes you can try:**
- Rose Pine (Moon/Main/Dawn variants)
- And any other colorschemes you've installed

The theme switcher remembers your choice across sessions!

### Adding New Themes Not in the Switcher

Some themes aren't installed by default, but you can add them yourself:

**Option 1: Quick Add (Install theme, let switcher handle it)**

Create a new file in `lua/plugins/` for your theme. The theme switcher will automatically detect it:

**Example - Add Gruvbox:**

Create `lua/plugins/gruvbox.lua`:
```lua
return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_mode = true,
    },
  },
}
```

**Example - Add Catppuccin:**

Create `lua/plugins/catppuccin.lua`:
```lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = true,
    },
  },
}
```

**Example - Add Tokyo Night:**

Create `lua/plugins/tokyonight.lua`:
```lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- storm, moon, night, day
      transparent = true,
    },
  },
}
```

Restart nvim, then press `<leader>th` - your new theme will appear in the list!

**Option 2: Set as Default Theme (Replace Rose Pine)**

If you want to completely replace Rose Pine and set a different theme as default:

1. Edit `lua/plugins/colorscheme.lua`
2. Replace the Rose Pine config with your preferred theme
3. Add `vim.cmd.colorscheme("your-theme-name")` to auto-apply it

Example replacing with Gruvbox:
```lua
return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
```

**Quick theme switching tip:** You can also use `:colorscheme <Tab>` (with a space before `<Tab>`) to cycle through installed themes temporarily.

## Adding Language Servers

To add support for more languages:

1. Edit `lua/plugins/lsp.lua`
2. Add the server's lspconfig name to the `servers` list at the top of the file:

```lua
local servers = {
  "lua_ls",
  "basedpyright",
  "ruff",
  -- ...
  -- Add your servers here:
  "rust_analyzer", -- Rust
  "gopls", -- Go
  "jdtls", -- Java
  "omnisharp", -- C#
}
```

3. Restart nvim. Mason installs each server, and `vim.lsp.enable()` turns them all on. Nothing else to register.

4. Need custom settings? Add a `vim.lsp.config()` call next to the others in the same file:

```lua
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = { check = { command = "clippy" } },
  },
})
```

Every server already gets blink.cmp's completion capabilities through `vim.lsp.config("*", ...)`, so you never pass `capabilities` yourself.

### Popular Language Servers:

- **Rust:** `rust_analyzer`
- **Go:** `gopls`
- **Java:** `jdtls`
- **C#:** `omnisharp`
- **Ruby:** `ruby_lsp`
- **PHP:** `intelephense`
- **Kotlin:** `kotlin_language_server`
- **Zig:** `zls`

### More Treesitter Parsers

Parsers install on demand the first time you open a file of that type. To pre-install some, add a spec anywhere in `lua/plugins/` (the list merges with the built-in one):

```lua
return {
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "rust", "go" } } },
}
```

## Adding Formatters

To add formatters for auto-format on save:

1. Edit `lua/plugins/lsp.lua`
2. Find the `formatters_by_ft` section in conform.nvim
3. Add your formatter:

```lua
formatters_by_ft = {
  lua = { "stylua" },
  python = { "ruff_organize_imports", "ruff_format" },
  -- Add yours:
  rust = { "rustfmt" },
  go = { "goimports", "gofmt" },
  ruby = { "rubocop" },
},
```

4. Add the formatter to the mason-tool-installer list in the same file:

```lua
local tools = {
  "stylua",
  "prettierd",
  "prettier",
  "shfmt",
  "clang-format",
  "goimports", -- Add yours
}
```

Format on save is on by default. Turn it off with `<leader>uf` or `:FormatToggle` (add `!` to change only the current buffer).

## Changing Keybindings

### Global Keymaps

Edit `lua/config/keymaps.lua`:

```lua
-- Example: bind the file finder somewhere else
keymap("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })

-- Add your own:
keymap("n", "<leader>cm", "<cmd>make<cr>", { desc = "Run make" })
```

### Plugin-Specific Keymaps

Most plugins define their keymaps in their respective files in `lua/plugins/`.

**Example - Change the Windsurf (Codeium) accept key:**

Edit `lua/plugins/coding.lua`, find the Windsurf section:

```lua
vim.keymap.set("i", "<Tab>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true, replace_keycodes = false, desc = "Accept AI suggestion" })
```

Change `"<Tab>"` to whatever key you prefer, for example `"<C-g>"`.

**Example - Customize Avante keybindings:**

Edit `lua/plugins/coding.lua`, find the Avante keys section:

```lua
keys = {
  { "<leader>aa", ..., desc = "Avante: Ask" },
  -- Change to your preferred keys
  { "<leader>ai", ..., desc = "Avante: Ask" },  -- Changed from 'aa' to 'ai'
},
```

## Disabling Plugins

Don't want a plugin? Just delete its file or set `enabled = false`:

**Option 1: Delete the file**
```bash
rm ~/.config/nvim/lua/plugins/git.lua  # Removes gitsigns
```

**Option 2: Disable in the plugin spec**

Edit the plugin file and add `enabled = false`:

```lua
return {
  {
    "folke/trouble.nvim",
    enabled = false,  -- Add this line
    cmd = "Trouble",
    -- rest of config...
  },
}
```

**Disable a feature layer:**

Completion UI, linting and DAP each have a flag in `lua/config/extras.lua`. Set one to `false` and that layer is gone.

**Disable Windsurf (Codeium):**

Edit `lua/plugins/coding.lua` and set `enabled = false` on the windsurf spec:

```lua
{
  "Exafunction/windsurf.vim",
  enabled = false, -- Disables Windsurf
  ...
}
```

**Disable Avante and Windsurf (all AI):**

Both are gated behind `lua/config/local.lua`. Delete that file and no AI plugin loads at all. To keep Windsurf but drop Avante, keep `local.lua` as `return {}` and set `enabled = false` on the avante spec in `lua/plugins/coding.lua`.

## Adding New Plugins

1. Create a new file in `lua/plugins/` or add to an existing one:

```bash
nvim ~/.config/nvim/lua/plugins/myplugins.lua
```

2. Add your plugin:

```lua
return {
  {
    "plugin-author/plugin-name",
    event = "VeryLazy",  -- When to load
    config = function()
      require("plugin-name").setup({
        -- config here
      })
    end,
  },
}
```

3. Restart nvim - Lazy will auto-install it

### Popular Plugins to Add:

**LazyGit** is already built in (`<leader>gg`, through snacks.nvim). You only need the `lazygit` binary, which the installer adds.

**Harpoon (Quick file navigation):**
```lua
{
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon"):setup()
  end,
}
```

**Noice.nvim (Better UI):**
```lua
{
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {},
}
```

## Customizing Options

Edit `lua/config/options.lua` to change vim options:

```lua
-- Change tab width
opt.tabstop = 4
opt.shiftwidth = 4

-- Enable line wrap
opt.wrap = true

-- Change scroll offset
opt.scrolloff = 12

-- Enable spell check
opt.spell = true
```

## Customizing AI Features

### Customizing Windsurf (Codeium)

Edit `lua/plugins/coding.lua` to customize Windsurf behavior:

```lua
-- Change keybindings
vim.keymap.set("i", "<C-g>", function() -- Changed from Tab
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true, replace_keycodes = false })

-- Disable Windsurf for certain filetypes
vim.g.codeium_filetypes = {
  markdown = false,
  text = false,
}
```

### Customizing Avante (AI Chat)

Create or edit `~/.config/nvim/lua/config/local.lua`:

```lua
return {
  avante = {
    provider = "claude",  -- or "openai" for Groq
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-5-5", -- or "claude-opus-5-5" for harder tasks
        extra_request_body = {
          -- don't set temperature: Sonnet 5.5 rejects non-default sampling params
          max_tokens = 32000, -- Increase for longer responses
        },
      },
    },
    behaviour = {
      auto_suggestions = false,
      auto_apply_diff_after_generation = true,  -- Auto-apply code changes
    },
    windows = {
      width = 40,  -- Wider sidebar
      position = "right",  -- or "left"
    },
  },
}
```

## Customizing Appearance

### Change Dashboard ASCII Art

Create `~/.config/nvim/lua/config/dashboard.lua`:

```lua
return {
  header = [[
    Your custom ASCII art here
    Line by line
  ]],
}
```

Or edit `lua/plugins/ui.lua` directly and replace the header.

### Background Mode (Blackout / Theme / Transparent)

theme-switcher.nvim owns the background. Blackout (pure black) is the default.

- `<leader>tb` toggles Blackout and the theme's own background
- Transparent (your terminal shows through): `:lua require("theme-switcher").set_background("terminal")`
- Change the startup mode in `lua/plugins/theme-switcher.lua`: `default_bg = "blackout"`

### Change Status Line

Edit `lua/plugins/ui.lua`, find the lualine config and customize sections. It already shows the git branch and diff, diagnostics, attached LSP servers and pending plugin updates.

### UI Toggles

Press `<leader>u` and wait: which-key lists toggles for spelling, wrap, line numbers, diagnostics, inlay hints, indent guides, treesitter, dim, zen mode and format on save. Each toggle shows its current state.

## Project-Specific Settings

Create `.nvim.lua` in your project root:

```lua
-- .nvim.lua in project root
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Project-specific keymaps
vim.keymap.set("n", "<leader>r", ":!cargo run<CR>")

-- Disable Windsurf for this project
vim.g.codeium_enabled = false
```

nananvim turns on `exrc`, so Neovim reads this file. The first time, Neovim asks you to trust it (you can also run `:trust` on the file).

## Need More Help?

- Check `:h <plugin-name>` for plugin help
- Look at the plugin's GitHub page
- Ask in GitHub issues: https://github.com/m4c4r0n1n/nananvim/issues
