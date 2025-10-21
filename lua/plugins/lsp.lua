return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local servers = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "jsonls",
        "clangd",
      }

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
              hint = { enable = true },
            },
          },
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
        },
      }

      -- Configure diagnostics globally
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          prefix = "●",
          source = "if_many",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Customize diagnostic signs
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = "󰌶 ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Setup Mason
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      -- LspAttach autocmd for keymaps and inlay hints
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local clients = vim.lsp.get_clients({ bufnr = ev.buf })
          if #clients == 0 then return end
          local client = clients[1]
          local opts = { buffer = ev.buf }

          -- Enable inlay hints if supported
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end

          -- Keymaps
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

          -- Toggle inlay hints
          vim.keymap.set("n", "<leader>th", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
          end, { buffer = ev.buf, desc = "Toggle Inlay Hints" })
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local function setup_server(server_name)
        local config = { capabilities = capabilities }
        if server_configs[server_name] then
          config = vim.tbl_deep_extend("force", config, server_configs[server_name])
        end
        return config
      end

      -- Use new vim.lsp.config API if available, fallback to lspconfig
      if vim.lsp.config then
        -- New Neovim 0.11+ API
        for _, server in ipairs(servers) do
          vim.lsp.config(server, setup_server(server))
        end
        vim.lsp.enable(servers)
      else
        -- Fallback to old lspconfig for Neovim < 0.11
        local lspconfig = require("lspconfig")
        for _, server in ipairs(servers) do
          lspconfig[server].setup(setup_server(server))
        end
      end
    end,
  },
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
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
        "prettierd",
        "prettier",
        "black",
        "isort",
        "clang-format",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}
