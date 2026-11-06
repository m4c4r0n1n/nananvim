local projects = require("nananvim.projects")

local M = {}

local CELL = "■"
local GRAPH_MAX_AGE = 3600
local LABEL_WIDTH = 4
local WIDE_CELLS = 170
local GRAPH_HEIGHT = 9
local PROJECTS_HEIGHT = 12
local PREVIEW_HEIGHT = 34
local WIDTH_SHARE = 0.62
local MIN_WIDTH = 64
local MIN_GRAPH_LINES = 36
local MIN_CONTRAST = 3
local MAX_FILE_SIZE = 1048576
local MAX_FILE_LINES = 400
local ACCENTS = { "String", "Function", "Keyword", "Special", "Type", "Title", "DiagnosticOk" }
local LEVELS = { NONE = 0, FIRST_QUARTILE = 1, SECOND_QUARTILE = 2, THIRD_QUARTILE = 3, FOURTH_QUARTILE = 4 }
local MONTHS = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
local DAYS = { [2] = "Mon", [4] = "Wed", [6] = "Fri" }
local QUERY = "{viewer{login contributionsCollection{contributionCalendar{totalContributions "
  .. "weeks{contributionDays{date weekday contributionLevel}}}}}}"
local FIELDS = "name,nameWithOwner,description,url,isPrivate,isFork,pushedAt"
local ACTION_HINTS = " enter open  a changed only  d diff  G git  p push  u pull  F fetch "
local MOVE_HINTS = " tab panes  1 2 3 jump  n N change  J K scroll  q close "

local state = {
  graph_win = -1,
  win = -1,
  files_win = -1,
  before_win = -1,
  diff_win = -1,
  back_win = -1,
  login = "",
  repos = {},
  graph = nil,
  fetched = 0,
  rows = {},
  clones = {},
  first = 0,
  token = 0,
}

local function cache_path()
  return vim.fn.stdpath("cache") .. "/nananvim_github.json"
end

local function load_cache()
  local file = io.open(cache_path(), "r")
  if not file then
    return
  end
  local text = file:read("*a")
  file:close()
  local ok, data = pcall(vim.json.decode, text, { luanil = { object = true, array = true } })
  if ok and type(data) == "table" then
    state.login = data.login or ""
    state.repos = data.repos or {}
    state.graph = data.graph
    state.fetched = data.fetched or 0
  end
end

local function save_cache()
  local file = io.open(cache_path(), "w")
  if file then
    file:write(vim.json.encode({
      login = state.login,
      repos = state.repos,
      graph = state.graph,
      fetched = state.fetched,
    }))
    file:close()
  end
end

local function channels(color)
  return bit.band(bit.rshift(color, 16), 255), bit.band(bit.rshift(color, 8), 255), bit.band(color, 255)
end

local function mix(color, back, amount)
  local red, green, blue = channels(color)
  local base_red, base_green, base_blue = channels(back)
  return bit.lshift(math.floor(base_red + (red - base_red) * amount), 16)
    + bit.lshift(math.floor(base_green + (green - base_green) * amount), 8)
    + math.floor(base_blue + (blue - base_blue) * amount)
end

local function luminance(color)
  local red, green, blue = channels(color)
  local function linear(value)
    value = value / 255
    return value <= 0.03928 and value / 12.92 or ((value + 0.055) / 1.055) ^ 2.4
  end
  return 0.2126 * linear(red) + 0.7152 * linear(green) + 0.0722 * linear(blue)
end

local function contrast(first, second)
  local high = math.max(luminance(first), luminance(second))
  local low = math.min(luminance(first), luminance(second))
  return (high + 0.05) / (low + 0.05)
end

local function accent(back, text)
  local best, score = text, 0
  for _, name in ipairs(ACCENTS) do
    local color = vim.api.nvim_get_hl(0, { name = name, link = false }).fg
    if color and contrast(color, back) >= MIN_CONTRAST then
      local red, green, blue = channels(color)
      local value = (math.max(red, green, blue) - math.min(red, green, blue)) / 255 + contrast(color, back) / 21
      if value > score then
        best, score = color, value
      end
    end
  end
  return best
end

