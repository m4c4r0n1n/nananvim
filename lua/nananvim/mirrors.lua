local M = {}

local tracked = {}

local function list()
  return vim.g.nananvim_git_mirrors or {}
end

local function read(path)
  local file = io.open(path, "rb")
  if not file then
    return nil
  end
  local text = file:read("*a")
  file:close()
  return text
end

local function copy_newer(live, target)
  local source = vim.uv.fs_stat(live)
  if not source or source.type ~= "file" then
    return
  end
  local current = vim.uv.fs_stat(target)
  if current and source.mtime.sec <= current.mtime.sec then
    return
  end
  if read(live) ~= read(target) then
    vim.fn.mkdir(vim.fs.dirname(target), "p")
    vim.uv.fs_copyfile(live, target)
  end
end

local function folder_files(repo, folder)
  local key = repo .. "\n" .. folder
  if not tracked[key] then
    local result = vim.system({ "git", "-C", repo, "ls-files", folder }, { text = true }):wait()
    tracked[key] = vim.split(result.stdout or "", "\n", { plain = true, trimempty = true })
  end
  return tracked[key]
end

function M.reset()
  tracked = {}
end

function M.sync()
  for _, mirror in ipairs(list()) do
    local repo = vim.fn.expand(mirror.repo)
    if vim.uv.fs_stat(repo .. "/.git") then
      if mirror.folder then
        local live = vim.fn.expand(mirror.live)
        for _, file in ipairs(folder_files(repo, mirror.folder)) do
          copy_newer(live .. "/" .. file:sub(#mirror.folder + 2), repo .. "/" .. file)
        end
      end
      for file, path in pairs(mirror.files or {}) do
        copy_newer(vim.fn.expand(path), repo .. "/" .. file)
      end
    end
  end
end

return M
