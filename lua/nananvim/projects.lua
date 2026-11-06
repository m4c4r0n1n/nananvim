local M = {}

local state = { rows = {}, buf = nil, win = nil }

local function roots()
  return vim.g.nananvim_project_roots or { "~", "~/Projects", "~/.config" }
end

local function is_repo(path)
  return vim.uv.fs_stat(path .. "/.git") ~= nil
end

function M.find()
  local found, seen = {}, {}
  local function add(path)
    if not seen[path] and is_repo(path) then
      seen[path] = true
      table.insert(found, path)
    end
  end
  for _, root in ipairs(roots()) do
    local dir = vim.fn.expand(root)
    add(dir)
    for name, kind in vim.fs.dir(dir) do
      if kind == "directory" and name ~= ".git" then
        add(dir .. "/" .. name)
      end
    end
  end
  table.sort(found, function(a, b)
    return vim.fs.basename(a):lower() < vim.fs.basename(b):lower()
  end)
  return found
end

function M.status_cmd(path)
  return { "git", "-C", path, "status", "--porcelain=v2", "--branch" }
end

function M.parse(path, result)
  local row = { path = path, name = vim.fs.basename(path), branch = "?", ahead = 0, behind = 0, changed = 0, upstream = false }
  if result.code ~= 0 then
    row.broken = true
    return row
  end
  for line in vim.gsplit(result.stdout, "\n", { trimempty = true }) do
    local head = line:match("^# branch%.head (.+)$")
    local ahead, behind = line:match("^# branch%.ab %+(%d+) %-(%d+)$")
    if head then
      row.branch = head
    elseif line:match("^# branch%.upstream ") then
      row.upstream = true
    elseif ahead then
      row.ahead, row.behind = tonumber(ahead), tonumber(behind)
    elseif not line:match("^#") then
      row.changed = row.changed + 1
    end
  end
  return row
end

function M.status(path)
  return M.parse(path, vim.system(M.status_cmd(path), { text = true }):wait())
end

function M.describe(row)
  if row.broken then
    return "unreadable"
  end
  local parts = {}
  if row.changed > 0 then
    table.insert(parts, row.changed .. " changed")
  end
  if row.ahead > 0 then
    table.insert(parts, "↑" .. row.ahead)
  end
  if row.behind > 0 then
    table.insert(parts, "↓" .. row.behind)
  end
  if not row.upstream then
    table.insert(parts, "no upstream")
  end
  return #parts > 0 and table.concat(parts, "  ") or "clean"
end

function M.lines(rows)
  local name_w, branch_w = 4, 6
  for _, row in ipairs(rows) do
    name_w = math.max(name_w, vim.fn.strdisplaywidth(row.name))
    branch_w = math.max(branch_w, vim.fn.strdisplaywidth(row.branch))
  end
  local out = {}
  for _, row in ipairs(rows) do
    local name = row.name .. string.rep(" ", name_w - vim.fn.strdisplaywidth(row.name))
    local branch = row.branch .. string.rep(" ", branch_w - vim.fn.strdisplaywidth(row.branch))
    table.insert(out, string.format(" %s   %s   %s", name, branch, M.describe(row)))
  end
  return out
end

local function draw()
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    return
  end
  state.rows = vim.tbl_map(M.status, M.find())
  local lines = M.lines(state.rows)
  if #lines == 0 then
    lines = { " No repositories found" }
  end
  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
  for i, row in ipairs(state.rows) do
    local dirty = row.changed > 0 or row.ahead > 0 or row.behind > 0 or not row.upstream
    vim.hl.range(state.buf, M.ns, dirty and "DiagnosticWarn" or "DiagnosticOk", { i - 1, 0 }, { i - 1, -1 })
  end
end

local function current()
  return state.rows[vim.api.nvim_win_get_cursor(state.win)[1]]
end

local function run(row, args, label)
  vim.notify(label .. " " .. row.name)
  vim.system(vim.list_extend({ "git", "-C", row.path }, args), { text = true }, vim.schedule_wrap(function(result)
    if result.code == 0 then
      vim.notify(label .. " done: " .. row.name)
    else
      vim.notify(result.stderr, vim.log.levels.ERROR, { title = label .. " failed: " .. row.name })
    end
    draw()
    vim.api.nvim_exec_autocmds("User", { pattern = "NananvimProjectsChanged", modeline = false })
  end))
end

local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
end

local actions = {
  ["<cr>"] = function(row)
    close()
    Snacks.lazygit({ cwd = row.path })
  end,
  d = function(row)
    close()
    vim.cmd.tabnew()
    vim.cmd.tcd(vim.fn.fnameescape(row.path))
    vim.cmd("DiffviewOpen")
  end,
  p = function(row)
    local args = row.upstream and { "push" } or { "push", "-u", "origin", "HEAD" }
    if vim.fn.confirm("Push " .. row.name .. " (" .. row.branch .. ")?", "&Yes\n&No", 2) == 1 then
      run(row, args, "Push")
    end
  end,
  f = function(row)
    run(row, { "fetch", "--all", "--prune" }, "Fetch")
  end,
  u = function(row)
    run(row, { "pull", "--ff-only" }, "Pull")
  end,
}

M.actions = actions

function M.open()
  M.ns = M.ns or vim.api.nvim_create_namespace("nananvim_projects")
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[state.buf].bufhidden = "wipe"
  local width = math.min(90, vim.o.columns - 6)
  local height = math.min(20, vim.o.lines - 8)
  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Projects ",
    title_pos = "center",
    footer = " <cr> lazygit  d diff  p push  u pull  f fetch  r refresh  q close ",
    footer_pos = "center",
  })
  vim.wo[state.win].cursorline = true
  draw()
  local function map(key, fn)
    vim.keymap.set("n", key, fn, { buffer = state.buf, nowait = true })
  end
  for key, action in pairs(actions) do
    map(key, function()
      local row = current()
      if row then
        action(row)
      end
    end)
  end
  map("r", draw)
  map("q", close)
  map("<esc>", close)
end

return M