local function set_highlights()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local back = normal.bg or 0
  local neutral = luminance(back) > 0.4 and 0 or 0xffffff
  local text = normal.fg and contrast(normal.fg, back) >= MIN_CONTRAST and normal.fg or neutral
  local color = accent(back, text)
  local function tone(names, channel, fallback)
    for _, name in ipairs(names) do
      local color = vim.api.nvim_get_hl(0, { name = name, link = false }).fg
      if color then
        local parts = { channels(color) }
        if parts[channel] > 1.3 * math.max(parts[channel % 3 + 1], parts[(channel + 1) % 3 + 1]) then
          return color
        end
      end
    end
    return fallback
  end
  local good = tone({ "GitSignsAdd", "DiagnosticOk", "String" }, 2, 0x3fb950)
  local bad = tone({ "GitSignsDelete", "DiagnosticError" }, 1, 0xf85149)
  vim.api.nvim_set_hl(0, "NananvimOld", { bg = mix(bad, back, 0.3) })
  vim.api.nvim_set_hl(0, "NananvimOldText", { bg = mix(bad, back, 0.6) })
  vim.api.nvim_set_hl(0, "NananvimNew", { bg = mix(good, back, 0.3) })
  vim.api.nvim_set_hl(0, "NananvimNewText", { bg = mix(good, back, 0.6) })
  vim.api.nvim_set_hl(0, "NananvimFill", { fg = mix(neutral, back, 0.2) })
  vim.api.nvim_set_hl(0, "NananvimGraph0", { fg = mix(neutral, back, 0.13) })
  for level, amount in ipairs({ 0.6, 0.73, 0.87, 1 }) do
    vim.api.nvim_set_hl(0, "NananvimGraph" .. level, { fg = mix(color, back, amount) })
  end
end

local function valid()
  return state.buf and vim.api.nvim_buf_is_valid(state.buf) and state.win and vim.api.nvim_win_is_valid(state.win)
end

local function slug(url)
  local path = url and url:match("github%.com[:/](.+)$")
  return path and path:gsub("%.git$", ""):gsub("/$", ""):lower()
end

local function merge()
  state.rows = {}
  for _, repo in ipairs(state.repos) do
    local clone = state.clones[repo.nameWithOwner:lower()]
    table.insert(state.rows, { repo = repo, path = clone and clone.path, status = clone })
  end
end

local function selected()
  if not valid() or state.first == 0 then
    return nil
  end
  return state.rows[vim.api.nvim_win_get_cursor(state.win)[1] - state.first + 1]
end

local function pad(text, width)
  return text .. string.rep(" ", math.max(0, width - vim.fn.strdisplaywidth(text)))
end

local function cell_width()
  return vim.o.columns >= WIDE_CELLS and 2 or 1
end

local function month_line(weeks, cell)
  local line, last = string.rep(" ", LABEL_WIDTH), nil
  for index, week in ipairs(weeks) do
    local month = tonumber(week.month:sub(6, 7))
    if month ~= last then
      local column = LABEL_WIDTH + (index - 1) * cell
      if column >= #line then
        line = pad(line, column) .. MONTHS[month]
      end
      last = month
    end
  end
  return { { line, "Comment" } }
end

