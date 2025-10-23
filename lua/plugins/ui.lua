return {
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
⠀⠀⠀⠀⠀⢀⣤⣴⣦⣶⣴⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠚⠋⠉⠀⠀⠀⠀⠈⠙⢷⣦⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠾⠛⠛⠉⠉⠛⠛⠷⠄⠀⠀
⠀⠀⠀⠀⢀⣀⣤⣤⣄⣀⠀⠀⠀⠀⠘⠷⠀⠀⠀⠀⠀⠀⣰⠞⠁⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀
⠀⠀⠀⢰⣿⢿⣽⣻⢾⣯⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⣿⢿⣻⣟⣿⣦⠀⠀
⠀⢀⡀⠈⠙⠛⠚⠋⠛⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠾⠿⠽⠾⠓⠋⢀⡀
⠀⣿⠙⠶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⠞⠋⣷
⠘⣿⠀⠀⡏⠙⠓⠶⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⠶⠛⠉⡯⠀⠀⣿
⠀⣿⠀⢀⡇⠀⠀⠀⠀⣿⠛⠛⠲⠶⠦⣦⣤⣤⣤⣤⣤⣶⠶⠶⠚⠛⠛⣿⠀⠀⠀⠀⡇⠀⢠⡟
⠀⢻⡄⢸⡇⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⢀⣿⠀⠀⠀⠀⢸⣟⠀⠀⠀⢀⡇⠀⣸⠃
⠀⠈⢷⣸⡇⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⢸⡷⠀⠀⠀⠀⢸⡇⠀⠀⠀⢸⡇⢠⡟⠀
⠀⠀⠈⢿⡇⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⢸⡇⠀⠀⠀⢸⣧⡟⠀⠀
⠀⠀⠀⠈⠳⣄⠀⠀⠀⣿⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⢸⡇⠀⠀⢀⣼⠏⠀⠀⠀
⠀⠀⠀⠀⠀⠘⢷⣄⢰⣟⠀⠀⠀⠀⢰⣯⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⢸⡇⢀⣤⠞⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠻⢯⣄⡀⠀⠀⢸⡗⠀⠀⠀⠀⢸⡇⠀⠀⠀⢀⣼⠷⠛⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠓⠶⠼⣧⣤⣤⣤⣤⣼⣧⠤⠶⠚⠋⠁⠀⠀⠀⠀    ⠀
⠀                          __
.-----.---.-.-----.---.-.-----.--.--.|__|.--------.
|     |  _  |     |  _  |     |  |  ||  ||        |
|__|__|___._|__|__|___._|__|__|\___/ |__||__|__|__|
          ]],
        },
      },
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
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
    opts = {
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
    },
  },
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
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
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
            function()
              return require("lazy.status").updates()
            end,
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
    },
  },
}
