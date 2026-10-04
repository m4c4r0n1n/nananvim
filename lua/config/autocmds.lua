local function augroup(name)
  return vim.api.nvim_create_augroup("nananvim_" .. name, { clear = true })
end

-- Highlight the text that you yank.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Read the file again if a different program changed it.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Make all splits equal when the terminal size changes.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Put the cursor at its last position when you open a file again.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_location"),
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].nananvim_last_loc then
      return
    end
    vim.b[buf].nananvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close help windows and tool windows with q.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, { buffer = event.buf, silent = true, desc = "Close window" })
    end)
  end,
})

-- Turn on wrap and spell check for prose files.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Make the parent folders when you save a file to a new path.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Open "file:line" and "file:line:col" (the format of compiler errors and
-- grep output) at that position. Example: nvim init.lua:12
vim.api.nvim_create_autocmd("BufNewFile", {
  group = augroup("file_line"),
  callback = function(event)
    local name = event.match
    local file, line, col = name:match("^(.-):(%d+):?(%d*):?$")
    if not file or vim.uv.fs_stat(name) or not vim.uv.fs_stat(file) then
      return
    end
    local bad_buf = event.buf
    vim.schedule(function()
      vim.cmd.edit(vim.fn.fnameescape(file))
      local col_nr = math.max((tonumber(col) or 1) - 1, 0)
      pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(line), col_nr })
      vim.cmd("normal! zz")
      if vim.api.nvim_buf_is_valid(bad_buf) then
        vim.api.nvim_buf_delete(bad_buf, { force = true })
      end
    end)
  end,
})

-- Background modes (normal, blackout, transparent) belong to
-- theme-switcher.nvim. It sets the mode again after each colorscheme change.
-- Use <leader>tb to change the mode.
