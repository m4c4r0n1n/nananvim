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
-- The endpoint is free and no model reads the text. But the text goes to the
-- Anthropic API, thus do not count text that must stay on this computer.
local function claude_count(text, model, api_key)
  if vim.fn.executable("curl") ~= 1 then
    notify("curl not found", vim.log.levels.ERROR)
    return
  end
  local body = vim.json.encode({
    model = model,
    messages = { { role = "user", content = text } },
  })
  -- Other programs can read the curl arguments (ps). Thus the API key goes to
  -- curl on stdin, and the body goes in a file in the private Neovim temp folder.
  local body_file = vim.fn.tempname()
  local f = assert(io.open(body_file, "wb"))
  f:write(body)
  f:close()
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
    "@-",
    "--data-binary",
    "@" .. body_file,
  }
  vim.system(cmd, { stdin = "x-api-key: " .. api_key .. "\n", text = true }, function(res)
    os.remove(body_file)
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
-- Get the newest nananvim with git (fetch, then reset to GitHub), then install the tested plugin versions
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

  local function git(...)
    local r = vim.system({ "git", "-C", dir, ... }, { text = true }):wait()
    return r.code == 0, vim.trim(r.stdout or ""), vim.trim(r.stderr or "")
  end
  -- Where GitHub was before this update. Its commits are not yours (see below).
  local _, before = git("rev-parse", "@{u}")

  say("Updating nananvim...")
  vim.system({ "git", "-C", dir, "fetch", "--quiet" }, { text = true }, function(res)
    if res.code ~= 0 then
      say("git fetch failed:\n" .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
      return
    end
    vim.schedule(function()
      -- Commits that you made in this clone are not on GitHub. Do not remove them.
      -- A commit that GitHub had before (also before a history change) is not
      -- yours. The reflog of the remote branch has each commit that it pointed to.
      local seen = { "@{u}", before }
      local _, ref = git("rev-parse", "--symbolic-full-name", "@{u}")
      local _, log = git("rev-parse", "--git-path", "logs/" .. ref)
      if log ~= "" and not log:find("^/") then
        log = dir .. "/" .. log
      end
      if vim.uv.fs_stat(log) then
        for line in io.lines(log) do
          local old_sha, new_sha = line:match("^(%x+) (%x+)")
          if old_sha then
            table.insert(seen, old_sha)
            table.insert(seen, new_sha)
          end
        end
      end
      -- Keep only commits that this clone has. rev-list stops on an unknown one.
      seen = vim.tbl_filter(function(c)
        return c ~= "" and not c:match("^0+$") and (git("cat-file", "-e", c .. "^{commit}"))
      end, seen)
      local ok, ahead, err = git("rev-list", "--count", "HEAD", "--not", unpack(seen))
      if not ok then
        say("Could not compare with GitHub:\n" .. err, vim.log.levels.ERROR)
        return
      end
      if tonumber(ahead) > 0 then
        say(
          "This clone has " .. ahead .. " commit(s) that are not on GitHub, thus the update stopped.",
          vim.log.levels.WARN
        )
        return
      end
      -- reset --hard also works when the history on GitHub changed. It is safe here:
      -- changed files stopped the update above, and git ignores local.lua.
      local _, old = git("rev-parse", "--short", "HEAD")
      local reset_ok, _, reset_err = git("reset", "--hard", "--quiet", "@{u}")
      if not reset_ok then
        say("git reset failed:\n" .. reset_err, vim.log.levels.ERROR)
        return
      end
      local _, new = git("rev-parse", "--short", "HEAD")
      vim.notify(
        old == new and "nananvim is already up to date" or ("nananvim updated: " .. old .. " to " .. new),
        vim.log.levels.INFO,
        { title = "nananvim" }
      )
      require("lazy").restore({ show = true })
      vim.notify("Done. Run :restart to load the new config.", vim.log.levels.INFO, { title = "nananvim" })
    end)
  end)
end, { desc = "Update nananvim and its plugins" })
