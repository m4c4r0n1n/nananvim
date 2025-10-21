return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c", "lua", "vim", "vimdoc", "query",
        "python", "javascript", "typescript", "html", "css",
        "json", "yaml", "toml", "bash", "markdown",
      },

      -- Enable syntax highlighting
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      -- Enable incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      -- Enable indentation
      indent = {
        enable = true,
      },

      -- Auto-install missing parsers
      auto_install = true,
    })
  end,
}
