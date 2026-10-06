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

  -- NixOS: Mason downloads prebuilt servers. They need nix-ld to start.
  if vim.uv.fs_stat("/etc/NIXOS") then
    if vim.env.NIX_LD then
      health.ok("NixOS with nix-ld: Mason's language servers can start")
    else
      health.warn(
        "NixOS without nix-ld: Mason's language servers and debug adapters will not start. "
          .. "Add programs.nix-ld.enable = true; to configuration.nix, then nixos-rebuild switch"
      )
    end
  end

  health.start("nananvim: completion")

  local ok_blink, blink_fuzzy = pcall(require, "blink.cmp.fuzzy.rust")
  if ok_blink and blink_fuzzy then
    health.ok("blink.cmp Rust fuzzy matcher is available")
  else
    health.warn("blink.cmp Rust fuzzy matcher is not available. The Lua matcher is slower. Run :checkhealth blink.cmp")
  end

  health.start("nananvim: language tooling")

  check_exe("node", "TypeScript, HTML, CSS, JSON and YAML servers, prettier, JS debugging", "warn")
  if has("node") then
    local major = tonumber(vim.fn.system({ "node", "--version" }):match("^v(%d+)"))
    if major and major < 20 then
      health.warn("node " .. major .. " is too old. Mason's npm servers and Copilot need node 20 or later")
    end
  end
  check_exe("python3", "Python debugging (debugpy)", "warn")
  check_exe("clangd", "C and C++ LSP (Mason also installs it)", "warn")
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
    for _, flag in ipairs({ "cmp_rich", "lint", "dap", "test", "ui2" }) do
      health.info(flag .. " = " .. tostring(extras[flag]))
    end
  else
    health.error("lua/config/extras.lua did not load: " .. tostring(extras))
  end

  health.start("nananvim: personal settings (lua/config/local.lua)")

  local user = require("config.user")
  if user.exists then
    health.ok("lua/config/local.lua is loaded. Git ignores it, thus :NananvimUpdate keeps it")
  else
    health.info("no lua/config/local.lua. Copy lua/config/local.example.lua to make one")
  end

  health.start("nananvim: AI (opt-in)")

  if not user.ai then
    health.info("AI is off. Make lua/config/local.lua to turn on suggestions and Avante. See the README")
    return
  end
  if user.suggestions == "windsurf" then
    health.ok("suggestions: Windsurf (run :Codeium Auth one time to log in)")
  elseif user.suggestions == "copilot" then
    health.ok("suggestions: Copilot (run :LspCopilotSignIn one time to log in)")
    check_exe("node", "the Copilot language server runs with node", "error")
  else
    health.info("suggestions: off")
  end
  if user.settings.avante == false then
    health.info("Avante: off")
  else
    health.ok("Avante: on")
    if vim.env.ANTHROPIC_API_KEY or vim.env.GROQ_API_KEY or vim.env.OPENAI_API_KEY then
      health.ok("a provider API key is in the environment")
    else
      health.info("no ANTHROPIC_API_KEY, GROQ_API_KEY or OPENAI_API_KEY found. Avante chat needs one")
    end
    check_exe("make", "Avante uses it to build or download its binary", "warn")
  end
end

return M
