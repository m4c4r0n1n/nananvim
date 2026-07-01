-- Custom user commands

vim.api.nvim_create_user_command("TokenCount", function()
  if vim.fn.executable("python3") ~= 1 then
    vim.notify("TokenCount: python3 not found", vim.log.levels.ERROR)
    return
  end

  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  -- Note: cl100k_base is OpenAI's encoding. Anthropic doesn't publish a local
  -- tokenizer, so this is a rough estimate, not an exact Claude token count.
  local script = [[
import sys
try:
    import tiktoken
except ModuleNotFoundError:
    sys.exit(2)
enc = tiktoken.get_encoding("cl100k_base")
print(len(enc.encode(sys.stdin.read())))
]]
  local result = vim.fn.system({ "python3", "-c", script }, text)

  if vim.v.shell_error == 2 then
    vim.notify("TokenCount: python 'tiktoken' not installed (pip install tiktoken)", vim.log.levels.WARN)
    return
  elseif vim.v.shell_error ~= 0 then
    vim.notify("TokenCount failed: " .. vim.trim(result), vim.log.levels.ERROR)
    return
  end

  vim.notify("Tokens (≈ cl100k): " .. vim.trim(result), vim.log.levels.INFO)
end, {})
