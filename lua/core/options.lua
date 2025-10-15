-- ~/.config/nvim/lua/core/options.lua

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

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

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Disable swap files
opt.swapfile = false
opt.backup = false

-- Undo
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Scrolloff
opt.scrolloff = 8
opt.sidescrolloff = 8

-- File encoding
opt.fileencoding = "utf-8"

-- Command line
opt.cmdheight = 1
opt.showcmd = true
opt.showmode = false

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Visual
opt.conceallevel = 0
opt.pumheight = 10

-- Mouse
opt.mouse = "a"

-- Line length indicator
opt.colorcolumn = "80"

-- Folding (using treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false

-- Spelling
opt.spelllang = "en_us"
opt.spell = false

-- Shorter messages
opt.shortmess:append("c")

-- Better whitespace display
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Fill characters
opt.fillchars = {
  eob = " ",
}

-- Case insensitive completion
opt.wildignorecase = true

-- Better diff
opt.diffopt:append("algorithm:patience")
opt.diffopt:append("indent-heuristic")

-- Session options
opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"

-- Grep program
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Virtual edit
opt.virtualedit = "block"

-- Formatting
opt.formatoptions = "jcroqlnt"
