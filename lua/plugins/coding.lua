-- AI plugins (Windsurf/Codeium and Avante) load only when the file
-- lua/config/local.lua exists. This keeps a new install small: no binary
-- download, no make step and no AI plugin until you ask for it.
local ai_enabled = vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/config/local.lua") == 1
local extras = require("config.extras")
local rich = extras.cmp_rich

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts_extend = { "sources.default" },
    opts = function()
      local opts = {
        keymap = {
          -- <CR> accepts only an item that you selected.
          -- <Tab> and <S-Tab> move in the menu, then jump in snippets.
          preset = "enter",
          ["<C-n>"] = { "select_next", "fallback_to_mappings" },
          ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
          ["<C-y>"] = { "select_and_accept", "fallback" },
          ["<C-d>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        },
        appearance = { nerd_font_variant = "mono" },
        completion = {
          list = { selection = { preselect = false, auto_insert = false } },
          accept = { auto_brackets = { enabled = true } },
          menu = {
            border = rich and "rounded" or "none",
            draw = rich and { treesitter = { "lsp" } } or {
              columns = { { "label", "label_description", gap = 1 }, { "kind" } },
            },
          },
          documentation = {
            auto_show = rich,
            auto_show_delay_ms = 200,
            window = { border = rich and "rounded" or "none" },
          },
          ghost_text = { enabled = rich },
        },
        signature = {
          enabled = true,
          window = { border = rich and "rounded" or "none" },
        },
        sources = {
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- Show lazydev items before LSP items.
              score_offset = 100,
            },
          },
        },
        cmdline = {
          keymap = { preset = "cmdline" },
          completion = { menu = { auto_show = true } },
        },
        -- Use the Rust fuzzy matcher. Show a warning if its binary is not available.
        fuzzy = { implementation = "prefer_rust_with_warning" },
      }

      -- Add the sources from lua/config/extras.lua.
      for name, provider in pairs(extras.cmp_extra_sources or {}) do
        opts.sources.providers[name] = provider
        table.insert(opts.sources.default, name)
      end

      return opts
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true },
  },
  {
    -- Neovim has built-in commenting (gc, gcc). This plugin gives it the
    -- correct comment string for embedded languages (for example, JSX and Vue).
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Windsurf (formerly Codeium) AI suggestions. Opt-in, see ai_enabled above.
  {
    "Exafunction/windsurf.vim",
    event = "InsertEnter",
    enabled = ai_enabled,
    init = function()
      vim.g.codeium_disable_bindings = 1
    end,
    config = function()
      -- Accept a suggestion with <Tab>.
      -- When the completion menu is open, blink.cmp uses <Tab> first.
      -- blink.cmp sends <Tab> to this mapping when the menu is closed.
      vim.keymap.set("i", "<Tab>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true, replace_keycodes = false, desc = "Accept AI suggestion" })

      vim.keymap.set("i", "<C-]>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true, desc = "Clear AI suggestion" })

      vim.keymap.set("i", "<M-]>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true, desc = "Next AI suggestion" })

      vim.keymap.set("i", "<M-[>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true, desc = "Previous AI suggestion" })
    end,
  },

  -- Emmet for HTML and CSS abbreviations
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-z>"
      vim.g.user_emmet_mode = "inv" -- Insert, normal and visual mode
      vim.g.user_emmet_install_global = 0
    end,
  },

  -- Avante AI chat. Opt-in.
  -- To enable it, make lua/config/local.lua and add your provider settings.
  {
    "yetone/avante.nvim",
    version = false,
    enabled = ai_enabled,
    build = "make",
    opts = function()
      -- Use the settings from lua/config/local.lua if they exist.
      local ok, local_config = pcall(require, "config.local")
      if ok and type(local_config) == "table" and local_config.avante then
        return local_config.avante
      end

      -- Default settings. Set ANTHROPIC_API_KEY in your shell.
      return {
        provider = "claude",
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com",
            -- For harder tasks, change this to "claude-opus-5-5".
            -- Do not set temperature. Sonnet 5.5 rejects sampling parameters
            -- that are not the default.
            model = "claude-sonnet-5-5",
            extra_request_body = {
              max_tokens = 16000,
            },
          },
        },
        input = { provider = "snacks" },
        selector = { provider = "snacks" },
        behaviour = {
          auto_suggestions = false,
          auto_set_highlight_group = true,
          auto_set_keymaps = true,
          auto_apply_diff_after_generation = false,
          support_paste_from_clipboard = false,
        },
        hints = { enabled = false },
        windows = {
          position = "right",
          wrap = true,
          width = 30,
          sidebar_header = {
            align = "center",
            rounded = true,
          },
        },
        highlights = {
          diff = {
            current = "DiffText",
            incoming = "DiffAdd",
          },
        },
        diff = {
          autojump = true,
          list_opener = "copen",
        },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "Avante" },
        opts = {
          file_types = { "markdown", "Avante" },
        },
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("avante.api").ask()
        end,
        desc = "Avante: Ask",
        mode = { "n", "x" },
      },
      {
        "<leader>ar",
        function()
          require("avante.api").refresh()
        end,
        desc = "Avante: Refresh",
      },
      {
        "<leader>ae",
        function()
          require("avante.api").edit()
        end,
        desc = "Avante: Edit",
        mode = "x",
      },
      { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante: Toggle" },
      { "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Avante: Chat" },
      { "<leader>af", "<cmd>AvanteFocus<cr>", desc = "Avante: Focus" },
    },
  },
}
