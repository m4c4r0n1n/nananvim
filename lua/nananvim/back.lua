local M = {}

local stack = {}
local waiting = nil

function M.mark(reopen)
  waiting = { reopen = reopen }
end

function M.setup()
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("nananvim_back", { clear = true }),
    callback = function(args)
      if waiting and vim.bo[args.buf].buftype == "" and vim.api.nvim_buf_get_name(args.buf) ~= "" then
        waiting.buf = args.buf
        table.insert(stack, waiting)
        waiting = nil
      end
    end,
  })
  vim.keymap.set("n", "<BS>", M.back, { desc = "Go back" })
end

function M.back()
  local current = vim.api.nvim_get_current_buf()
  local top = stack[#stack]
  if top and top.buf == current then
    table.remove(stack)
    return top.reopen()
  end
  local previous = vim.fn.bufnr("#")
  if previous > 0 and previous ~= current and vim.fn.buflisted(previous) == 1 then
    return vim.cmd.buffer(previous)
  end
  if vim.bo.filetype ~= "snacks_dashboard" then
    Snacks.dashboard()
  end
end

return M
