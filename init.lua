vim.opt.number = true          -- Absolute line numbers ALWAYS
vim.opt.relativenumber = false -- No relative
vim.opt.signcolumn = "auto:2"  -- Gutter for signs (errors) without shrinking text; "auto:2" reserves 2 colsrequire
require("core.options")
require("core.plugins")
