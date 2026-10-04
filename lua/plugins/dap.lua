-- Graphical debugger (nvim-dap and dap-ui).
-- The extras.dap flag controls this file. When the flag is false, this file
-- returns an empty spec. The debugger loads only when you push a <leader>d key.
-- mason-tool-installer installs the debug adapters (see lua/plugins/lsp.lua).
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
      -- Lua adapter for Neovim config code and plugin code (all code that uses
      -- the vim API). It runs a DAP server. You attach to that server.
      -- See the nlua adapter and the <leader>dL key below.
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
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dp",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
        end,
        desc = "Log Point",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
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

      -- Panel sizes. Change these two numbers to make the panels larger.
      -- left_panel_width is the width of the sidebar (columns).
      -- bottom_panel_height is the height of the REPL and console (rows).
      local left_panel_width = 40
      local bottom_panel_height = 10

      -- DAP UI
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

      -- Variable values as virtual text
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

      -- Open the UI when a debug session starts. Close it when the session stops.
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Breakpoint icons.
      -- numhl makes the line number red. Thus you can see the breakpoint when
      -- the terminal font does not show the Nerd Font icon.
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "DiagnosticError" }
      )
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "󰁕 ", texthl = "DiagnosticInfo", linehl = "DapStoppedLine", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

      -- Highlight for the line where the debugger stopped
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- Adapters for each language.

      -- Python.
      -- Run the debugpy adapter from the Mason venv. Mason installs debugpy in
      -- its own venv. The system python3 usually does not have debugpy.
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
          -- Your program runs with the project interpreter (the active venv,
          -- if there is one). It does not run in the debugpy venv.
          pythonPath = function()
            local venv_path = os.getenv("VIRTUAL_ENV")
            if venv_path then
              return venv_path .. "/bin/python"
            end
            local python = vim.fn.exepath("python3")
            return python ~= "" and python or "python3"
          end,
        },
      }

      -- C, C++ and Rust with codelldb.
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

      -- Shell (sh and bash) with bash-debug-adapter.
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
          -- NixOS has no /bin/bash. Use the bash on PATH.
          pathBash = vim.fn.exepath("bash") ~= "" and vim.fn.exepath("bash") or "/bin/bash",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          args = {},
          env = {},
          terminalKind = "integrated",
        },
      }
      dap.configurations.bash = dap.configurations.sh

      -- Lua (Neovim config and plugins) with osv.
      -- osv debugs Lua that runs inside Neovim. Thus you must use two Neovim
      -- instances:
      --   1. In the instance that runs the code (the debuggee), push <leader>dL.
      --      This starts the server (osv.launch on port 8086).
      --   2. In a second instance with the source file open (the client), set
      --      breakpoints with <leader>db. Then push <leader>dc to attach.
      --   3. Run the code in the debuggee. The debugger stops at the breakpoint.
      --      Step through the code from the client.
      -- The adapter only connects to the server. It must not also launch the
      -- server. If it does, one instance is the debuggee and the client, and it
      -- stops at the first breakpoint with no client to control it.
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

      -- JavaScript and TypeScript with vscode-js-debug (js-debug-adapter).
      -- The adapter is a DAP server on a port. It runs with node, thus node
      -- must be on your PATH.
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
      -- JSX and TSX files use the same configurations.
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.typescript

      -- Project configurations: nvim-dap reads .vscode/launch.json
      -- automatically when you start a session (dap.continue or :DapNew).
      -- The "type" of each configuration selects one of the adapters above.
    end,
  },
}
