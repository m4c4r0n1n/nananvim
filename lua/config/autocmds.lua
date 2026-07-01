vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Background modes (normal / blackout / transparent) are owned entirely by
-- theme-switcher.nvim, which re-applies them on every colorscheme change.
-- Toggle with <leader>tb.
