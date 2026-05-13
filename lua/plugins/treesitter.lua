return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    -- v2 rewrite: setup() only takes install_dir; parsers go through install()
    require("nvim-treesitter").install({
      "c", "lua", "vim", "vimdoc", "query",
      "python", "javascript", "typescript",
      "html", "css", "json", "yaml", "toml",
      "bash", "markdown",
    })

    -- Enable highlighting + treesitter-based indent for any filetype with a parser
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if pcall(vim.treesitter.start) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Incremental selection (gone from nvim-treesitter v2). Reimplemented
    -- against Neovim's native vim.treesitter API.
    local selection_stack = {}

    local function select_node(node)
      local srow, scol, erow, ecol = node:range()
      vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
      vim.cmd("normal! v")
      vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
    end

    local function init_selection()
      local node = vim.treesitter.get_node()
      if not node then
        return
      end
      selection_stack = { node }
      select_node(node)
    end

    local function node_incremental()
      local current = selection_stack[#selection_stack]
      if not current then
        return init_selection()
      end
      local parent = current:parent()
      if not parent then
        return
      end
      table.insert(selection_stack, parent)
      select_node(parent)
    end

    local function node_decremental()
      if #selection_stack <= 1 then
        return
      end
      table.remove(selection_stack)
      select_node(selection_stack[#selection_stack])
    end

    vim.keymap.set("n", "<C-space>", init_selection, { desc = "TS: init selection" })
    vim.keymap.set("x", "<C-space>", node_incremental, { desc = "TS: expand selection" })
    vim.keymap.set("x", "<BS>", node_decremental, { desc = "TS: shrink selection" })
  end,
}
