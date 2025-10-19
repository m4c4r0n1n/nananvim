-- Save as ~/.config/nvim/lua/core/appearance.lua
-- Then add require("core.appearance") to your init.lua AFTER the colorscheme loads

-- Disable cursor line highlighting
vim.opt.cursorline = false
vim.opt.cursorcolumn = false

-- Set background
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Core backgrounds
    local black_groups = {
      "Normal",
      "NormalFloat",
      "NormalNC",
      "SignColumn",
      "LineNr",
      "CursorLineNr",
      "CursorLine",
      "CursorColumn",
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
      -- Telescope
      "TelescopeNormal",
      "TelescopePromptNormal",
      "TelescopeResultsNormal",
      "TelescopePreviewNormal",
      -- Completion menu
      "Pmenu",
      "PmenuSbar",
    }

    for _, group in ipairs(black_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "#000000" })
    end

    -- Dashboard text colors
    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#88C0D0", bg = "#000000", bold = true })
    vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#5E81AC", bg = "#000000" })
    vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#D8DEE9", bg = "#000000" })
    vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#A3BE8C", bg = "#000000" })
    vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#81A1C1", bg = "#000000" })

    -- Make EndOfBuffer invisible
    vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#000000", bg = "#000000" })

    -- File explorer and picker borders
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#5E81AC", bg = "#000000" })
    vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { fg = "#5E81AC", bg = "#000000" })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#5E81AC", bg = "#000000" })

    -- Telescope borders
    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#5E81AC", bg = "#000000" })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#5E81AC", bg = "#000000" })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#5E81AC", bg = "#000000" })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#5E81AC", bg = "#000000" })

    -- Make main window separators invisible (between code splits)
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#000000", bg = "#000000" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#000000", bg = "#000000" })

    -- Selected items barely visible
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#1a1a1a" })
    vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#1a1a1a" })

    -- Tone down those annoying diagnostic squigglies
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
