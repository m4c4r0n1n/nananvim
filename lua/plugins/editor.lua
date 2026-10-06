return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      plugins = { spelling = true },
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "git hunks" },
        { "<leader>i", group = "inlay hints" },
        { "<leader>r", group = "rename/replace" },
        { "<leader>s", group = "search" },
        { "<leader>S", group = "sessions" },
        { "<leader>T", group = "tests" },
        { "<leader>t", group = "theme/term/todo" },
        { "<leader>u", group = "ui toggles" },
        { "<leader>w", group = "web" },
        { "<leader>x", group = "diagnostics" },
        { "[", group = "previous" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps (which-key)",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
      { "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
    },
    init = function()
      -- Open neo-tree when Neovim starts with a folder (nvim .).
      -- neo-tree loads lazily. This autocommand loads it only in that case.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("nananvim_neotree_start", { clear = true }),
        desc = "Start neo-tree with a folder",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          end
          local stats = vim.uv.fs_stat(vim.fn.argv(0) --[[@as string]])
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end,
      })
    end,
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        follow_current_file = { enabled = true },
        -- neo-tree takes control of folder buffers. "open_current" opens the
        -- tree in the current window when you run :e <folder>.
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
    config = function(_, opts)
      -- Tell the LSP servers when neo-tree renames or moves a file.
      -- Thus the imports in other files also change.
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end
      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
    end,
  },
  {
    -- Jump to any visible location with 2 or 3 key presses.
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- Keep f, F, t and T as the built-in motions.
      modes = { char = { enabled = false } },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        -- Not in visual mode. nvim-surround uses S there.
        mode = { "n", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter search",
      },
      {
        "<C-s>",
        mode = "c",
        function()
          require("flash").toggle()
        end,
        desc = "Toggle flash search",
      },
    },
  },
  {
    -- Search and replace in many files, with a live preview.
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and replace",
      },
    },
  },
  { "tpope/vim-sleuth", event = { "BufReadPre", "BufNewFile" } },
  {
    -- Save the session (open files, splits, cursor) for each folder when you quit.
    -- Restore it from the dashboard (s) or with <leader>Ss.
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>Ss",
        function()
          require("persistence").load()
        end,
        desc = "Restore session (this folder)",
      },
      {
        "<leader>Sl",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore last session",
      },
      {
        "<leader>SS",
        function()
          require("persistence").select()
        end,
        desc = "Select session",
      },
      {
        "<leader>Sd",
        function()
          require("persistence").stop()
        end,
        desc = "Do not save this session",
      },
    },
  },
  {
    -- Edit the file system like a buffer: rename, move and delete files with
    -- normal text edits, then save with :w. Push - to open the parent folder.
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent folder (oil)" },
    },
    opts = {
      -- neo-tree opens folders (nvim .). oil opens only with - or :Oil.
      default_file_explorer = false,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
      },
    },
  },
  {
    -- Mark the files that you use most. Jump to them with one key.
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = { save_on_toggle = true },
    },
    keys = function()
      local keys = {
        {
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon: mark file",
        },
        {
          "<leader>j",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon: marked files",
        },
      }
      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon: file " .. i,
        })
      end
      return keys
    end,
  },
  {
    -- Multiple cursors. <C-n> adds a cursor at the next match of the word
    -- or the selection. <Esc> removes all cursors.
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      {
        "<C-n>",
        function()
          require("multicursor-nvim").matchAddCursor(1)
        end,
        mode = { "n", "x" },
        desc = "Add cursor at next match",
      },
      {
        "<C-p>",
        function()
          require("multicursor-nvim").matchSkipCursor(1)
        end,
        mode = { "n", "x" },
        desc = "Skip this match",
      },
      {
        "<leader>M",
        function()
          require("multicursor-nvim").matchAllAddCursors()
        end,
        mode = { "n", "x" },
        desc = "Add cursors at all matches",
      },
      {
        "<C-q>",
        function()
          require("multicursor-nvim").toggleCursor()
        end,
        mode = { "n", "x" },
        desc = "Add or remove cursor here",
      },
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      -- These keys work only when there are many cursors.
      mc.addKeymapLayer(function(layer)
        layer({ "n", "x" }, "<left>", mc.prevCursor)
        layer({ "n", "x" }, "<right>", mc.nextCursor)
        layer({ "n", "x" }, "<leader>X", mc.deleteCursor)
        layer("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },
  {
    -- In tmux, <C-h/j/k/l> move between Neovim splits and tmux panes.
    -- This loads only in tmux. Add the tmux side from the plugin README.
    "christoomey/vim-tmux-navigator",
    cond = vim.env.TMUX ~= nil,
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window or pane" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower window or pane" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper window or pane" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window or pane" },
    },
  },
  {
    -- Save or open a file that needs root: :SudaWrite and :SudaRead.
    "lambdalisue/vim-suda",
    cmd = { "SudaWrite", "SudaRead" },
  },
}
