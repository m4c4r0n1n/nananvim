-- Parsers that install at once. Other parsers install automatically when
-- you open a file of that type (see the FileType autocommand below).
local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "gitcommit",
  "gitignore",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    -- Other specs can add parsers: opts = { ensure_installed = { "rust" } }.
    opts_extend = { "ensure_installed" },
    opts = { ensure_installed = ensure_installed },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.install(opts.ensure_installed)

      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      local function start(buf, lang)
        if not pcall(vim.treesitter.start, buf, lang) then
          return false
        end
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        return true
      end

      -- Start highlights and indent for each file type that has a parser.
      -- If the parser is available but not installed, install it one time.
      local tried = {}
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nananvim_treesitter", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or start(buf, lang) then
            return
          end
          if tried[lang] or not available[lang] or vim.fn.executable("tree-sitter") ~= 1 then
            return
          end
          tried[lang] = true
          ts.install(lang):await(function(err)
            if err then
              return
            end
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(buf) then
                start(buf, lang)
              end
            end)
          end)
        end,
      })

      -- Incremental selection. Neovim 0.12 has this built in (an, in).
      -- These keys call the built-in feature.
      vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start selection" })
      vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Expand selection" })
      vim.keymap.set("x", "<BS>", "in", { remap = true, desc = "Shrink selection" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Text objects: af/if (function), ac/ic (class), aa/ia (argument).
      local objects = {
        f = { "@function.outer", "@function.inner", "function" },
        c = { "@class.outer", "@class.inner", "class" },
        a = { "@parameter.outer", "@parameter.inner", "argument" },
      }
      for key, obj in pairs(objects) do
        vim.keymap.set({ "x", "o" }, "a" .. key, function()
          select.select_textobject(obj[1], "textobjects")
        end, { desc = "Around " .. obj[3] })
        vim.keymap.set({ "x", "o" }, "i" .. key, function()
          select.select_textobject(obj[2], "textobjects")
        end, { desc = "Inside " .. obj[3] })
      end

      -- Motions: ]f/[f (function start), ]c/[c (class start), ]a/[a (argument).
      -- Upper case keys go to the end of the object.
      local moves = {
        f = { "@function.outer", "function" },
        c = { "@class.outer", "class" },
        a = { "@parameter.inner", "argument" },
      }
      for key, obj in pairs(moves) do
        local modes = { "n", "x", "o" }
        vim.keymap.set(modes, "]" .. key, function()
          -- In diff mode, ]c keeps its built-in function (next change).
          if vim.wo.diff and key == "c" then
            return vim.cmd("normal! ]c")
          end
          move.goto_next_start(obj[1], "textobjects")
        end, { desc = "Next " .. obj[2] .. " start" })
        vim.keymap.set(modes, "[" .. key, function()
          if vim.wo.diff and key == "c" then
            return vim.cmd("normal! [c")
          end
          move.goto_previous_start(obj[1], "textobjects")
        end, { desc = "Previous " .. obj[2] .. " start" })
        vim.keymap.set(modes, "]" .. key:upper(), function()
          move.goto_next_end(obj[1], "textobjects")
        end, { desc = "Next " .. obj[2] .. " end" })
        vim.keymap.set(modes, "[" .. key:upper(), function()
          move.goto_previous_end(obj[1], "textobjects")
        end, { desc = "Previous " .. obj[2] .. " end" })
      end
    end,
  },
  {
    -- Show the current function or class at the top of the window.
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = { max_lines = 3, multiline_threshold = 1 },
    keys = {
      {
        "[x",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Go to context",
      },
    },
  },
}
