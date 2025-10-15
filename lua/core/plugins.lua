-- ~/.config/nvim/lua/core/plugins.lua
-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- setup plugins

require("lazy").setup({
  -- Snacks dashboard & utilities
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      image = { enabled = true },
      picker = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = [[

⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢀⣀⣀⣀⠀⠀⢀⣀⣀⣀⣠⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢽⣾⢿⣿⡛⠿⠾⠟⠛⠋⠉⠉⠉⠉⠛⠛⣿⣶⠿⣻⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣺⣿⣴⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡟⠁⣿⣏⡯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢩⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣺⡿⣿⣯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠹⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣸⡿⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⣿⣇⡀⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⣴⣻⣿⣆⣀⣀⣀⡀⠀⠀⠀⠀⢹⣿⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣤⣴⢾⣿⠀⠉⢻⠛⠛⠁⠀⣽⣯⠀⠀⠈⠻⠿⢿⠋⠀⠀⠈⠱⡀⠀⠀⠀⠈⣿⣿⢷⣶⣤⣄⠀⠀⠀⠀⠀
⠀⠀⢀⣴⠟⠋⠀⣻⣟⣀⣀⠜⠀⠀⠀⠑⠋⠙⠒⠁⠀⠀⠀⢸⡄⠀⠀⠀⢠⠇⠀⠀⠀⢀⣿⡿⠁⠀⠙⢿⣷⡄⠀⠀⠀
⠀⣰⣿⣷⣶⣶⣦⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠤⠖⠋⠀⠀⢀⣴⡿⠋⠀⠀⠀⠀⠀⠹⣿⣆⠀⠀
⢠⣿⡿⠋⠉⠉⣻⣿⣇⠀⠈⢿⣆⣀⣀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⢀⣤⣾⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⡀⠀
⢸⣿⠁⠀⠀⢠⣿⠛⣿⣄⠀⢸⣿⠙⠛⠛⠿⠷⢶⣶⡟⠋⠀⠀⢀⣾⣷⡾⢟⣋⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣷⠀
⢸⡿⠀⠀⠀⣸⡟⠀⠘⠻⠷⠿⠃⠀⠀⠀⠀⠀⢸⣿⠀⠀⣀⣴⣿⣯⡧⠶⣿⣭⣙⠻⢷⣦⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡆
⢺⣇⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢙⣿⢟⣿⡿⠋⠁⣴⠀⠀⠉⠻⣷⣦⡙⢿⣦⠀⠀⠀⠀⠀⠀⠀⣿⡇
⢸⣿⠀⠀⠀⢸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⢫⣾⠟⠀⠀⠀⣿⠀⠀⠀⠀⠈⠻⣷⣄⢹⣷⡄⠀⠀⠀⠀⠀⣿⡇
⠀⣿⡆⠀⠀⠘⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⢣⣿⠃⠀⠀⠀⢰⣿⠀⠀⠀⠀⠀⠀⠙⣿⣦⢹⣿⠀⠀⠀⠀⠀⣿⣗
⠀⠸⣷⠀⠀⠀⢹⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⣾⡏⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠘⣿⣧⢻⣷⠀⠀⠀⠀⣿⡇
⠀⠀⣿⡆⠀⠀⠈⣿⣧⠀⠀⠀⠀⠀⠀⠀⢠⣿⢰⣿⠁⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡎⣿⡇⠀⠀⢀⣿⡇
⠀⠀⢸⣧⠀⠀⢀⣿⣿⣆⠀⠀⠀⠀⠀⠀⢸⣿⢸⡿⠀⠀⠀⠀⠀⣼⡇⠀⠀⠀⠀⠀⠀⠀⣾⣿⢹⣿⢹⡇⠀⠀⢸⣿⡇
⠀⠀⠀⣿⠀⠀⢸⣿⢹⣿⣆⠀⠀⠀⠀⠀⢸⡟⣼⡇⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⢠⣿⡇⢸⣿⢸⡇⠀⠀⣿⡿⠀
⠀⠀⠀⣿⡆⠀⣾⡟⠈⣿⣿⣆⠀⠀⠀⠀⢸⣧⣿⠃⠀⠀⠀⠀⢠⣿⠀⠀⠀⠀⠀⠀⢀⣾⡿⠀⢸⣿⠿⠀⠀⣼⣿⠃⠀
⠀⠀⠀⠸⣧⣴⡿⠁⠀⣿⡟⣿⣦⡀⠀⢀⣿⣿⠃⠀⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⣼⡿⠃⠀⣼⡟⠀⢀⣼⡿⠃⠀⠀
⠀⠀⠀⠀⠈⠁⠀⠀⠀⣿⡇⠈⠛⠿⠿⠿⠛⠁⠀⠀⠀⠀⠀⠀⣾⠇⠀⠀⠀⠀⠀⣸⣿⠃⠀⠀⠘⠿⢶⠿⠟⠁⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⣴⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠃⠀⠀⠀⠀⣼⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠏⠀⠀⠀⢀⣼⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣧⠀⠀⠀⠀⠀⠀⠀⠀⢀⠛⠀⠀⠀⣠⣾⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡆⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⢀⣼⡿⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡄⠀⠀⠀⠀⣰⡿⠃⢀⣼⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⣀⣀⣀⣰⣿⠁⣰⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣾⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                          __
.-----.---.-.-----.---.-.-----.--.--.|__|.--------.
|     |  _  |     |  _  |     |  |  ||  ||        |
|__|__|___._|__|__|___._|__|__|\___/ |__||__|__|__|

                                               ]],
        },
      },
    },
  },
  -- File icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        plugins = { spelling = true },
      })
    end,
  },

  -- Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
      { "<leader>o", "<cmd>Neotree focus<cr>",  desc = "Focus file explorer" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
        },
        window = {
          width = 30,
          mappings = {
            ["<space>"] = "none",
          },
        },
      })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete other buffers" },
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
    },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      })
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
      end,
    },
  },

  -- Trouble (better diagnostics list)
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
    },
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- Manual setup call
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if ok then
        ts.setup({
          auto_install = false,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = { enable = true },
          ensure_installed = {
            "latex",
            "bash",
            "c",
            "css",
            "html",
            "javascript",
            "json",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "norg",
            "python",
            "query",
            "regex",
            "scss",
            "svelte",
            "tsx",
            "typescript",
            "typst",
            "vim",
            "vimdoc",
            "vue",
            "yaml",
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<C-space>",
              node_incremental = "<C-space>",
              scope_incremental = false,
              node_decremental = "<bs>",
            },
          },
        })
      end
    end,
  },

  -- Autocompletion

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- LSP server configuration
      local servers = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "jsonls",
      }

      -- Server-specific configurations
      local server_configs = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
        -- Add more server-specific configs here as needed
        -- pyright = { settings = { ... } },
        -- ts_ls = { settings = { ... } },
      }

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Dynamic server setup function
      local function setup_server(server_name)
        local config = {
          capabilities = capabilities,
        }

        -- Merge server-specific config if it exists
        if server_configs[server_name] then
          config = vim.tbl_deep_extend("force", config, server_configs[server_name])
        end

        return config
      end

      -- Check if vim.lsp.config exists (Neovim 0.11+)
      if vim.lsp.config then
        -- Use new API (Neovim 0.11+)
        for _, server in ipairs(servers) do
          vim.lsp.config(server, setup_server(server))
        end
      else
        -- Use traditional lspconfig API (older Neovim versions)
        local lspconfig = require("lspconfig")

        for _, server in ipairs(servers) do
          local config = setup_server(server)
          lspconfig[server].setup(config)
        end
      end
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },

  -- Toggle terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
      size = 20,
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = {
        border = "curved",
      },
    },
  },

  -- Telescope with file preview
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",       desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",         desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",       desc = "Help tags" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>",        desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope colorscheme<cr>",     desc = "Colorschemes" },
      { "<leader>fr", "<cmd>Telescope resume<cr>",          desc = "Resume" },
      { "<leader>:",  "<cmd>Telescope command_history<cr>", desc = "Command History" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = { ".git/", "node_modules" },
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
            },
          },
        },
        pickers = {
          buffers = {
            initial_mode = "normal",
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
        },
      })
    end,
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            { "diagnostics" },
            { "filetype",   icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename",   path = 1 },
          },
          lualine_x = {
            {
              function() return require("lazy.status").updates() end,
              cond = require("lazy.status").has_updates,
              color = { fg = "#ff9e64" },
            },
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },

  -- Auto-detect indentation
  { "tpope/vim-sleuth" },

  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = false,
          telescope = {
            enabled = true,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          mason = true,
          which_key = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Ensure external tools (formatters/linters) are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "prettierd",
          "prettier",
          "black",
          "isort",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-y>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
      })
    end,
  },
})
