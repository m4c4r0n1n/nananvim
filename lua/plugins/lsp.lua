local extras = require("config.extras")

-- Language servers that Mason installs and this config enables.
-- To add a server: add its lspconfig name here. Add settings below if it needs them.
local servers = {
  "lua_ls",
  "basedpyright",
  "ruff",
  "ts_ls",
  "html",
  "cssls",
  "tailwindcss",
  "jsonls",
  "yamlls",
  "bashls",
  "marksman",
  "clangd",
}

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = servers,
      -- nvim-lspconfig below enables the servers. Do not enable them two times.
      automatic_enable = false,
    },
  },
  {
    -- Lua LSP support for the Neovim API. It loads library types only when
    -- they are necessary. This is faster than the full runtime path.
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazySpec" } },
      },
    },
  },
  { "b0o/SchemaStore.nvim", lazy = true, version = false },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          prefix = "●",
          source = "if_many",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          source = true,
          header = "",
          prefix = "",
        },
      })

      -- All servers get the completion capabilities from blink.cmp.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Server settings. Servers that are not in this list use the defaults
      -- from nvim-lspconfig.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            -- "standard" gives the same checks as pyright.
            -- "recommended" gives more checks.
            analysis = { typeCheckingMode = "standard" },
          },
        },
      })

      vim.lsp.config("clangd", {
        capabilities = { offsetEncoding = { "utf-16" } },
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
      })

      -- JSON and YAML get schemas from SchemaStore (package.json, GitHub
      -- workflows, docker-compose and more).
      vim.lsp.config("jsonls", {
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.json = config.settings.json or {}
          config.settings.json.schemas = require("schemastore").json.schemas()
        end,
        settings = { json = { validate = { enable = true } } },
      })

      vim.lsp.config("yamlls", {
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.yaml = config.settings.yaml or {}
          config.settings.yaml.schemas = require("schemastore").yaml.schemas()
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            keyOrdering = false,
            validate = true,
            -- Disable the built-in schema store. SchemaStore.nvim supplies the schemas.
            schemaStore = { enable = false, url = "" },
          },
        },
      })

      vim.lsp.enable(servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nananvim_lsp_attach", { clear = true }),
        callback = function(ev)
          -- Use the client that attached. Do not use the first client on the
          -- buffer, because the order is not fixed when many servers attach.
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end
          local buf = ev.buf

          local function map(mode, lhs, rhs, desc, opts)
            opts = vim.tbl_extend("force", { buffer = buf, desc = desc }, opts or {})
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          -- ruff and basedpyright both give hover text. Use basedpyright for hover.
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
          end

          -- Change the closing HTML tag when you change the opening tag.
          if client:supports_method("textDocument/linkedEditingRange") then
            vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
          end

          -- Pickers show a preview and let you filter long result lists.
          map("n", "gd", function()
            Snacks.picker.lsp_definitions()
          end, "Go to definition")
          map("n", "gD", function()
            Snacks.picker.lsp_declarations()
          end, "Go to declaration")
          map("n", "gr", function()
            Snacks.picker.lsp_references()
          end, "References", { nowait = true })
          map("n", "gi", function()
            Snacks.picker.lsp_implementations()
          end, "Go to implementation")
          map("n", "gy", function()
            Snacks.picker.lsp_type_definitions()
          end, "Go to type definition")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>cR", function()
            Snacks.rename.rename_file()
          end, "Rename file")
          map("n", "<leader>ss", function()
            Snacks.picker.lsp_symbols()
          end, "LSP symbols")
          map("n", "<leader>sS", function()
            Snacks.picker.lsp_workspace_symbols()
          end, "LSP workspace symbols")
          map("n", "<leader>ih", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
          end, "Toggle inlay hints")
        end,
      })
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
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        svelte = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        sh = { "shfmt" },
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      -- Format on save, unless :FormatToggle turned it off.
      format_on_save = function(bufnr)
        local enabled = vim.b[bufnr].autoformat
        if enabled == nil then
          enabled = vim.g.autoformat
        end
        if not enabled then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = function()
      -- conform.nvim uses these formatters. Mason always installs them.
      local tools = {
        "stylua",
        "prettierd",
        "prettier",
        "shfmt",
        "clang-format",
      }
      -- nvim-lint uses these linters. Mason installs them so that linting
      -- works at once. Keep this list the same as lua/plugins/lint.lua.
      if extras.lint then
        vim.list_extend(tools, {
          "shellcheck",
          "markdownlint",
          "hadolint",
          "yamllint",
        })
      end
      -- nvim-dap uses these debug adapters (see lua/plugins/dap.lua).
      if extras.dap then
        vim.list_extend(tools, {
          "debugpy",
          "codelldb",
          "bash-debug-adapter",
          "js-debug-adapter",
        })
      end
      return {
        ensure_installed = tools,
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      }
    end,
  },
}