local function graph_lines(width)
  local graph = state.graph
  if not graph then
    return { { { "No commit graph data. Run gh auth login.", "Comment" } } }
  end
  local cell = cell_width()
  local count = math.min(#graph.weeks, math.floor((width - LABEL_WIDTH) / cell))
  local weeks = vim.list_slice(graph.weeks, #graph.weeks - count + 1)
  local lines = { month_line(weeks, cell) }
  for day = 1, 7 do
    local line = { { pad(DAYS[day] or "", LABEL_WIDTH), "Comment" } }
    for _, week in ipairs(weeks) do
      local level = week.days:sub(day, day)
      if level == " " then
        table.insert(line, { string.rep(" ", cell) })
      else
        table.insert(line, { CELL .. string.rep(" ", cell - 1), "NananvimGraph" .. level })
      end
    end
    table.insert(lines, line)
  end
  table.insert(lines, { { graph.total .. " contributions in the last year", "Comment" } })
  return lines
end

local function project_line(row, name_width)
  local line = { { pad(row.repo.name, name_width + 2), "Title" } }
  table.insert(line, { pad(row.repo.isPrivate and "private" or "public", 9), "Comment" })
  local status = row.status
  if not status then
    table.insert(line, { "not cloned", "Comment" })
    return line
  end
  local dirty = status.broken or status.changed > 0 or status.ahead > 0 or status.behind > 0 or not status.upstream
  table.insert(line, { pad(status.branch, 10), "Function" })
  table.insert(line, { projects.describe(status), dirty and "DiagnosticWarn" or "DiagnosticOk" })
  return line
end

local function render(buf, out)
  local lines, marks = {}, {}
  for index, line in ipairs(out) do
    local text = ""
    for _, part in ipairs(line) do
      if part[2] then
        table.insert(marks, { index - 1, #text, #text + #part[1], part[2] })
      end
      text = text .. part[1]
    end
    lines[index] = text
  end
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  state.ns = state.ns or vim.api.nvim_create_namespace("nananvim_github")
  vim.api.nvim_buf_clear_namespace(buf, state.ns, 0, -1)
  for _, mark in ipairs(marks) do
    vim.api.nvim_buf_set_extmark(buf, state.ns, mark[1], mark[2], { end_col = mark[3], hl_group = mark[4] })
  end
end

local function place()
  local graph = vim.api.nvim_win_is_valid(state.graph_win)
  local graph_width = LABEL_WIDTH + 53 * cell_width() + 2
  local wanted = math.max(MIN_WIDTH, graph_width, math.floor(vim.o.columns * WIDTH_SHARE))
  local width = math.min(vim.o.columns - 4, wanted)
  local projects_height = math.max(1, math.min(#state.rows, PROJECTS_HEIGHT))
  local upper = (graph and GRAPH_HEIGHT + 2 or 0) + projects_height + 2
  local preview_height = math.max(3, math.min(PREVIEW_HEIGHT, vim.o.lines - 3 - upper - 2))
  local total = upper + preview_height + 2
  local top = math.max(0, math.floor((vim.o.lines - total) / 2) - 1)
  local left = math.floor((vim.o.columns - width - 2) / 2)
  local function set(win, height, offset, size)
    vim.api.nvim_win_set_config(win, {
      relative = "editor",
      row = top,
      col = left + (offset or 0),
      width = size or width,
      height = height,
    })
  end
  if graph then
    set(state.graph_win, GRAPH_HEIGHT)
    top = top + GRAPH_HEIGHT + 2
  end
  local projects_width = math.floor(width * 0.6)
  set(state.win, projects_height, 0, projects_width)
  set(state.files_win, projects_height, projects_width + 2, width - projects_width - 2)
  top = top + projects_height + 2
  local before_width = math.floor((width - 2) / 2)
  set(state.before_win, preview_height, 0, before_width)
  set(state.diff_win, preview_height, before_width + 2, width - before_width - 2)
end

local function draw_graph()
  if not vim.api.nvim_win_is_valid(state.graph_win) then
    return
  end
  vim.api.nvim_win_set_config(state.graph_win, { title = " GitHub " .. state.login .. " " })
  local width = vim.api.nvim_win_get_width(state.graph_win)
  local lines = graph_lines(width - 2)
  local shift = math.max(0, math.floor((width - (LABEL_WIDTH + 53 * cell_width())) / 2))
  for _, line in ipairs(lines) do
    table.insert(line, 1, { string.rep(" ", shift) })
  end
  render(state.graph_buf, lines)
end

local function draw()
  if not valid() then
    return
  end
  place()
  draw_graph()
  local name = selected()
  name = name and name.repo.name
  local out = {}
  state.first = 1
  local name_width = 4
  for _, row in ipairs(state.rows) do
    name_width = math.max(name_width, vim.fn.strdisplaywidth(row.repo.name))
  end
  local target = state.first
  for index, row in ipairs(state.rows) do
    table.insert(out, project_line(row, name_width))
    if row.repo.name == name then
      target = state.first + index - 1
    end
  end
  if #state.rows == 0 then
    table.insert(out, { { state.message or "Loading projects", "Comment" } })
  end
  render(state.buf, out)
  vim.api.nvim_win_set_config(state.win, { title = state.stale and " Projects (not updated) " or " Projects " })
  vim.api.nvim_win_set_cursor(state.win, { target, 0 })
end

local function fill(buf, lines)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
  end
end

local function diff_mode(enabled)
  for _, win in ipairs({ state.before_win, state.diff_win }) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_call(win, function()
        vim.cmd(enabled and "diffthis" or "diffoff")
      end)
      vim.wo[win][0].wrap = false
      vim.wo[win][0].foldcolumn = "0"
      vim.wo[win][0].number = enabled
      if not enabled then
        vim.wo[win][0].foldenable = false
      end
    end
  end
end

local function show(before, after, options)
  options = options or {}
  local text = table.concat(before, "\n") .. "\0" .. table.concat(after, "\n")
  if text == state.shown then
    return
  end
  state.shown = text
  state.first_change = 1
  diff_mode(false)
  fill(state.before_buf, before)
  fill(state.diff_buf, after)
  local syntax = options.syntax or ""
  local syntaxes = { [state.before_buf] = options.diff and syntax or "", [state.diff_buf] = syntax }
  for buf, value in pairs(syntaxes) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].syntax ~= value then
      vim.bo[buf].syntax = value
    end
  end
  if options.diff then
    vim.api.nvim_win_set_cursor(state.before_win, { 1, 0 })
    vim.api.nvim_win_set_cursor(state.diff_win, { 1, 0 })
    diff_mode(true)
    vim.api.nvim_win_call(state.diff_win, function()
      vim.cmd.diffupdate()
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      if vim.fn.diff_hlID(1, 1) == 0 then
        pcall(vim.cmd.normal, { "]c", bang = true })
      end
      state.first_change = vim.api.nvim_win_get_cursor(0)[1]
    end)
  elseif vim.api.nvim_win_is_valid(state.diff_win) then
    vim.api.nvim_win_set_cursor(state.diff_win, { 1, 0 })
  end
end

local function split_lines(text)
  return vim.split(vim.trim(text or ""), "\n", { plain = true, trimempty = true })
end

local function files_title()
  local project = state.project
  if not project then
    return " Files "
  end
  local status, parts = project.status, {}
  if status.changed > 0 then
    table.insert(parts, status.changed .. " changed")
  end
  if status.ahead > 0 then
    table.insert(parts, "↑" .. status.ahead)
  end
  if status.behind > 0 then
    table.insert(parts, "↓" .. status.behind)
  end
  if project.upstream == "" then
    table.insert(parts, "no upstream")
  elseif #parts == 0 then
    table.insert(parts, "no changes")
  end
  return " Files  " .. table.concat(parts, "  ") .. " "
end

local function show_entries(keep)
  local out = {}
  local kinds = { M = "DiagnosticWarn", A = "DiagnosticOk", D = "DiagnosticError", R = "DiagnosticWarn" }
  for _, entry in ipairs(state.entries) do
    local line = { { entry.kind .. " ", kinds[entry.kind] or "Comment" }, { entry.file } }
    if entry.note then
      table.insert(line, { "  " .. entry.note, "Comment" })
    end
    table.insert(out, line)
  end
  if #out == 0 then
    table.insert(out, { { state.project and "No changes" or "Not cloned", "Comment" } })
  end
  render(state.files_buf, out)
  if vim.api.nvim_win_is_valid(state.files_win) then
    vim.api.nvim_win_set_config(state.files_win, { title = files_title(), title_pos = "center" })
  end
  local line = 1
  for index, entry in ipairs(state.entries) do
    if entry.file == keep then
      line = index
    end
  end
  if vim.api.nvim_win_is_valid(state.files_win) then
    vim.api.nvim_win_set_cursor(state.files_win, { line, 0 })
  end
end

local function current_entry()
  if not vim.api.nvim_win_is_valid(state.files_win) then
    return nil
  end
  return state.entries[vim.api.nvim_win_get_cursor(state.files_win)[1]]
end

local function summary_lines(project)
  local out = {}
  local against = project.upstream ~= "" and (project.status.branch .. " against " .. project.upstream)
    or "no upstream branch"
  table.insert(out, against)
  table.insert(out, "")
  if #project.local_only > 0 then
    table.insert(out, "Commits only in local")
    vim.list_extend(out, project.local_only)
  end
  if #project.branch_only > 0 then
    table.insert(out, "Commits only in the branch")
    vim.list_extend(out, project.branch_only)
  end
  local same = #project.local_only + #project.branch_only + project.status.changed == 0
  if project.upstream ~= "" and same then
    table.insert(out, "Local matches the branch")
  end
  return out
end

local function show_summary(project)
  show(summary_lines(project), {})
end

local function text_lines(text)
  if #text > MAX_FILE_SIZE or text:find("%z") then
    return nil
  end
  local lines = vim.split(text, "\n", { plain = true })
  if lines[#lines] == "" then
    table.remove(lines)
  end
  return lines
end

local function read_local(path)
  local stat = vim.uv.fs_stat(path)
  if not stat then
    return {}
  end
  if stat.type ~= "file" or stat.size > MAX_FILE_SIZE then
    return nil
  end
  local file = io.open(path, "rb")
  if not file then
    return nil
  end
  local text = file:read("*a")
  file:close()
  return text_lines(text)
end

local function read_rev(project, rev, file, done)
  vim.system(
    { "git", "-C", project.path, "show", rev .. ":" .. file },
    {},
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        return done({})
      end
      done(text_lines(result.stdout))
    end)
  )
end

local function show_pair(project, entry, token)
  local syntax = vim.filetype.match({ filename = entry.file }) or ""
  local function finish(before, after)
    if token ~= state.file_token then
      return
    end
    if not before or not after then
      return show({ "No preview for this file" }, {})
    end
    show(before, after, { diff = true, syntax = syntax })
  end
  local function load_after(before)
    if entry.right then
      return read_rev(project, entry.right, entry.file, function(after)
        finish(before, after)
      end)
    end
    finish(before, read_local(project.path .. "/" .. entry.file))
  end
  if entry.kind == " " then
    local after = read_local(project.path .. "/" .. entry.file)
    if after then
      local before = vim.list_extend({ "No changes in this file", "" }, summary_lines(project))
      return show(before, after, { syntax = syntax })
    end
    return finish(nil, nil)
  end
  if entry.kind == "?" or entry.kind == "A" then
    return load_after({})
  end
  read_rev(project, project.base, entry.old or entry.file, load_after)
end

local function preview_file()
  state.file_token = (state.file_token or 0) + 1
  local token = state.file_token
  local project = state.project
  if not project then
    return
  end
  local entry = current_entry()
  if not entry then
    return show_summary(project)
  end
  show_pair(project, entry, token)
end

local function build_entries(results)
  local entries, seen = {}, {}
  local unpushed, uncommitted = {}, {}
  for _, file in ipairs(split_lines(results.unpushed)) do
    unpushed[file] = true
  end
  for _, file in ipairs(split_lines(results.uncommitted)) do
    uncommitted[file] = true
  end
  local function note(file)
    local parts = {}
    if unpushed[file] then
      table.insert(parts, "↑ not pushed")
    end
    if uncommitted[file] then
      table.insert(parts, "not committed")
    end
    return #parts > 0 and table.concat(parts, ", ") or nil
  end
  local function add(lines, right)
    for _, line in ipairs(lines) do
      local fields = vim.split(line, "\t", { plain = true })
      local file, old = fields[#fields], #fields > 2 and fields[2] or nil
      seen[file] = true
      if old then
        seen[old] = true
      end
      table.insert(entries, {
        kind = fields[1]:sub(1, 1),
        file = file,
        old = old,
        right = right,
        note = right and "↓ on GitHub" or note(file),
      })
    end
  end
  add(split_lines(results.names))
  for _, file in ipairs(split_lines(results.untracked)) do
    seen[file] = true
    table.insert(entries, { kind = "?", file = file, note = "not committed" })
  end
  add(split_lines(results.incoming), "@{u}")
  if not state.changed_only then
    for _, file in ipairs(split_lines(results.tracked)) do
      if not seen[file] then
        table.insert(entries, { kind = " ", file = file })
      end
    end
  end
  return entries
end

local function compare_from(row, token, base)
  local status = row.status
  local commands = {
    upstream = { "rev-parse", "--abbrev-ref", "@{u}" },
    local_only = { "log", "--oneline", "@{u}.." },
    branch_only = { "log", "--oneline", "..@{u}" },
    untracked = { "ls-files", "--others", "--exclude-standard" },
    tracked = { "ls-files" },
    names = { "diff", "--name-status", base },
    incoming = { "diff", "--name-status", base, "@{u}" },
    unpushed = { "diff", "--name-only", base, "HEAD" },
    uncommitted = { "diff", "--name-only", "HEAD" },
  }
  local results, pending = {}, vim.tbl_count(commands)
  for key, args in pairs(commands) do
    vim.system(
      vim.list_extend({ "git", "-C", row.path }, args),
      { text = true },
      vim.schedule_wrap(function(result)
        results[key] = result.code == 0 and result.stdout or ""
        pending = pending - 1
        if pending > 0 or token ~= state.token then
          return
        end
        local keep = current_entry()
        keep = state.project and state.project.path == row.path and keep and keep.file or nil
        state.project = {
          path = row.path,
          base = base,
          status = status,
          upstream = vim.trim(results.upstream),
          local_only = split_lines(results.local_only),
          branch_only = split_lines(results.branch_only),
        }
        state.entries = build_entries(results)
        show_entries(keep)
        preview_file()
      end)
    )
  end
end

local function compare(row, token)
  vim.system(
    { "git", "-C", row.path, "merge-base", "HEAD", "@{u}" },
    { text = true },
    vim.schedule_wrap(function(result)
      if token ~= state.token then
        return
      end
      local fallback = row.status.upstream and "@{u}" or "HEAD"
      compare_from(row, token, result.code == 0 and vim.trim(result.stdout) or fallback)
    end)
  )
end

local function preview()
  state.token = state.token + 1
  local token = state.token
  vim.defer_fn(function()
    if token ~= state.token then
      return
    end
    local row = selected()
    if not row then
      return
    end
    if row.path then
      compare(row, token)
    else
      state.project = nil
      state.entries = {}
      show_entries()
      local description = type(row.repo.description) == "string" and row.repo.description or ""
      show({ row.repo.name, description, row.repo.url, "", "Press enter to clone this project." }, {})
    end
  end, 120)
end

local function scan(done)
  local paths = projects.find()
  local clones, pending = {}, #paths
  if pending == 0 then
    state.clones = clones
    return done()
  end
  for _, path in ipairs(paths) do
    vim.system(
      { "git", "-C", path, "config", "--get", "remote.origin.url" },
      { text = true },
      vim.schedule_wrap(function(remote)
        vim.system(
          projects.status_cmd(path),
          { text = true },
          vim.schedule_wrap(function(result)
            local key = slug(vim.trim(remote.stdout or ""))
            if key then
              clones[key] = projects.parse(path, result)
            end
            pending = pending - 1
            if pending == 0 then
              state.clones = clones
              done()
            end
          end)
        )
      end)
    )
  end
end

local function update()
  scan(function()
    merge()
    draw()
    preview()
  end)
end

local function fetch_clones()
  local pending = vim.tbl_count(state.clones)
  for _, clone in pairs(state.clones) do
    vim.system(
      { "git", "-C", clone.path, "fetch", "--quiet" },
      { text = true, env = { GIT_TERMINAL_PROMPT = "0" } },
      vim.schedule_wrap(function()
        pending = pending - 1
        if pending == 0 then
          update()
        end
      end)
    )
  end
end

local function fetch_repos(done)
  vim.system(
    { "gh", "repo", "list", "--limit", "200", "--no-archived", "--source", "--json", FIELDS },
    { text = true },
    vim.schedule_wrap(function(result)
      local ok, repos = pcall(vim.json.decode, result.stdout or "", { luanil = { object = true, array = true } })
      if result.code == 0 and ok then
        table.sort(repos, function(a, b)
          return a.pushedAt > b.pushedAt
        end)
        state.repos = repos
        state.stale = false
      else
        state.stale = true
        state.message = "gh failed. Run gh auth login."
      end
      save_cache()
      done()
    end)
  )
end

local function fetch_graph(done)
  if os.time() - state.fetched < GRAPH_MAX_AGE then
    return done()
  end
  vim.system(
    { "gh", "api", "graphql", "-f", "query=" .. QUERY },
    { text = true },
    vim.schedule_wrap(function(result)
      local ok, data = pcall(vim.json.decode, result.stdout or "")
      local viewer = result.code == 0 and ok and vim.tbl_get(data, "data", "viewer")
      if viewer then
        local calendar = viewer.contributionsCollection.contributionCalendar
        local weeks = {}
        for _, entry in ipairs(calendar.weeks) do
          local days = {}
          for day = 1, 7 do
            days[day] = " "
          end
          for _, day in ipairs(entry.contributionDays) do
            days[day.weekday + 1] = LEVELS[day.contributionLevel] or 0
          end
          table.insert(weeks, { month = entry.contributionDays[1].date:sub(1, 7), days = table.concat(days) })
        end
        state.login = viewer.login
        state.graph = { total = calendar.totalContributions, weeks = weeks }
        state.fetched = os.time()
      end
      done()
    end)
  )
end

local function load()
  if vim.fn.executable("gh") == 0 then
    state.message = "Install gh to use this page."
    return update()
  end
  fetch_graph(function()
    fetch_repos(function()
      scan(function()
        merge()
        draw()
        preview()
        fetch_clones()
      end)
    end)
  end)
end

local function close()
  state.token = state.token + 1
  for _, win in ipairs({ state.graph_win, state.win, state.files_win, state.before_win, state.diff_win, state.back_win }) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  state.graph_win, state.back_win = -1, -1
end

local function open_project(row)
  close()
  vim.cmd.tcd(vim.fn.fnameescape(row.path))
  Snacks.dashboard.pick("files", { cwd = row.path })
end

local function open_file(row, target)
  local path = row.path .. "/" .. target.file
  if vim.fn.filereadable(path) == 0 then
    return vim.notify(target.file .. " is not in the local copy", vim.log.levels.WARN)
  end
  close()
  vim.cmd.tcd(vim.fn.fnameescape(row.path))
  vim.cmd("edit +" .. target.lnum .. " " .. vim.fn.fnameescape(path))
end

local function clone(row)
  local target = vim.fn.expand("~/") .. row.repo.name
  if vim.uv.fs_stat(target) then
    return vim.notify(target .. " already exists", vim.log.levels.WARN)
  end
  if vim.fn.confirm("Clone " .. row.repo.name .. " to " .. target .. "?", "&Yes\n&No", 2) ~= 1 then
    return
  end
  vim.system(
    { "gh", "repo", "clone", row.repo.nameWithOwner, target },
    { text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify(result.stderr, vim.log.levels.ERROR, { title = "Clone failed: " .. row.repo.name })
      end
      update()
    end)
  )
end

local function with_clone(action)
  return function()
    local row = selected()
    if row and row.status then
      action(row)
    elseif row then
      vim.notify(row.repo.name .. " is not cloned", vim.log.levels.WARN)
    end
  end
end

local function scroll(keys)
  return function()
    if vim.api.nvim_win_is_valid(state.diff_win) then
      vim.api.nvim_win_call(state.diff_win, function()
        vim.cmd.normal({ vim.keycode(keys), bang = true })
      end)
    end
  end
end

local function wheel(step)
  return function()
    local mouse = vim.fn.getmousepos()
    if mouse.winid == state.diff_win or mouse.winid == state.before_win then
      vim.api.nvim_win_call(state.diff_win, function()
        vim.cmd.normal({ vim.keycode(step > 0 and "3<c-e>" or "3<c-y>"), bang = true })
      end)
    elseif mouse.winid == state.win or mouse.winid == state.files_win then
      local cursor = vim.api.nvim_win_get_cursor(mouse.winid)
      local last = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(mouse.winid))
      vim.api.nvim_win_set_cursor(mouse.winid, { math.max(1, math.min(last, cursor[1] + step)), 0 })
      if mouse.winid == state.files_win then
        preview_file()
      else
        preview()
      end
    end
  end
end

local function open_entry(lnum)
  local row = selected()
  local entry = current_entry()
  if row and row.path and entry and entry.kind ~= "D" and not (entry.right and entry.kind == "A") then
    open_file(row, { file = entry.file, lnum = lnum or state.first_change or 1 })
  end
end

local function focus(win)
  return function()
    if vim.api.nvim_win_is_valid(win()) then
      vim.api.nvim_set_current_win(win())
    end
  end
end

local function jump_change(keys)
  return function()
    if vim.api.nvim_win_is_valid(state.diff_win) then
      vim.api.nvim_win_call(state.diff_win, function()
        pcall(vim.cmd.normal, { keys, bang = true })
      end)
    end
  end
end

local function set_navigation(page, files, after)
  local function projects_win()
    return state.win
  end
  local function files_win()
    return state.files_win
  end
  local function after_win()
    return state.diff_win
  end
  for _, options in ipairs({ page, files, after }) do
    vim.keymap.set("n", "1", focus(projects_win), options)
    vim.keymap.set("n", "2", focus(files_win), options)
    vim.keymap.set("n", "3", focus(after_win), options)
    vim.keymap.set("n", "n", jump_change("]c"), options)
    vim.keymap.set("n", "N", jump_change("[c"), options)
    vim.keymap.set("n", "J", scroll("3<c-e>"), options)
    vim.keymap.set("n", "K", scroll("3<c-y>"), options)
  end
  vim.keymap.set("n", "l", focus(files_win), page)
  vim.keymap.set("n", "<s-tab>", focus(after_win), page)
  vim.keymap.set("n", "h", focus(projects_win), files)
  vim.keymap.set("n", "l", focus(after_win), files)
  vim.keymap.set("n", "<s-tab>", focus(projects_win), files)
  vim.keymap.set("n", "h", focus(files_win), after)
  vim.keymap.set("n", "<s-tab>", focus(files_win), after)
end

local function set_keys()
  local page = { buffer = state.buf, nowait = true }
  local both = { buffer = state.diff_buf, nowait = true }
  local files = { buffer = state.files_buf, nowait = true }
  set_navigation(page, files, both)
  for _, options in ipairs({ page, both, files }) do
    vim.keymap.set("n", "<ScrollWheelDown>", wheel(1), options)
    vim.keymap.set("n", "<ScrollWheelUp>", wheel(-1), options)
  end
  for _, options in ipairs({ page, files }) do
    vim.keymap.set("n", "a", function()
      state.changed_only = not state.changed_only
      preview()
    end, options)
  end
  vim.keymap.set("n", "<cr>", function()
    open_entry()
  end, files)
  vim.keymap.set("n", "<LeftRelease>", function()
    if vim.fn.getmousepos().winid == state.files_win then
      vim.schedule(function()
        open_entry()
      end)
    end
  end, files)
  vim.keymap.set("n", "<tab>", function()
    vim.api.nvim_set_current_win(state.diff_win)
  end, files)
  vim.keymap.set("n", "<esc>", close, files)
  vim.keymap.set("n", "q", close, files)
  vim.keymap.set("n", "<c-d>", scroll("<c-d>"), files)
  vim.keymap.set("n", "<c-u>", scroll("<c-u>"), files)
  vim.keymap.set("n", "<esc>", close, page)
  vim.keymap.set("n", "<esc>", close, both)
  vim.keymap.set("n", "<cr>", function()
    local row = selected()
    if row and row.path then
      open_project(row)
    elseif row then
      clone(row)
    end
  end, page)
  vim.keymap.set(
    "n",
    "d",
    with_clone(function(row)
      close()
      local status, range = row.status, ""
      if status.upstream then
        local incoming_only = status.behind > 0 and status.ahead == 0 and status.changed == 0
        range = incoming_only and " HEAD...@{u}" or " @{u} --merge-base"
      end
      vim.cmd("DiffviewOpen" .. range .. " -C" .. vim.fn.fnameescape(row.path))
    end),
    page
  )
  vim.keymap.set(
    "n",
    "G",
    with_clone(function(row)
      Snacks.lazygit({ cwd = row.path })
    end),
    page
  )
  vim.keymap.set(
    "n",
    "p",
    with_clone(function(row)
      projects.actions.p(row.status)
    end),
    page
  )
  vim.keymap.set(
    "n",
    "u",
    with_clone(function(row)
      projects.actions.u(row.status)
    end),
    page
  )
  vim.keymap.set(
    "n",
    "F",
    with_clone(function(row)
      projects.actions.f(row.status)
    end),
    page
  )
  vim.keymap.set("n", "o", function()
    local row = selected()
    if row then
      vim.ui.open(row.repo.url)
    end
  end, page)
  vim.keymap.set("n", "R", function()
    state.fetched = 0
    load()
  end, page)
  vim.keymap.set("n", "<c-d>", scroll("<c-d>"), page)
  vim.keymap.set("n", "<c-u>", scroll("<c-u>"), page)
  vim.keymap.set("n", "<tab>", function()
    vim.api.nvim_set_current_win(state.files_win)
  end, page)
  vim.keymap.set("n", "<tab>", function()
    vim.api.nvim_set_current_win(state.win)
  end, both)
  vim.keymap.set("n", "q", close, page)
  vim.keymap.set("n", "q", close, both)
  vim.keymap.set("n", "<2-LeftMouse>", function()
    local row = selected()
    if row and row.path then
      open_project(row)
    end
  end, page)
  vim.keymap.set("n", "<cr>", function()
    open_entry(vim.api.nvim_win_get_cursor(state.diff_win)[1])
  end, both)
  vim.keymap.set("n", "<LeftRelease>", function()
    local mouse = vim.fn.getmousepos()
    if mouse.winid == state.diff_win then
      open_entry(mouse.line)
    end
  end, both)
end

local function scratch(name, filetype)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = filetype
  vim.bo[buf].modifiable = false
  vim.api.nvim_buf_set_name(buf, name)
  return buf
end

local function float(buf, enter, config)
  local win = vim.api.nvim_open_win(
    buf,
    enter,
    vim.tbl_extend("force", {
      relative = "editor",
      row = 0,
      col = 0,
      width = 10,
      height = 1,
      style = "minimal",
      border = "rounded",
      title_pos = "center",
    }, config)
  )
  vim.wo[win][0].winhighlight = "NormalFloat:Normal"
  vim.wo[win][0].wrap = false
  vim.wo[win][0].winblend = 0
  return win
end

local function layout()
  state.back_win = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, {
    relative = "editor",
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.lines,
    style = "minimal",
    border = "none",
    focusable = false,
    zindex = 40,
  })
  vim.wo[state.back_win][0].winhighlight = "NormalFloat:Normal"
  state.graph_win = -1
  if vim.o.lines >= MIN_GRAPH_LINES then
    state.graph_win = float(state.graph_buf, false, {
      title = " GitHub " .. state.login .. " ",
      focusable = false,
      zindex = 45,
    })
  end
  state.files_win = float(state.files_buf, false, { title = " Files ", zindex = 45 })
  state.before_win = float(state.before_buf, false, { title = " Before ", focusable = false, zindex = 45 })
  state.diff_win = float(state.diff_buf, false, {
    title = " After ",
    footer = MOVE_HINTS,
    footer_pos = "center",
    zindex = 45,
  })
  local shared = "NormalFloat:Normal,DiffDelete:NananvimFill,Folded:Comment"
  vim.wo[state.before_win][0].winhighlight = shared
    .. ",DiffAdd:NananvimOld,DiffChange:NananvimOld,DiffText:NananvimOldText,DiffTextAdd:NananvimOldText"
  vim.wo[state.diff_win][0].winhighlight = shared
    .. ",DiffAdd:NananvimNew,DiffChange:NananvimNew,DiffText:NananvimNewText,DiffTextAdd:NananvimNewText"
  state.win = float(state.buf, true, {
    title = " Projects ",
    footer = ACTION_HINTS,
    footer_pos = "center",
    zindex = 45,
  })
  vim.wo[state.win][0].cursorline = true
  vim.wo[state.files_win][0].cursorline = true
  vim.wo[state.diff_win][0].cursorline = true
end

M.set_highlights = set_highlights

function M.open()
  if valid() then
    return vim.api.nvim_set_current_win(state.win)
  end
  load_cache()
  set_highlights()
  merge()
  state.first = 0
  state.shown = nil
  state.entries = {}
  state.project = nil
  state.buf = scratch("nananvim://github", "nananvim_github")
  state.files_buf = scratch("nananvim://github-files", "nananvim_github")
  state.graph_buf = scratch("nananvim://github-graph", "nananvim_github")
  state.before_buf = scratch("nananvim://github-before", "text")
  state.diff_buf = scratch("nananvim://github-after", "text")
  layout()
  set_keys()
  local group = vim.api.nvim_create_augroup("nananvim_github", { clear = true })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = state.buf,
    callback = function()
      local cursor = vim.api.nvim_win_get_cursor(state.win)
      local last = state.first + math.max(#state.rows, 1) - 1
      local line = math.max(state.first, math.min(cursor[1], last))
      if line ~= cursor[1] or cursor[2] ~= 0 then
        vim.api.nvim_win_set_cursor(state.win, { line, 0 })
      end
      preview()
    end,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = state.files_buf,
    callback = preview_file,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    pattern = { tostring(state.win), tostring(state.files_win), tostring(state.before_win), tostring(state.diff_win) },
    callback = vim.schedule_wrap(close),
  })
  vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
      if valid() then
        close()
        M.open()
      end
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "NananvimProjectsChanged",
    callback = function()
      if valid() then
        update()
      end
    end,
  })
  draw()
  load()
end

return M
