-- Graphical debugger (nvim-dap + dap-ui). Gated by the extras switch; returns
-- an empty spec when disabled. Loads only on the <leader>d* keys.
if not require("config.extras").dap then
  return {}
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      -- Lua adapter for debugging Neovim config/plugin code (anything using the
      -- vim API). It runs a DAP server you attach to; see the nlua adapter and
      -- the <leader>dL launch key below for the two-instance workflow.
      "jbyuki/one-small-step-for-vimkind",
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "Open REPL",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Hover Variables",
      },
      {
        "<leader>dS",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Scopes",
      },
      {
        "<leader>dL",
        function()
          require("osv").launch({ port = 8086 })
        end,
        desc = "Launch Lua Debug Server (debuggee)",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Panel sizes. Bump these two numbers if the default panels feel too
      -- cramped: left is the sidebar width (columns), bottom is the repl/console
      -- height (rows). This is the one place to change them.
      local left_panel_width = 40
      local bottom_panel_height = 10

      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = left_panel_width,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = bottom_panel_height,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = "<module",
        virt_text_pos = "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      -- Auto-open UI on debugging
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Breakpoint icons
      -- numhl reddens the line number too, so a breakpoint is obvious even if the
      -- Nerd Font gutter glyph doesn't render in a given terminal/font.
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "DiagnosticError" }
      )
      vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "󰁕 ", texthl = "DiagnosticInfo", linehl = "DapStoppedLine", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

      -- Highlight groups for stopped line
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- Language-specific adapters
      -- Python
      -- Run the debugpy adapter from Mason's own venv. Bare "python3" only works
      -- if the system interpreter happens to have debugpy installed, which it
      -- usually does not; Mason installs debugpy into an isolated venv.
      local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      dap.adapters.python = {
        type = "executable",
        command = debugpy_python,
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          -- The program itself runs under the project's interpreter (venv if
          -- active), NOT the debugpy venv above.
          pythonPath = function()
            local venv_path = os.getenv("VIRTUAL_ENV")
            if venv_path then
              return venv_path .. "/bin/python"
            end
            return "/usr/bin/python3"
          end,
        },
      }

      -- C/C++/Rust via codelldb (installed by mason-nvim-dap below)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- ==========================================
      -- Shell / Bash Configuration
      -- ==========================================
      dap.adapters.bashdb = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
        args = {},
      }

      dap.configurations.sh = {
        {
          type = "bashdb",
          request = "launch",
          name = "Launch file",
          showDebugOutput = true,
          pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
          pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
          trace = true,
          file = "${file}",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pathCat = "cat",
          pathBash = "/bin/bash",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          args = {},
          env = {},
          terminalKind = "integrated",
        },
      }
      dap.configurations.bash = dap.configurations.sh

      -- ==========================================
      -- Lua (Neovim config/plugins) via osv
      -- ==========================================
      -- osv debugs Lua that runs INSIDE Neovim (anything using the vim API), so
      -- it uses a two-instance workflow, same as debugging nvim Lua in any
      -- editor:
      --   1. In the nvim running the code you want to debug (the "debuggee"),
      --      press <leader>dL to start the server (osv.launch on port 8086).
      --   2. In a SECOND nvim with the source open (your "client"/editor), set
      --      breakpoints with <leader>db and press <leader>dc to attach.
      --   3. Trigger the code in the debuggee; the breakpoint hits and you step
      --      from the client.
      -- The adapter is a pure server callback: attaching must NOT also launch, or
      -- one instance becomes both debuggee and client and deadlocks on the first
      -- breakpoint (the old ECONNREFUSED/freeze bug).
      dap.adapters.nlua = function(callback, config)
        callback({
          type = "server",
          host = config.host or "127.0.0.1",
          port = config.port or 8086,
        })
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance (start it with <leader>dL)",
        },
      }

      -- ==========================================
      -- JavaScript / TypeScript via vscode-js-debug (js-debug-adapter)
      -- ==========================================
      -- Replaces the archived node-debug2. The mason package js-debug-adapter
      -- ships a launcher that speaks DAP over a server port. Needs node on PATH
      -- (used to run the adapter itself).
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
          args = { "${port}" },
        },
      }

      for _, lang in ipairs({ "javascript", "typescript" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
        }
      end
      -- React/Vue/etc. single-file components reuse the JS/TS launch configs.
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.typescript

      -- Zero-boilerplate per-project debugging: any project that ships a
      -- .vscode/launch.json has its configs read automatically on dap.continue()
      -- / :DapNew (nvim-dap's built-in launch.json provider), matched to the
      -- adapters above by each config's "type". No call or Lua editing needed;
      -- the old dap.ext.vscode.load_launchjs() is deprecated for exactly this.
    end,
  },

  -- Mason integration for debug adapters
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    event = "VeryLazy",
    config = function()
      -- Defer setup to avoid race conditions
      vim.defer_fn(function()
        require("mason-nvim-dap").setup({
          ensure_installed = {
            "python",
            "codelldb", -- C/C++/Rust
            "bash", -- bash-debug-adapter (shell / sh / bash)
            "js", -- js-debug-adapter (JavaScript / TypeScript)
          },
          -- Install a debug adapter on demand the first time it's needed, so
          -- debugging a new language works without hand-wiring mason.
          automatic_installation = true,
          -- No `handlers`: mason-nvim-dap's automatic setup overwrites the
          -- adapters defined above and list_extend-appends its own configs,
          -- which duplicated every entry in the dap.continue() picker.
        })
      end, 1000) -- Wait 1 second after Mason is ready
    end,
  },
}
