-- :checkhealth nananvim
-- This check reports the external tools that this config uses.
-- Use it to find why a feature does not work.

local M = {}

local health = vim.health

local function has(exe)
  return vim.fn.executable(exe) == 1
end

local function check_exe(exe, msg, level)
  if has(exe) then
    health.ok(exe .. ": " .. msg)
  elseif level == "error" then
    health.error(exe .. " missing: " .. msg)
  else
    health.warn(exe .. " missing: " .. msg)
  end
end

function M.check()
  health.start("nananvim: core")

  local v = vim.version()
  local ver = string.format("%d.%d.%d", v.major, v.minor, v.patch)
  if vim.fn.has("nvim-0.12") == 1 then
    health.ok("Neovim " .. ver .. " (0.12 or later is necessary)")
  else
    health.error(
      "Neovim 0.12 or later is necessary. nvim-treesitter (main) and parts of this config do not work on " .. ver
    )
  end

  check_exe("git", "lazy.nvim uses it to install and update plugins", "error")
  check_exe("curl", "nvim-treesitter, Mason and blink.cmp use it to download files", "error")
  check_exe("rg", "live grep (<leader>fg) and search and replace (<leader>sr)", "error")
  if has("fd") or has("fdfind") then
    health.ok("fd: file picker (<leader>f)")
  else
    health.warn("fd missing: the file picker (<leader>f) is slower without it")
  end
  check_exe("tree-sitter", "nvim-treesitter (main) uses it to compile parsers", "warn")
  check_exe("cc", "a C compiler is necessary to compile treesitter parsers", "warn")
  check_exe("lazygit", "git interface (<leader>gg)", "warn")

  health.start("nananvim: completion")

  local ok_blink, blink_fuzzy = pcall(require, "blink.cmp.fuzzy.rust")
  if ok_blink and blink_fuzzy then
    health.ok("blink.cmp Rust fuzzy matcher is available")
  else
    health.warn("blink.cmp Rust fuzzy matcher is not available. The Lua matcher is slower. Run :checkhealth blink.cmp")
  end

  health.start("nananvim: language tooling")

  check_exe("node", "TypeScript, HTML, CSS, JSON and YAML servers, prettier, JS debugging", "warn")
  check_exe("python3", "Python provider and debugpy", "warn")
  check_exe("clangd", "C and C++ LSP (Mason installs it if it is not on PATH)", "warn")
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  if vim.fn.isdirectory(mason_bin) == 1 then
    health.ok("Mason tools folder exists: " .. mason_bin)
  else
    health.info("Mason has not installed tools yet. Open a file and wait, or run :Mason")
  end

  health.start("nananvim: appearance")

  local term = vim.env.TERM or ""
  local kitty_graphics = vim.env.KITTY_WINDOW_ID ~= nil
    or vim.env.GHOSTTY_RESOURCES_DIR ~= nil
    or term:find("kitty")
    or term:find("ghostty")
    or (vim.env.TERM_PROGRAM or ""):find("WezTerm")
  if kitty_graphics then
    health.ok("the terminal supports the kitty graphics protocol. Inline image previews are available")
  else
    health.warn(
      "no kitty graphics terminal found (TERM="
        .. term
        .. "). Image previews in the picker do not show. Kitty, Ghostty and WezTerm work."
    )
  end
  if has("magick") or has("convert") then
    health.ok("ImageMagick: converts images for inline previews")
  else
    health.warn("ImageMagick missing: inline image previews need it")
  end
  health.info("If icons show as boxes, set a Nerd Font in your terminal: https://www.nerdfonts.com")

  health.start("nananvim: nanabrowser")

  local text_browser
  for _, b in ipairs({ "w3m", "lynx", "elinks" }) do
    if has(b) then
      text_browser = b
      break
    end
  end
  if text_browser then
    health.ok(text_browser .. ": text browser in the panel workspace (<leader>p)")
  else
    health.warn("no text browser (w3m, lynx or elinks). The browser panel uses your external browser")
  end

  health.start("nananvim: extras (lua/config/extras.lua)")

  local ok_extras, extras = pcall(require, "config.extras")
  if ok_extras then
    for _, flag in ipairs({ "cmp_rich", "lint", "dap" }) do
      health.info(flag .. " = " .. tostring(extras[flag]))
    end
  else
    health.error("lua/config/extras.lua did not load. The extras layer (completion UI, lint, DAP) is off")
  end

  health.start("nananvim: AI (opt-in)")

  local local_lua = vim.fn.stdpath("config") .. "/lua/config/local.lua"
  if vim.fn.filereadable(local_lua) == 1 then
    health.ok("lua/config/local.lua exists: Windsurf (Codeium) and Avante are on")
    if vim.env.ANTHROPIC_API_KEY or vim.env.GROQ_API_KEY or vim.env.OPENAI_API_KEY then
      health.ok("a provider API key is in the environment")
    else
      health.info(
        "no ANTHROPIC_API_KEY, GROQ_API_KEY or OPENAI_API_KEY found. Avante chat needs one. Windsurf does not"
      )
    end
    check_exe("make", "Avante uses it to build or download its binary", "warn")
  else
    health.info("AI is off (no lua/config/local.lua). Make that file to turn on Windsurf and Avante. See the README")
  end
end

return M
