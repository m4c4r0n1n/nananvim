local M = {}

local FIELDS = "name,nameWithOwner,description,url,isPrivate,isFork,pushedAt"
local PAGE_SIZE = 100

local function json(result)
  local ok, data = pcall(vim.json.decode, result.stdout or "", { luanil = { object = true, array = true } })
  return result.code == 0 and ok and data or nil
end

local function run(cmd, options, done)
  vim.system(cmd, options, vim.schedule_wrap(done))
end

local function raw_lines(cmd, done)
  run(cmd, {}, function(result)
    done(result.code == 0 and result.stdout or nil)
  end)
end

local github = {
  name = "GitHub",
  cli = "gh",
  domain = "github.com",
  icon = vim.fn.nr2char(0xf09b),
  login = "gh auth login",
}

function github.repos(done)
  run(
    { "gh", "repo", "list", "--limit", "200", "--no-archived", "--source", "--json", FIELDS },
    { text = true },
    function(result)
      done(json(result))
    end
  )
end

function github.tree(repo, done)
  run(
    { "gh", "api", "repos/" .. repo.nameWithOwner .. "/git/trees/HEAD?recursive=1" },
    { text = true },
    function(result)
      local data = json(result)
      if not data then
        return done(nil)
      end
      local entries = {}
      for _, item in ipairs(data.tree) do
        if item.type == "blob" then
          table.insert(entries, { kind = " ", file = item.path, sha = item.sha, size = item.size })
        end
      end
      done(entries)
    end
  )
end

function github.blob(repo, entry, done)
  raw_lines({
    "gh",
    "api",
    "repos/" .. repo.nameWithOwner .. "/git/blobs/" .. entry.sha,
    "-H",
    "Accept: application/vnd.github.raw+json",
  }, done)
end

function github.clone(repo, target)
  return { "gh", "repo", "clone", repo.nameWithOwner, target }
end

local function api_path(file)
  local parts = {}
  for _, part in ipairs(vim.split(file, "/", { plain = true })) do
    table.insert(parts, vim.uri_encode(part, "rfc2396"))
  end
  return table.concat(parts, "/")
end

function github.save(repo, entry, text, message, done)
  run(
    { "gh", "api", "-X", "PUT", "repos/" .. repo.nameWithOwner .. "/contents/" .. api_path(entry.file), "--input", "-" },
    {
      stdin = vim.json.encode({ message = message, content = vim.base64.encode(text), sha = entry.sha }),
      text = true,
    },
    function(result)
      local data = json(result)
      done(data and data.content.sha, result.stderr)
    end
  )
end

local gitlab = {
  name = "GitLab",
  cli = "glab",
  domain = "gitlab.com",
  icon = vim.fn.nr2char(0xf296),
  login = "glab auth login",
}

function gitlab.repos(done)
  local path = "projects?owned=true&archived=false&order_by=last_activity_at&per_page=" .. PAGE_SIZE
  run({ "glab", "api", path }, { text = true }, function(result)
    local data = json(result)
    if not data then
      return done(nil)
    end
    local repos = {}
    for _, item in ipairs(data) do
      table.insert(repos, {
        id = item.id,
        name = item.path,
        nameWithOwner = item.path_with_namespace,
        description = item.description,
        url = item.web_url,
        isPrivate = item.visibility ~= "public",
        isFork = item.forked_from_project ~= nil,
        pushedAt = item.last_activity_at,
      })
    end
    done(repos)
  end)
end

function gitlab.tree(repo, done)
  local entries = {}
  local function page(number)
    local path = "projects/"
      .. repo.id
      .. "/repository/tree?recursive=true&per_page="
      .. PAGE_SIZE
      .. "&page="
      .. number
    run({ "glab", "api", path }, { text = true }, function(result)
      local data = json(result)
      if not data then
        return done(nil)
      end
      for _, item in ipairs(data) do
        if item.type == "blob" then
          table.insert(entries, { kind = " ", file = item.path, sha = item.id, size = 0 })
        end
      end
      if #data == PAGE_SIZE then
        return page(number + 1)
      end
      done(entries)
    end)
  end
  page(1)
end

function gitlab.blob(repo, entry, done)
  raw_lines({ "glab", "api", "projects/" .. repo.id .. "/repository/blobs/" .. entry.sha .. "/raw" }, done)
end

function gitlab.clone(repo, target)
  return { "glab", "repo", "clone", repo.nameWithOwner, target }
end

local hosts

local function all()
  if hosts then
    return hosts
  end
  hosts = { github, gitlab }
  local ok, custom = pcall(require, "config.git_hosts")
  if ok and type(custom) == "table" then
    vim.list_extend(hosts, custom)
  end
  return hosts
end

function M.available()
  return vim.tbl_filter(function(host)
    return vim.fn.executable(host.cli) == 1
  end, all())
end

function M.find(name)
  for _, host in ipairs(all()) do
    if host.name == name then
      return host
    end
  end
end

function M.connected()
  local file = io.open(vim.fn.stdpath("cache") .. "/nananvim_git.json", "r")
  if not file then
    return M.available()
  end
  local text = file:read("*a")
  file:close()
  local ok, data = pcall(vim.json.decode, text, { luanil = { object = true, array = true } })
  local seen = {}
  for _, repo in ipairs(ok and type(data) == "table" and data.repos or {}) do
    seen[repo.host or ""] = true
  end
  local connected = vim.tbl_filter(function(host)
    return seen[host.name]
  end, M.available())
  return #connected > 0 and connected or M.available()
end

function M.icon()
  local connected = M.connected()
  return #connected == 1 and connected[1].icon or vim.fn.nr2char(0xe702)
end

function M.key(url)
  for _, host in ipairs(all()) do
    local path = url:match(vim.pesc(host.domain) .. "[:/](.+)$")
    if path then
      return host.name:lower() .. "/" .. path:gsub("%.git$", ""):gsub("/$", ""):lower(), host
    end
  end
end

function M.repo_key(repo)
  return repo.host:lower() .. "/" .. repo.nameWithOwner:lower()
end

return M
