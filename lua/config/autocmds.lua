vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
-- Extra "blackout" polish for UI groups the theme-switcher itself doesn't
-- cover (neo-tree/pmenu/diagnostics/borders). Gated behind the
-- switcher's own bg_mode so normal/terminal themes render untouched — the
-- switcher owns the blackout state, this just extends it.
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local ok, switcher = pcall(require, "theme-switcher")
    if not ok or not switcher.state or switcher.state.bg_mode ~= "blackout" then
      return
    end

    local black_groups = {
      "Normal",
      "NormalFloat",
      "NormalNC",
      "SignColumn",
      "LineNr",
      "CursorLineNr",
      "ColorColumn",
      "Folded",
      "FoldColumn",
      "StatusLine",
      "StatusLineNC",
      "TabLine",
      "TabLineFill",
      "TabLineSel",
      -- Neo-tree
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "NeoTreeEndOfBuffer",
      "NeoTreeCursorLine",
      -- Dashboard
      "SnacksDashboard",
      -- Snacks everything
      "SnacksNotifierInfo",
      "SnacksNotifierWarn",
      "SnacksNotifierError",
      "SnacksNotifierDebug",
      "SnacksNotifierTrace",
      -- Completion menu
      "Pmenu",
      "PmenuSbar",
    }

    for _, group in ipairs(black_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "#000000" })
    end

    -- Make EndOfBuffer invisible
    vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#000000", bg = "#000000" })

    -- File explorer and picker borders
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#5E81AC", bg = "#000000" })
    vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { fg = "#5E81AC", bg = "#000000" })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#5E81AC", bg = "#000000" })

    -- Make main window separators invisible (between code splits)
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#000000", bg = "#000000" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#000000", bg = "#000000" })

    -- Selected items barely visible
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#1a1a1a" })
    vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#1a1a1a" })

    -- Tone down annoying diagnostic squigglies
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#3B4252", undercurl = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = "#3B4252", undercurl = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = "#3B4252", undercurl = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = "#3B4252", undercurl = true })
  end,
})

-- Trigger after colorscheme loads
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      vim.cmd("doautocmd ColorScheme")
    end)
  end,
})
