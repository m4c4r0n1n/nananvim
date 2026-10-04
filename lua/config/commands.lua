-- Custom user commands

local function notify(msg, level)
  vim.schedule(function()
    vim.notify(msg, level or vim.log.levels.INFO, { title = "TokenCount" })
  end)
end

-- Rough count with tiktoken (cl100k_base). This is the OpenAI tokenizer.
-- It gives fewer tokens than Claude uses. Use it only when no API key is set.
local function tiktoken_estimate(text)
  if vim.fn.executable("python3") ~= 1 then
    notify("python3 not found and ANTHROPIC_API_KEY is not set", vim.log.levels.ERROR)
    return
  end
  local script = [[
import sys
try:
    import tiktoken
except ModuleNotFoundError:
    sys.exit(2)
enc = tiktoken.get_encoding("cl100k_base")
print(len(enc.encode(sys.stdin.read())))
]]
  vim.system({ "python3", "-c", script }, { stdin = text, text = true }, function(res)
    if res.code == 2 then
      notify("Set ANTHROPIC_API_KEY for an exact count, or install tiktoken for an estimate", vim.log.levels.WARN)
    elseif res.code ~= 0 then
      notify("tiktoken failed: " .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
    else
      notify("≈ " .. vim.trim(res.stdout) .. " tokens (OpenAI cl100k estimate, not a Claude count)")
    end
  end)
end

-- Exact Claude count with the Anthropic count_tokens endpoint.
-- The endpoint is free. It does not send the text to a model.
local function claude_count(text, model, api_key)
  if vim.fn.executable("curl") ~= 1 then
    notify("curl not found", vim.log.levels.ERROR)
    return
  end
  local body = vim.json.encode({
    model = model,
    messages = { { role = "user", content = text } },
  })
  local cmd = {
    "curl",
    "--silent",
    "--show-error",
    "https://api.anthropic.com/v1/messages/count_tokens",
    "--header",
    "content-type: application/json",
    "--header",
    "anthropic-version: 2023-06-01",
    "--header",
    "x-api-key: " .. api_key,
    "--data-binary",
    "@-",
  }
  vim.system(cmd, { stdin = body, text = true }, function(res)
    if res.code ~= 0 then
      notify("curl failed: " .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
      return
    end
    local ok, data = pcall(vim.json.decode, res.stdout)
    if ok and type(data) == "table" and data.input_tokens then
      notify(data.input_tokens .. " tokens (" .. model .. ")")
    else
      local msg = ok and type(data) == "table" and data.error and data.error.message or res.stdout
      notify("API error: " .. vim.trim(tostring(msg)), vim.log.levels.ERROR)
    end
  end)
end

-- :TokenCount [model]
-- Count the tokens in the current buffer, or in the selected lines.
vim.api.nvim_create_user_command("TokenCount", function(opts)
  local first, last = 0, -1
  if opts.range > 0 then
    first, last = opts.line1 - 1, opts.line2
  end
  local text = table.concat(vim.api.nvim_buf_get_lines(0, first, last, false), "\n")
  if text == "" then
    notify("Buffer is empty", vim.log.levels.WARN)
    return
  end
  local api_key = vim.env.ANTHROPIC_API_KEY
  if api_key and api_key ~= "" then
    local model = opts.args ~= "" and opts.args or "claude-opus-5-5"
    claude_count(text, model, api_key)
  else
    tiktoken_estimate(text)
  end
end, { nargs = "?", range = true, desc = "Count tokens in the buffer or the selection" })

-- :FormatToggle[!]
-- Turn format on save on or off. Use ! to change it for the current buffer only.
vim.api.nvim_create_user_command("FormatToggle", function(opts)
  if opts.bang then
    local current = vim.b.autoformat
    if current == nil then
      current = vim.g.autoformat
    end
    vim.b.autoformat = not current
    vim.notify("Format on save (buffer): " .. (vim.b.autoformat and "on" or "off"))
  else
    vim.g.autoformat = not vim.g.autoformat
    vim.b.autoformat = nil
    vim.notify("Format on save (global): " .. (vim.g.autoformat and "on" or "off"))
  end
end, { bang = true, desc = "Toggle format on save" })

-- :NananvimUpdate
-- Get the newest nananvim with git, then install the tested plugin versions
-- from lazy-lock.json. Your lua/config/local.lua is not changed (git ignores it).
vim.api.nvim_create_user_command("NananvimUpdate", function()
  local dir = vim.fn.stdpath("config")
  local function say(msg, level)
    vim.schedule(function()
      vim.notify(msg, level or vim.log.levels.INFO, { title = "nananvim" })
    end)
  end

  local status = vim
    .system({ "git", "-C", dir, "status", "--porcelain", "--untracked-files=no" }, { text = true })
    :wait()
  if status.code ~= 0 then
    say("The config folder is not a git clone:\n" .. dir, vim.log.levels.ERROR)
    return
  end

  -- A change to lazy-lock.json comes from :Lazy update. The update replaces it
  -- with the tested versions. Changes to other files stop the update.
  local changed = {}
  for line in status.stdout:gmatch("[^\n]+") do
    local file = line:sub(4)
    if file ~= "lazy-lock.json" then
      table.insert(changed, file)
    end
  end
  if #changed > 0 then
    say(
      "You changed these files, thus the update stopped:\n  "
        .. table.concat(changed, "\n  ")
        .. "\nMove your changes to lua/config/local.lua, or run git stash, then try again.",
      vim.log.levels.WARN
    )
    return
  end
  vim.system({ "git", "-C", dir, "checkout", "--", "lazy-lock.json" }):wait()

  say("Updating nananvim...")
  vim.system({ "git", "-C", dir, "pull", "--ff-only" }, { text = true }, function(res)
    if res.code ~= 0 then
      say("git pull failed:\n" .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
      return
    end
    say(vim.trim(res.stdout))
    vim.schedule(function()
      require("lazy").restore({ show = true })
      vim.notify("Done. Run :restart to load the new config.", vim.log.levels.INFO, { title = "nananvim" })
    end)
  end)
end, { desc = "Update nananvim and its plugins" })
