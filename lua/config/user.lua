-- Personal settings from lua/config/local.lua.
-- Git ignores local.lua. Thus your settings stay when you update nananvim.
-- See lua/config/local.example.lua for all the fields.

local M = {}

local path = vim.fn.stdpath("config") .. "/lua/config/local.lua"

-- True when lua/config/local.lua exists.
M.exists = vim.fn.filereadable(path) == 1

-- The table that local.lua returns. It is empty when the file does not exist.
M.settings = {}

if M.exists then
  local ok, result = pcall(require, "config.local")
  if not ok then
    vim.schedule(function()
      vim.notify("lua/config/local.lua has an error:\n" .. tostring(result), vim.log.levels.ERROR)
    end)
  elseif type(result) == "table" then
    M.settings = result
  end
end

-- AI is on when local.lua exists, unless local.lua sets ai = false.
M.ai = M.exists and M.settings.ai ~= false

-- Inline AI suggestions: "windsurf" (default), "copilot" or false (none).
M.suggestions = false
if M.ai then
  if M.settings.suggestions == nil then
    M.suggestions = "windsurf"
  else
    M.suggestions = M.settings.suggestions
  end
end

return M
