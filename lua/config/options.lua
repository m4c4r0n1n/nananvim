-- ~/.config/nvim/lua/core/options.lua

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true

-- Line wrapping
opt.wrap = false
opt.linebreak = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Transparency (works with terminals that support it)
opt.pumblend = 10
opt.winblend = 0

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

-- Disable swap files
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Undo
opt.undofile = true
opt.undolevels = 10000
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Performance
opt.updatetime = 200
opt.timeoutlen = 300
opt.redrawtime = 10000

-- Scrolling
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

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Visual
opt.conceallevel = 0
opt.showbreak = "↪ "

-- Mouse
opt.mouse = "a"

-- Line length indicator (off by default, uncomment if you want it)
-- opt.colorcolumn = "80"

-- Folding (using treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Spelling
opt.spelllang = "en_us"
opt.spell = false

-- Shorter messages
opt.shortmess:append("c")
opt.shortmess:append("I")

-- Better whitespace display
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹"
}

-- Fill characters
opt.fillchars = {
  eob = " ",
  diff = "╱",
}

-- Case insensitive completion
opt.wildignorecase = true
opt.wildmode = "longest:full,full"

-- Better diff
opt.diffopt:append("algorithm:patience")
opt.diffopt:append("indent-heuristic")
opt.diffopt:append("linematch:60")

-- Session options
opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"

-- Grep program
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Virtual edit
opt.virtualedit = "block"

-- Formatting
opt.formatoptions = "jcroqlnt"

-- Confirm before quitting with unsaved changes
opt.confirm = true

-- Better completion experience
opt.wildmenu = true

-- Hide command line when not in use
opt.cmdheight = 1

-- Preserve cursor position
opt.jumpoptions = "view"

-- Better splitting
opt.inccommand = "split"

-- Disable some builtin plugins
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Fix for Ubuntu/Pop!_OS LSP issues
vim.g.python3_host_prog = vim.fn.exepath("python3")
