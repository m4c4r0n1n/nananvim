local keymap = vim.keymap.set

-- Set the leader key. Do this before lazy.nvim loads the plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Move up and down by display lines when a line wraps.
-- A count (for example 5j) still moves by real lines.
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Move between windows
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
keymap("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Indent and keep the selection
keymap("x", "<", "<gv", { desc = "Indent left" })
keymap("x", ">", ">gv", { desc = "Indent right" })

-- Move lines
keymap("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
keymap("x", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move selection down" })
keymap("x", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move selection up" })

-- Keep the search result in the center of the screen.
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Keep the cursor in the center when you scroll half a page.
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- Join lines and keep the cursor where it is.
keymap("n", "J", "mzJ`z", { desc = "Join lines" })

-- Undo in small steps: each , . ; starts a new undo step in insert mode.
keymap("i", ",", ",<C-g>u")
keymap("i", ".", ".<C-g>u")
keymap("i", ";", ";<C-g>u")

-- Add a comment line below or above the cursor.
keymap("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })
keymap("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })

-- Splits
keymap("n", "<leader>-", "<C-w>s", { desc = "Split below" })
keymap("n", "<leader>|", "<C-w>v", { desc = "Split right" })

-- Paste over a selection and keep the old register.
keymap("x", "<leader>P", [["_dP]], { desc = "Paste and keep register" })

-- Clear the search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Save the file
keymap({ "n", "i", "x" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "Save file" })

-- Quit
keymap("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>quitall<cr>", { desc = "Quit all" })

-- Diagnostics
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

local function diagnostic_jump(count, severity)
  return function()
    vim.diagnostic.jump({ count = count, severity = severity, float = true })
  end
end
local severity = vim.diagnostic.severity
keymap("n", "]e", diagnostic_jump(1, severity.ERROR), { desc = "Next error" })
keymap("n", "[e", diagnostic_jump(-1, severity.ERROR), { desc = "Previous error" })
keymap("n", "]w", diagnostic_jump(1, severity.WARN), { desc = "Next warning" })
keymap("n", "[w", diagnostic_jump(-1, severity.WARN), { desc = "Previous warning" })

-- Copy the path of the current file. Use the system clipboard if it is
-- available, else the unnamed register.
local function copy_path(modifier)
  return function()
    local path = vim.fn.expand(modifier)
    vim.fn.setreg(vim.fn.has("clipboard") == 1 and "+" or '"', path)
    vim.notify("Copied: " .. path)
  end
end
keymap("n", "<leader>fy", copy_path("%:."), { desc = "Copy file path (relative)" })
keymap("n", "<leader>fY", copy_path("%:p"), { desc = "Copy file path (absolute)" })

-- Plugin managers
keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy (plugins)" })
keymap("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason (tools)" })

-- Leave terminal mode with two presses of <Esc>.
-- One press of <Esc> stays in the terminal program (for example, in a shell vi mode).
keymap("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Leave terminal mode" })
