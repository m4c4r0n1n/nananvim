-- Custom user commands

vim.api.nvim_create_user_command("TokenCount", function()
  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  local cmd = {
    "python3",
    "-c",
    "import sys, tiktoken; enc = tiktoken.get_encoding('cl100k_base'); print(len(enc.encode(sys.stdin.read())))",
  }
  local result = vim.fn.system(cmd, text)
  print("Tokens: " .. vim.trim(result))
end, {})
