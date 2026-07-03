-- :checkhealth nananvim
-- Reports on the external tools this config leans on, so "why doesn't X work"
-- is answerable without reading the docs.

local M = {}

local health = vim.health

local function has(exe)
  return vim.fn.executable(exe) == 1
end

local function check_exe(exe, msg, level)
  if has(exe) then
    health.ok(exe .. " — " .. msg)
  elseif level == "error" then
    health.error(exe .. " missing — " .. msg)
  else
    health.warn(exe .. " missing — " .. msg)
  end
end

function M.check()
  health.start("nananvim: core")

  local v = vim.version()
  local ver = string.format("%d.%d.%d", v.major, v.minor, v.patch)
  if vim.fn.has("nvim-0.12") == 1 then
    health.ok("Neovim " .. ver .. " (0.12+ required by nvim-treesitter v2)")
  else
    health.error("Neovim 0.12+ required — nvim-treesitter v2 and parts of this config won't work on " .. ver)
  end

  check_exe("git", "required by lazy.nvim to install/update plugins", "error")
  check_exe("rg", "powers live grep (<leader>fg)", "error")
  check_exe("fd", "powers the file picker (<leader>f)", "warn")
  check_exe("tree-sitter", "compiles treesitter parsers (nvim-treesitter v2)", "warn")

  health.start("nananvim: language tooling")

  check_exe("node", "TypeScript/JavaScript LSP, prettier", "warn")
  check_exe("python3", "pyright, black, isort, debugpy", "warn")
  check_exe("clang", "C/C++ LSP (clangd ships with clang on most distros)", "warn")

  health.start("nananvim: appearance")

  local term = vim.env.TERM or ""
  local kitty_graphics = vim.env.KITTY_WINDOW_ID ~= nil
    or vim.env.GHOSTTY_RESOURCES_DIR ~= nil
    or term:find("kitty")
    or term:find("ghostty")
    or (vim.env.TERM_PROGRAM or ""):find("WezTerm")
  if kitty_graphics then
    health.ok("terminal speaks the kitty graphics protocol — inline image previews available")
  else
    health.warn("no kitty-graphics terminal detected (TERM=" .. term .. ") — image previews in the picker won't render. Kitty, Ghostty, and WezTerm all work.")
  end
  check_exe("magick", "converts images for inline previews (ImageMagick)", "warn")
  health.info("icons look broken? You need a Nerd Font set in your terminal — https://www.nerdfonts.com")

  health.start("nananvim: nanabrowser")

  local text_browser
  for _, b in ipairs({ "w3m", "lynx", "elinks" }) do
    if has(b) then
      text_browser = b
      break
    end
  end
  if text_browser then
    health.ok(text_browser .. " — in-editor text browser for the panel workspace (<leader>p)")
  else
    health.warn("no text browser (w3m/lynx/elinks) — the browser panel will fall back to your external browser")
  end

  health.start("nananvim: extras (lua/config/extras.lua)")

  local ok_extras, extras = pcall(require, "config.extras")
  if ok_extras then
    for _, flag in ipairs({ "cmp_rich", "lint", "dap" }) do
      health.info(flag .. " = " .. tostring(extras[flag]))
    end
  else
    health.error("lua/config/extras.lua failed to load — extras layer (cmp UI, lint, DAP) is disabled")
  end

  health.start("nananvim: AI (opt-in)")

  local local_lua = vim.fn.stdpath("config") .. "/lua/config/local.lua"
  if vim.fn.filereadable(local_lua) == 1 then
    health.ok("lua/config/local.lua exists — Codeium + Avante enabled")
    if vim.env.ANTHROPIC_API_KEY or vim.env.GROQ_API_KEY or vim.env.OPENAI_API_KEY then
      health.ok("provider API key found in environment")
    else
      health.info("no ANTHROPIC_API_KEY / GROQ_API_KEY in environment — Avante chat needs one (Codeium doesn't)")
    end
  else
    health.info("AI disabled (no lua/config/local.lua) — create it to enable Codeium + Avante, see README")
  end
end

return M
