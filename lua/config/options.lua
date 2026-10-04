local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

-- Tabs and indentation.
-- These values are fallbacks. vim-sleuth reads each file and sets
-- tabstop, shiftwidth and expandtab for that buffer.
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.shiftround = true

-- Line wrap
opt.wrap = false
opt.linebreak = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- The cursor line is off. The theme switcher sets it in its picker.
opt.cursorline = false

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
-- All floating windows get a rounded border (Neovim 0.11 and later).
opt.winborder = "rounded"

-- The terminal title shows the name of the file that you edit.
-- Example: the Ghostty tab shows "nvim · init.lua".
-- A buffer without a name shows the name of the current folder.
opt.title = true
opt.titlestring = [[nvim · %{empty(expand('%:t')) ? fnamemodify(getcwd(), ':t') : expand('%:t')}]]

-- Transparency for menus
opt.pumblend = 10
opt.winblend = 0

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard. Set it after startup. Thus startup does not wait for the
-- clipboard provider (this provider is slow over SSH).
vim.schedule(function()
  opt.clipboard:append("unnamedplus")
end)

-- Split windows
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

-- No swap files and no backup files
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Undo
opt.undofile = true
opt.undolevels = 10000
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Timing
opt.updatetime = 200
opt.timeoutlen = 300
opt.redrawtime = 10000

-- Scroll
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true

-- File encoding
opt.fileencoding = "utf-8"

-- Command line
opt.cmdheight = 1
opt.showcmd = true
opt.showmode = false
opt.laststatus = 3

-- Completion menu
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Visual
opt.conceallevel = 0
opt.showbreak = "↪ "

-- Mouse
opt.mouse = "a"

-- Line length guide. It is off. Remove the comment marks to show it.
-- opt.colorcolumn = "80"

-- Folds use treesitter. All folds are open when you open a file.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldenable = false
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Spell check
opt.spelllang = "en_us"
opt.spell = false

-- Shorter messages
opt.shortmess:append("c")
opt.shortmess:append("I")

-- Show whitespace characters
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹",
}

-- Fill characters
opt.fillchars = {
  eob = " ",
  diff = "╱",
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
}

-- Command line completion
opt.wildignorecase = true
opt.wildmode = "longest:full,full"
opt.wildmenu = true

-- Diff
opt.diffopt:append("algorithm:histogram")
opt.diffopt:append("indent-heuristic")
opt.diffopt:append("linematch:60")

-- Sessions
opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"

-- Use ripgrep for :grep if it is installed.
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Visual block mode can move the cursor past the end of the line.
opt.virtualedit = "block"

-- Format options
opt.formatoptions = "jcroqlnt"

-- Ask before you quit with changes that are not saved.
opt.confirm = true

-- Keep the view when you jump.
opt.jumpoptions = "view"

-- Show a live preview of :substitute in a split.
opt.inccommand = "split"

-- Read .nvim.lua from the project folder. Neovim asks you to trust each file
-- one time before it runs the file (see :help :trust).
opt.exrc = true

-- Disable netrw. neo-tree is the file explorer.
-- lazy.nvim disables the other built-in plugins (see init.lua).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Providers
vim.g.python3_host_prog = vim.fn.exepath("python3")
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Format on save is on. Use <leader>uf or :FormatToggle to change it.
vim.g.autoformat = true
