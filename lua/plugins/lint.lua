-- Linters with nvim-lint. Their diagnostics show with the LSP diagnostics.
-- The extras.lint flag controls this file. When the flag is false, this file
-- returns an empty spec and lazy.nvim ignores it.
if not require("config.extras").lint then
  return {}
end

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- To add a linter, add an entry: filetype = { "linter" }.
      -- If a linter is not installed, try_lint ignores it (see below).
      -- Thus you can add linters safely on all computers.
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        -- zsh is not in this list. shellcheck does not support zsh (SC1071).
        markdown = { "markdownlint" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        -- The LSP servers check Python, JavaScript and Lua.
        -- Add a linter here if you want more checks.
      }

      -- Add the linters from lua/config/local.lua, if that file exists.
      local ok, personal = pcall(require, "config.local")
      if ok and type(personal.linters_by_ft) == "table" then
        for ft, linters in pairs(personal.linters_by_ft) do
          lint.linters_by_ft[ft] = linters
        end
      end

      local function try_lint()
        local names = lint.linters_by_ft[vim.bo.filetype]
        if not names then
          return
        end
        local available = {}
        for _, name in ipairs(names) do
          local linter = lint.linters[name]
          local cmd = type(linter) == "table" and linter.cmd or name
          if type(cmd) == "function" then
            cmd = cmd()
          end
          if vim.fn.executable(cmd) == 1 then
            available[#available + 1] = name
          end
        end
        if #available > 0 then
          lint.try_lint(available)
        end
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = try_lint,
      })
    end,
  },
}
