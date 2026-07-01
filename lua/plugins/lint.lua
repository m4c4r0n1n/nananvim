-- Standalone linters (layered on top of LSP diagnostics) via nvim-lint.
-- Gated by the extras switch; returns an empty spec when disabled so lazy
-- simply skips it.
if not require("config.extras").lint then
  return {}
end

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Data-driven: add a `filetype = { "linter", ... }` entry and you're done.
      -- Linters whose executable isn't installed are skipped silently (see the
      -- guard below), so this list is safe to grow on any machine.
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        markdown = { "markdownlint" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        -- python / js / lua etc. are largely covered by their LSP; add here if
        -- you want a standalone linter on top.
      }

      -- Merge user-provided linters from lua/config/local.lua if present.
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
