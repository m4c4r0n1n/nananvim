-- CI smoke test. Run it with:
--   nvim --headless -c "luafile .github/smoke.lua"
-- The test loads all plugins, opens files and collects errors.
-- It exits with code 1 if it finds an error.

local errors = {}

local function add(msg)
  table.insert(errors, msg)
end

-- Record notifications at the ERROR level.
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if level and level >= vim.log.levels.ERROR then
    add("notify: " .. tostring(msg))
  end
  return notify(msg, level, opts)
end

local function finish()
  local messages = vim.api.nvim_exec2("messages", { output = true }).output
  for line in messages:gmatch("[^\n]+") do
    if line:match("^E%d+:") or line:match("Error") or line:match("stack traceback") then
      add("message: " .. line)
    end
  end
  if #errors > 0 then
    io.stderr:write("SMOKE TEST FAILED\n" .. table.concat(errors, "\n") .. "\n")
    vim.cmd("cquit 1")
  else
    io.stdout:write("SMOKE TEST PASSED\n")
    vim.cmd("quitall!")
  end
end

local function step(fn)
  local ok, err = pcall(fn)
  if not ok then
    add("step: " .. tostring(err))
  end
end

vim.schedule(function()
  -- Headless Neovim has no UIEnter event, thus lazy.nvim does not send VeryLazy.
  if not vim.g.did_very_lazy then
    vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
  end

  step(function()
    local plugins = vim.tbl_keys(require("lazy.core.config").plugins)
    require("lazy").load({ plugins = plugins })
  end)

  local config = vim.fn.stdpath("config")
  step(function()
    vim.cmd.edit(config .. "/init.lua")
  end)
  step(function()
    vim.cmd.edit(config .. "/README.md")
  end)
  step(function()
    vim.cmd("checkhealth nananvim")
  end)

  -- Wait for the autocommands and the LSP servers that start.
  vim.defer_fn(finish, 5000)
end)
