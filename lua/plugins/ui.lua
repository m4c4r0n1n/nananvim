return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      -- snacks.image finds Ghostty only with a terminal query. This query can fail.
      -- Ghostty always sets TERM_PROGRAM. Thus tell snacks that the kitty
      -- graphics protocol is available (SNACKS_GHOSTTY is the snacks override).
      if vim.env.TERM_PROGRAM == "ghostty" then
        vim.env.SNACKS_GHOSTTY = "1"
      end

      -- Use the header from lua/config/dashboard.lua if that file exists.
      local ok, custom = pcall(require, "config.dashboard")
      local header = [[

⠀⠀⠀⠀⠀⠠⠀⠀⠀⢀⠤⢦⠤⠁⣤⢤⡀⢰⣇⣀⠃⠀⠀⠀⠠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠁⠀⠀⠀⠀⠀⠀⠀⠈⠀⠈⠀⠀⠋⠐⠁⠙⠋⠉⠒⠀⠀⠀⠚⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣀⣄⠀⢀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠛⠛⠛⠛⠛⢻⣿⣿⣿⣿⣿⣿⣧⣙⣁⣀⣀⣀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⣭⣭⣭⣽⢿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠒⠒⠒⠒⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠶⠶⠶⠖⠒⠀⠉⠉⠉⠉⠉⠉
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠢⣴⣶⣶⣶⣶⡶⠶⡶⠄⠒⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⢶⣾⡿⢻⡏⠛⢿⡿⠛⢿⡿⠿⣿⡿⣿⣶⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⢀⠀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⡟⡛⢷⡈⣿⣿⠘⣇⢸⢸⡇⠇⣸⠢⠙⡟⢠⢸⣿⡿⢙⢉⣿⣷⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣏⣿⣿⣿⣿⣿⣟⠛⢿⠟⠟⠁⠀⠀⣠⣶⣿⣟⠩⣹⣿⣧⣙⣸⣧⣿⣿⣷⣿⣿⡿⠛⠛⢿⣿⣿⣷⣶⣾⣿⣁⡃⣾⢁⣂⣿⠿⢿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠀⠈⠀⠈⠀⠀⢀⣴⡿⢿⡍⢦⠹⣆⣡⣿⣿⣿⠿⠟⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠉⠉⠙⠛⠻⢿⣿⣿⣦⣾⡩⠍⣼⠋⣹⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡔⢦⢹⣦⣷⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣾⣥⣾⣝⡿⠛⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⡋⠽⠻⣿⣶⣿⡿⠛⠁⠀⠀⠀⠀⢀⣠⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣄⡀⠀⠀⠀⠀⠈⠻⣿⣿⣯⡴⢋⠌⣹⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡟⢉⠛⢯⣵⣿⡿⠋⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⠀⠀⠀⠀⠙⢿⣿⣥⠞⣩⠜⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠯⠙⢷⣭⣾⣿⠏⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠈⠻⣿⣷⣴⠞⣋⣹⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄
⠀⠀⠀⠀⣴⣶⣶⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣯⣑⡀⢲⣿⡿⠃⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠙⣿⣷⡞⣋⠩⢹⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⣶⣶
⣤⣶⣶⣶⣮⣿⣿⣿⣿⣉⣉⣉⣀⣠⣀⣠⣦⣄⣀⣀⣀⡀⢀⡀⠀⠀⠀⠀⠀⠀⠀⣾⡛⠻⠿⣿⣿⡿⠁⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠘⣿⣿⡶⢿⢋⢻⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣭⣭⡍⠉⠍⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⢿⣿⣿⣶⣿⣿⠁⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠘⣿⣷⣥⣾⣾⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠼⠟⠛⠛
⠿⣿⣿⡿⣶⢿⡿⠿⠾⠿⠏⠉⠎⠉⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡂⠢⠌⣽⣿⡇⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀
⢻⠄⠸⡤⠀⠀⠘⠀⠀⠀⠐⠀⠀⠐⠤⠠⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⢉⣛⣻⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠈⠀⡀⠀⠀⠀⢀⠀⠀⠀⠐⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣷⠶⡤⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣰⣛⣙⣋⣉⣛⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⣀⣓⣼⣿⡏⠉⠉⠉⢹⣿⣿⣿⣿⣿⣿⡿⠋⣀⣀⣤⣀⡀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⣀⣠⣤⣄⣀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣿⣿⡿⢿⣿⣿⣿⣄⣤⢀⠀⠀⢀⡀⣠⠀⠀⠀⠀⠐⠲⠂⠂⠀⠀⠀⠀⠀⠀⣿⣍⣩⣭⣼⣿⣇⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣧⣾⣿⣿⣿⣿⣿⣷⣼⣿⣿⣿⣿⣿⣿⣿⣿⣧⣾⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣉⣉⣉⠉⠉⠉⠉⠉⠉⠉⠁⠉⠉⠉⠉⠉⠁⠉⠉⠏⠉⠁⠀⠀⠀⠀⠀⠀⠀⢸⣿⠁⠓⢸⣿⣿⠀⠀⠀⠘⣿⣿⣯⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⣿⣿⣿⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠰⠤
⠉⠁⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡛⠛⢛⣿⣿⡆⠀⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠚
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⢛⣩⠹⢿⣷⠀⠀⠀⠈⢿⣿⣿⡄⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⣰⣿⣿⡿⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡀⣀⣀⠀⣀⣀⣀⣀⣀⣀⣀⢀⣀⡀⣀⢀⣀⡀⣀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣤⣶⣾⣿⣿⣧⠀⠀⠀⠈⢿⣿⣿⣄⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⣴⣿⣿⡟⠁⠀⠀⢀⣾⣿⡟⠿⢿⣿⣿⡏⠀⠀⣐⣐⣤⣴⣶⣤⣤⣾⣶⣴⣦⣤⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠓⠀⠐⠀⠒⠀⠀⠀⠀⠐⠒⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡿⠛⡩⠄⣻⣿⣧⡀⠀⠀⠈⠻⣿⣿⣷⣄⠀⠀⠀⠈⠙⠻⠿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠉⠀⠀⠀⠀⣠⣾⣿⣿⠏⠀⠀⠀⢀⣾⣿⡿⣿⣷⣦⣼⡟⠀⠀⠈⠉⠉⡉⢉⡉⣉⣉⣩⣿⣿⣿⣿⣿⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⠶⣿⡿⠿⣿⣷⡄⠀⠀⠀⠈⠻⣿⣿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠀⠀⠀⣀⣴⣿⣿⣿⠟⠁⠀⠀⠀⣠⣿⣿⡟⠶⣤⣉⣿⡟⠀⠀⢀⠀⢀⠀⠠⢤⡄⣤⣉⣀⣘⣋⣉⣻⢙⣿⣿⣿⣿⣿⣿⣬⣿⣿⢛⣯⢿⣿⡻⢿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣞⣩⣴⣿⡿⣿⣿⣦⡀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣶⣤⣄⣀⣀⣀⣀⣀⣀⣀⣀⣤⣴⣶⣿⣿⣿⡿⠛⠁⠀⠀⠀⢀⣼⣿⡿⠷⣌⡓⣨⣹⡟⠀⠀⠀⠈⠀⠈⠀⠀⠀⠀⠈⠋⠉⠉⠉⠉⠉⠈⠉⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣄⣀⣠⣀⣀⣀⣀⣠⣀⡀⠀⠘⢿⣿⣿⢿⢩⢻⣿⣿⣦⣀⠀⠀⠀⠀⠈⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠋⠁⠀⠀⠀⠀⣠⣴⣿⡿⠻⣦⡑⢌⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠿⡿⠿⢿⠿⣿⠿⣿⢿⣿⠿⠏⠉⠁⠀⠀⠀⠹⣿⣬⣼⠋⠬⣹⣿⣿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠙⠛⠛⠋⠉⠉⠁⠀⠀⠀⠀⠀⠀⣀⣴⣾⣿⠛⠹⢦⡑⢌⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠛⠛⠛⠳⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠀⠀⠈⠻⣿⣬⡼⢋⠀⠋⣿⣿⣿⣿⣶⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣶⣿⣿⣿⠻⡙⣦⡙⢈⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⢀⣀⠀⡀⠀⠀⠀⠀⠀⣀⢀⡀⠀⣀⠀⢀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⣎⣼⣿⠏⡌⣹⠟⠿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣾⣿⣿⣿⡿⡿⠻⣿⣧⠙⣧⣑⣈⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠈⠉⠛⠹⠿⠿⠿⠿⣿⠿⣿⣿⣿⣿⠿⠿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣮⣴⡏⠸⢠⣿⡟⢩⢹⣿⡟⢻⣿⡟⢿⠛⡍⣯⢹⠸⣇⢀⢠⢹⣿⣧⣼⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠁⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠶⢷⣿⣿⡇⣍⣼⢿⡇⢸⣿⡇⢸⣇⣊⣿⣬⣅⣿⣾⣿⠿⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠉⠉⠛⠛⠛⠓⠿⠿⠿⠿⠟⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                             __                    
.-----.---.-.-----.---.-.-----.--.--.|__|.--------.
|     |  _  |     |  _  |     |  |  ||  ||        |
|__|__|___._|__|__|___._|__|__|\___/ |__||__|__|__|
      ]]

      -- Change the header in lua/config/dashboard.lua: return { header = [[...]] }
      if ok and type(custom) == "table" and custom.header then
        header = custom.header
      end

      return {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        notifier = { enabled = true },
        input = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        scope = { enabled = true },
        indent = {
          enabled = true,
          -- Show the indent guide of the current scope only, without animation.
          animate = { enabled = false },
          scope = { enabled = true },
          filter = function(buf)
            local ignore = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "snacks_dashboard" }
            return vim.g.snacks_indent ~= false
              and vim.b[buf].snacks_indent ~= false
              and vim.bo[buf].buftype == ""
              and not vim.tbl_contains(ignore, vim.bo[buf].filetype)
          end,
        },
        image = {
          enabled = true,
          resolve = function(_, src)
            -- Change GitHub blob URLs to raw URLs.
            if src:match("github%.com") and src:match("/blob/") then
              src = src:gsub("github%.com", "raw.githubusercontent.com")
              src = src:gsub("/blob/", "/")
            end
            return src
          end,
        },
        picker = {
          enabled = true,
          -- vim.ui.select (code actions and more) uses the picker.
          ui_select = true,
        },
        lazygit = { enabled = true },
        terminal = { enabled = true },
        zen = { enabled = true },
        dashboard = {
          enabled = true,
          preset = {
            header = header,
            keys = {
              { icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              {
                icon = " ",
                key = "c",
                desc = "Config",
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
              },
              { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
              { icon = " ", key = "m", desc = "Mason", action = ":Mason" },
              { icon = " ", key = "s", desc = "Restore session", section = "session" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          },
        },
      }
    end,
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Hide the cursor on the dashboard. It sits on the first letter of the
      -- selected item and looks like a highlight. A cursor highlight with
      -- blend=100 hides the cursor (see :help tui-cursor-shape).
      -- snacks sets the dashboard filetype with all events off. Thus use its
      -- own SnacksDashboardOpened event, and BufEnter when you come back to it.
      local saved_cursor
      local function hide_cursor()
        if vim.bo.filetype ~= "snacks_dashboard" or saved_cursor then
          return
        end
        vim.api.nvim_set_hl(0, "NananvimHiddenCursor", { blend = 100, nocombine = true })
        saved_cursor = vim.o.guicursor
        vim.o.guicursor = saved_cursor .. ",n:block-NananvimHiddenCursor"
      end
      local function show_cursor(args)
        if saved_cursor and vim.bo[args.buf].filetype == "snacks_dashboard" then
          vim.o.guicursor = saved_cursor
          saved_cursor = nil
        end
      end
      local group = vim.api.nvim_create_augroup("nananvim_dashboard_cursor", { clear = true })
      vim.api.nvim_create_autocmd("User", { group = group, pattern = "SnacksDashboardOpened", callback = hide_cursor })
      vim.api.nvim_create_autocmd("BufEnter", { group = group, callback = hide_cursor })
      vim.api.nvim_create_autocmd("BufLeave", { group = group, callback = show_cursor })
      -- A small arrow beside the key of the selected dashboard item. It is drawn
      -- over the empty space after the key, thus the dashboard does not move.
      -- It has the color of the item text (SnacksDashboardDesc), thus it follows
      -- the theme. Change it with the NananvimDashboardArrow highlight group.
      local arrow_ns = vim.api.nvim_create_namespace("nananvim_dashboard_arrow")
      local function draw_arrow()
        vim.schedule(function()
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].filetype ~= "snacks_dashboard" then
            return
          end
          vim.api.nvim_set_hl(0, "NananvimDashboardArrow", { link = "SnacksDashboardDesc", default = true })
          vim.api.nvim_buf_clear_namespace(buf, arrow_ns, 0, -1)
          local row = vim.api.nvim_win_get_cursor(0)[1] - 1
          local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
          -- The key is the last character on the line of an item.
          local key = line:find("%S%s*$")
          if not key then
            return
          end
          vim.api.nvim_buf_set_extmark(buf, arrow_ns, row, 0, {
            virt_text = { { "\u{f0d9}", "NananvimDashboardArrow" } },
            virt_text_win_col = vim.fn.strdisplaywidth(line:sub(1, key)) + 1,
          })
        end)
      end
      vim.api.nvim_create_autocmd("CursorMoved", { group = group, callback = draw_arrow })
      vim.api.nvim_create_autocmd(
        "User",
        { group = group, pattern = "SnacksDashboardUpdatePost", callback = draw_arrow }
      )
      -- A colorscheme change removes the highlight group. Make it again.
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
          vim.api.nvim_set_hl(0, "NananvimHiddenCursor", { blend = 100, nocombine = true })
        end,
      })

      -- UI toggles under <leader>u. which-key shows the current state of each toggle.
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
          Snacks.toggle.zen():map("<leader>uz")
          Snacks.toggle.zoom():map("<leader>uZ")
          Snacks.toggle.scroll():map("<leader>uS")
          local saved_virtual_text
          Snacks.toggle({
            name = "Diagnostic lines",
            get = function()
              local lines = vim.diagnostic.config().virtual_lines
              return lines ~= nil and lines ~= false
            end,
            set = function(state)
              -- Lines under the code (current line only) replace the text at the end of the line.
              if state then
                saved_virtual_text = vim.diagnostic.config().virtual_text
                vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })
              else
                vim.diagnostic.config({ virtual_lines = false, virtual_text = saved_virtual_text or true })
              end
            end,
          }):map("<leader>uv")
          Snacks.toggle({
            name = "Git blame (line)",
            get = function()
              return require("gitsigns.config").config.current_line_blame
            end,
            set = function(state)
              require("gitsigns").toggle_current_line_blame(state)
            end,
          }):map("<leader>ub")
          Snacks.toggle({
            name = "Render markdown",
            get = function()
              return require("render-markdown.state").enabled
            end,
            set = function(state)
              if state then
                require("render-markdown").enable()
              else
                require("render-markdown").disable()
              end
            end,
          }):map("<leader>um")
          Snacks.toggle({
            name = "Format on save",
            get = function()
              return vim.g.autoformat
            end,
            set = function(state)
              vim.g.autoformat = state
              vim.b.autoformat = nil
            end,
          }):map("<leader>uf")
        end,
      })
    end,
    keys = {
      -- Find
      {
        "<leader>f",
        function()
          Snacks.picker.files()
        end,
        desc = "Find files (cwd)",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files({ cwd = vim.fn.expand("~") })
        end,
        desc = "Find files (home)",
      },
      {
        "<leader>fa",
        function()
          Snacks.picker.files({ cwd = vim.fn.expand("~"), hidden = true, ignored = true })
        end,
        desc = "Find all files (home)",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find config file",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Live grep",
      },
      {
        "<leader>fw",
        function()
          Snacks.picker.grep_word()
        end,
        mode = { "n", "x" },
        desc = "Grep word or selection",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help tags",
      },
      {
        "<leader>fk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>fo",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent files",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command history",
      },
      -- Search
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer lines",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo history",
      },
      {
        "<leader>sn",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification history",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search history",
      },
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jump list",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlight groups",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix list",
      },
      -- Scratch buffers: notes and test code that persist, one per file type.
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Scratch buffer",
      },
      {
        "<leader>s.",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select scratch buffer",
      },
      -- Buffers
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete buffer",
      },
      -- Words: jump between LSP references of the word under the cursor.
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        mode = { "n", "t" },
        desc = "Next reference",
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        mode = { "n", "t" },
        desc = "Previous reference",
      },
      -- Terminal
      {
        "<C-\\>",
        function()
          Snacks.terminal.toggle()
        end,
        desc = "Toggle terminal",
        mode = { "n", "t" },
      },
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete other buffers" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
    },
    opts = {
      options = {
        close_command = function(n)
          Snacks.bufdelete(n)
        end,
        right_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },
  {
    -- Render Markdown in the buffer: headings, tables, code blocks, checkboxes.
    -- The raw text shows on the line under the cursor. <leader>um toggles it.
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
      completions = { blink = { enabled = true } },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
          { "diagnostics" },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1 },
        },
        lualine_x = {
          {
            -- Show "recording @q" while you record a macro.
            -- showmode is off, thus Neovim does not show it in the command line.
            function()
              return "recording @" .. vim.fn.reg_recording()
            end,
            cond = function()
              return vim.fn.reg_recording() ~= ""
            end,
            color = { fg = "#eb6f92" },
          },
          {
            function()
              return require("lazy.status").updates()
            end,
            cond = function()
              return require("lazy.status").has_updates()
            end,
            color = { fg = "#ff9e64" },
          },
          {
            -- Names of the LSP servers on this buffer.
            function()
              local names = {}
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                names[#names + 1] = client.name
              end
              return " " .. table.concat(names, " ")
            end,
            cond = function()
              return #vim.lsp.get_clients({ bufnr = 0 }) > 0
            end,
          },
          { "encoding" },
          { "fileformat" },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy", "mason", "trouble", "oil", "quickfix" },
    },
  },
}
