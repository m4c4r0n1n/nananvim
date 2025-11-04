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
6. Press `<leader>tb` to toggle between Terminal and Blackout backgrounds

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
2. Add your language server to the `ensure_installed` list:

```lua
ensure_installed = {
  "lua_ls",
  "pyright",
  "ts_ls",
  -- Add your servers here:
  "rust_analyzer",  -- Rust
  "gopls",          -- Go
  "jdtls",          -- Java
  "omnisharp",      -- C#
},
```

3. Register the server below in the config:

```lua
local simple_servers = { 
  "pyright", "ts_ls", "html", "cssls", "tailwindcss", "jsonls",
  "rust_analyzer", "gopls"  -- Add yours here
}
```

4. Restart nvim - Mason will auto-install the servers

### Popular Language Servers:

- **Rust:** `rust_analyzer`
- **Go:** `gopls`
- **Java:** `jdtls`
- **C#:** `omnisharp`
- **Ruby:** `solargraph`
- **PHP:** `intelephense`
- **Kotlin:** `kotlin_language_server`

## Adding Formatters

To add formatters for auto-format on save:

1. Edit `lua/plugins/lsp.lua`
2. Find the `formatters_by_ft` section in conform.nvim
3. Add your formatter:

```lua
formatters_by_ft = {
  lua = { "stylua" },
  python = { "isort", "black" },
  -- Add yours:
  rust = { "rustfmt" },
  go = { "gofmt", "goimports" },
  ruby = { "rubocop" },
},
```

4. Add the formatter to mason-tool-installer:

```lua
ensure_installed = {
  "prettierd", "prettier", "black", "isort", "clang-format",
  "rustfmt", "gofmt", "goimports",  -- Add yours
},
```

## Changing Keybindings

### Global Keymaps

Edit `lua/config/keymaps.lua`:

```lua
-- Example: Change file finder from 'f' to '<leader>ff'
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

-- Add your own:
keymap("n", "<leader>gg", ":!lazygit<cr>", { desc = "LazyGit" })
```

### Plugin-Specific Keymaps

Most plugins define their keymaps in their respective files in `lua/plugins/`.

**Example - Change Codeium accept key:**

Edit `lua/plugins/coding.lua`, find the Codeium section:

```lua
vim.keymap.set("i", "<C-y>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })
```

Change `"<C-y>"` to whatever key you prefer.

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
    cmd = { "TroubleToggle", "Trouble" },
    -- rest of config...
  },
}
```

**Disable Codeium:**

Edit `lua/plugins/coding.lua` and add:

```lua
{
  "Exafunction/codeium.vim",
  enabled = false,  -- Disables Codeium
  event = "InsertEnter",
  ...
}
```

**Disable Avante (AI Chat):**

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

**LazyGit (Git UI in Neovim):**
```lua
{
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
}
```

**Note:** lazygit must be installed on your system first. It's included in the nananvim installer.

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
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
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

### Customizing Codeium

Edit `lua/plugins/coding.lua` to customize Codeium behavior:

```lua
-- Change keybindings
vim.keymap.set("i", "<C-g>", function()  -- Changed from Tab
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })

-- Disable Codeium for certain filetypes
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
        model = "claude-sonnet-4-20250514",
        extra_request_body = {
          temperature = 0.7,  -- Adjust creativity (0-1)
          max_tokens = 8000,  -- Increase for longer responses
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

### Adjust Transparency

Enabled by default. If you want to disable it:

Edit `lua/plugins/colorscheme.lua`:

```lua
config = function()
  require("rose-pine").setup({
    variant = "moon",
    disable_background = false,  -- Change to false
  })
  vim.cmd.colorscheme("rose-pine-moon")
end,
```

### Change Status Line

Edit `lua/plugins/ui.lua`, find the lualine config and customize sections.

## Project-Specific Settings

Create `.nvim.lua` in your project root:

```lua
-- .nvim.lua in project root
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Project-specific keymaps
vim.keymap.set("n", "<leader>r", ":!cargo run<CR>")

-- Disable Codeium for this project
vim.g.codeium_enabled = false
```

Then trust it with `:trust`

## Need More Help?

- Check `:h <plugin-name>` for plugin help
- Look at the plugin's GitHub page
- Ask in GitHub issues: https://github.com/m4c4r0n1n/nananvim/issues
