# nananvim Keybindings Reference

Leader key is `<Space>`. Press it and wait: which-key shows every group. `<leader>?` shows the keys for the current buffer, `<leader>fk` searches all keymaps.

## Navigation

### File & Buffer Navigation
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>f` | Find files | Normal | Snacks picker in cwd (bare `f` stays the native find-in-line motion) |
| `<leader>ff` | Find files (home) | Normal | Search files under `~` |
| `<leader>fa` | Find all files (home) | Normal | Include hidden/ignored files under `~` |
| `<leader>fc` | Find config file | Normal | Search your nvim config |
| `<leader>fg` | Live grep | Normal | Search text in all files |
| `<leader>fw` | Grep word | Normal/Visual | Grep the word under the cursor or the selection |
| `<leader>fb` | Buffer list | Normal | Show open buffers |
| `<leader>fo` | Recent files | Normal | Show recently opened files |
| `<leader>fp` | Projects | Normal | Switch between recent projects |
| `<leader>fh` | Help tags | Normal | Search Neovim help |
| `<leader>fk` | Keymaps | Normal | Search all keymaps |
| `<leader>fr` | Resume | Normal | Resume last picker |
| `<leader>:` | Command history | Normal | Browse command history |

### Jump Anywhere (Flash)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `s` | Flash jump | Normal/Visual/Operator | Type 1-2 characters, then the label to jump |
| `S` | Flash treesitter | Normal/Operator | Select a syntax node by label |
| `r` | Remote flash | Operator | Act on a far spot without moving (`yr`...) |
| `R` | Treesitter search | Operator/Visual | Search, then select the matching node |
| `<C-s>` | Toggle flash | Command (`/`) | Show flash labels on search matches |

`f`, `F`, `t`, `T` are the native motions.

### Files You Use Most (Harpoon)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>H` | Mark file | Normal | Add the current file to the list |
| `<leader>j` | Marked files | Normal | Show the list (edit lines to reorder or remove) |
| `<leader>1`-`<leader>5` | Jump | Normal | Open marked file 1 to 5 |

### Sessions
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `s` | Restore session | Dashboard | Reopen this folder's files and splits |
| `<leader>Ss` | Restore session | Normal | This folder's last session |
| `<leader>Sl` | Restore last | Normal | The last session, any folder |
| `<leader>SS` | Select session | Normal | Pick from all saved sessions |
| `<leader>Sd` | Don't save | Normal | Skip saving the session on quit |

### Window Navigation
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<C-h>` | Go left | Normal | Move to left window |
| `<C-j>` | Go down | Normal | Move to lower window |
| `<C-k>` | Go up | Normal | Move to upper window |
| `<C-l>` | Go right | Normal | Move to right window |
| `<C-Up>` / `<C-Down>` | Resize height | Normal | Decrease / increase window height |
| `<C-Left>` / `<C-Right>` | Resize width | Normal | Decrease / increase window width |
| `<leader>-` | Split below | Normal | Horizontal split |
| `<leader>\|` | Split right | Normal | Vertical split |
| `<C-w>v` | Split vertical | Normal | Create vertical split |
| `<C-w>s` | Split horizontal | Normal | Create horizontal split |
| `<C-w>q` | Close window | Normal | Close current window |

Inside tmux, `<C-h/j/k/l>` also move into tmux panes (add the tmux half from the [vim-tmux-navigator README](https://github.com/christoomey/vim-tmux-navigator)). In Neovide, `<C-=>` / `<C-->` / `<C-0>` zoom in / out / reset and `<C-S-v>` pastes.

### Buffer Management
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `[b` / `]b` | Previous / next buffer | Normal | Cycle buffers |
| `[B` / `]B` | Move buffer | Normal | Move the buffer left / right in the bufferline |
| `<leader>bd` | Delete buffer | Normal | Close the buffer and keep the window layout |
| `<leader>bp` | Pin buffer | Normal | Pin/unpin buffer |
| `<leader>bP` | Delete non-pinned | Normal | Close all unpinned buffers |
| `<leader>bo` | Delete others | Normal | Close all other buffers |

## File Explorer (Neo-tree)

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>e` | Toggle explorer | Normal | Open/close file tree (also opens on `nvim .`) |
| `<leader>o` | Focus explorer | Normal | Focus file tree |
| `H` | Toggle hidden | Neo-tree | Show/hide hidden files |
| `a` | Add file | Neo-tree | Create new file (end with `/` for a directory) |
| `A` | Add directory | Neo-tree | Create new directory |
| `d` | Delete | Neo-tree | Delete file/directory |
| `r` | Rename | Neo-tree | Rename file/directory (LSP imports update) |
| `y` | Copy | Neo-tree | Copy file/directory |
| `x` | Cut | Neo-tree | Cut file/directory |
| `p` | Paste | Neo-tree | Paste file/directory |
| `c` | Copy to | Neo-tree | Copy to a path you type |
| `<CR>` | Open | Neo-tree | Open file/directory |

### oil.nvim (edit the file system like text)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `-` | Parent folder | Normal | Open the current file's folder (again: go up) |
| `<CR>` | Open | Oil | Open file or folder |
| edit + `:w` | Apply | Oil | Rename, delete (`dd`), move (cut/paste), create (new line) |
| `q` | Close | Oil | Close oil |

## Language Server (LSP)

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `gd` | Go to definition | Normal | Picker with preview |
| `gD` | Go to declaration | Normal | Picker with preview |
| `gr` | Find references | Normal | Picker with preview |
| `gi` | Go to implementation | Normal | Picker with preview |
| `gy` | Go to type definition | Normal | Picker with preview |
| `K` | Hover | Normal | Show hover documentation |
| `<C-k>` | Signature help | Insert | Show function signature (insert-only so it doesn't shadow window-up nav) |
| `<leader>ca` | Code action | Normal/Visual | Show available code actions |
| `<leader>rn` | Rename | Normal | Rename symbol |
| `<leader>cR` | Rename file | Normal | Rename the file and update imports |
| `<leader>cf` | Format | Normal/Visual | Format code |
| `<leader>cd` | Line diagnostics | Normal | Show diagnostics for the line in a float |
| `<leader>ss` | Symbols | Normal | Symbols in the buffer |
| `<leader>sS` | Workspace symbols | Normal | Symbols in the project |
| `<leader>ih` | Toggle inlay hints | Normal | Toggle LSP inlay hints |
| `]d` / `[d` | Next / previous diagnostic | Normal | Jump to next/previous error or warning |
| `]e` / `[e` | Next / previous error | Normal | Errors only, with a float |
| `]w` / `[w` | Next / previous warning | Normal | Warnings only, with a float |
| `]]` / `[[` | Next / previous reference | Normal | Jump between uses of the word under the cursor |

Neovim's built-in LSP keys also work: `grn` rename, `gra` code action, `grr` references, `gri` implementation, `grt` type definition, `gO` document symbols, `<C-s>` signature help (insert).

## Debugging (DAP)

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>db` | Toggle breakpoint | Normal | Set/remove a breakpoint on the current line |
| `<leader>dc` | Continue / start | Normal | Start debugging, or continue (attach, for Lua) |
| `<leader>di` | Step into | Normal | Step into the function call |
| `<leader>do` | Step over | Normal | Step over the current line |
| `<leader>dO` | Step out | Normal | Step out of the current function |
| `<leader>dr` | Open REPL | Normal | Open the debug REPL |
| `<leader>dl` | Run last | Normal | Re-run the last debug configuration |
| `<leader>dL` | Launch Lua server | Normal | Start osv in the debuggee (Lua two-instance debugging) |
| `<leader>dt` | Terminate | Normal | Stop the debug session |
| `<leader>du` | Toggle DAP UI | Normal | Open/close the debug UI panels |
| `<leader>dh` | Hover variables | Normal | Show variable values under the cursor |
| `<leader>dS` | Scopes | Normal | Show scope variables in a float |
| `<leader>dB` | Conditional breakpoint | Normal | Stop only when a condition is true |
| `<leader>dp` | Log point | Normal | Print a message instead of stopping |
| `<leader>dC` | Run to cursor | Normal | Continue to the cursor line |

## Testing (neotest)

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>Tr` | Run nearest | Normal | Run the test under the cursor |
| `<leader>Tt` | Run file | Normal | Run the tests in this file |
| `<leader>TT` | Run all | Normal | Run every test in the project |
| `<leader>Tl` | Run last | Normal | Run the last test again |
| `<leader>Td` | Debug nearest | Normal | Run the nearest test in the debugger |
| `<leader>Tw` | Watch | Normal | Run the file's tests on every save |
| `<leader>Ts` | Summary | Normal | Test tree with pass/fail |
| `<leader>To` | Output | Normal | Output of the test under the cursor |
| `<leader>TO` | Output panel | Normal | All test output |
| `<leader>TS` | Stop | Normal | Stop running tests |
| `]T` / `[T` | Next / previous failure | Normal | Jump between failed tests |

## Git Integration

### Hunks (gitsigns)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `]h` / `[h` | Next / previous hunk | Normal | Jump to next/previous git change |
| `]H` / `[H` | Last / first hunk | Normal | Jump to the last/first change |
| `<leader>hs` | Stage/unstage hunk | Normal/Visual | Toggle staging (visual: stage only the selected lines) |
| `<leader>hr` | Reset hunk | Normal/Visual | Undo changes in hunk (visual: selected lines) |
| `<leader>hS` | Stage buffer | Normal | Stage entire file |
| `<leader>hR` | Reset buffer | Normal | Undo all changes in file |
| `<leader>hp` | Preview hunk | Normal | Preview the change inline |
| `<leader>hb` | Blame line | Normal | Show git blame for line |
| `<leader>hB` | Blame buffer | Normal | Blame the whole file in a side window |
| `<leader>hd` | Diff this | Normal | Diff against the index |
| `<leader>hD` | Diff this ~ | Normal | Diff against the last commit |
| `ih` | Inside hunk | Visual/Operator | Text object for the hunk (`dih`, `vih`) |

### Git Tools
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>gg` | Lazygit | Normal | Full git UI in a float (needs `lazygit`) |
| `<leader>gl` | Lazygit log | Normal | Commit log for the current file |
| `<leader>gs` | Git status | Normal | Changed files picker |
| `<leader>gc` | Git commits | Normal | Commit log picker |
| `<leader>gb` | Git branches | Normal | Branch picker |
| `<leader>gB` | Git browse | Normal/Visual | Open the file/selection on GitHub |
| `<leader>gd` | Diff view | Normal | All changes side by side, 3-way merge during conflicts (`q` closes) |
| `<leader>gh` | File history | Normal | Every commit that changed this file |
| `<leader>gH` | Branch history | Normal | Commit history of the branch |

## Completion & Snippets (blink.cmp)

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<C-Space>` | Trigger completion | Insert | Show the menu (again: toggle docs) |
| `<C-n>` / `<C-p>` | Next / previous item | Insert | Move in the menu |
| `<Tab>` / `<S-Tab>` | Next / previous item | Insert | Move in the menu, then jump in snippets |
| `<CR>` | Confirm | Insert | Accept the selected item (nothing selected: new line) |
| `<C-y>` | Select and accept | Insert | Accept the first item at once |
| `<C-e>` | Close | Insert | Close the completion menu |
| `<C-f>` / `<C-d>` | Scroll docs | Insert | Scroll the documentation down / up |

The command line (`:`, `/`) has completion too.

## AI Features

### Windsurf or Copilot (Inline Suggestions, opt-in via `lua/config/local.lua`)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<Tab>` | Accept suggestion | Insert | Accept the suggestion (the completion menu gets `<Tab>` first while it is open) |
| `<M-]>` | Next suggestion | Insert | Show next suggestion |
| `<M-[>` | Previous suggestion | Insert | Show previous suggestion |
| `<C-]>` | Dismiss | Insert | Dismiss suggestion (Windsurf) |

### Avante (AI Chat, opt-in)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>aa` | Ask AI | Normal/Visual | Ask Avante a question |
| `<leader>ae` | Edit with AI | Visual | Edit selection with AI |
| `<leader>ar` | Refresh | Normal | Refresh Avante response |
| `<leader>at` | Toggle window | Normal | Toggle Avante sidebar |
| `<leader>ac` | Open chat | Normal | Open Avante chat |
| `<leader>af` | Focus window | Normal | Focus Avante window |

**Note:** Avante defaults to Claude (`ANTHROPIC_API_KEY`); configure a different provider in `lua/config/local.lua`.

## Code Editing

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `gcc` | Comment line | Normal | Toggle comment on line (built in, treesitter-aware) |
| `gc` | Comment | Visual/Operator | Toggle comment (`gcip` comments a paragraph) |
| `gco` / `gcO` | Comment below / above | Normal | Open a new comment line |
| `J` | Join lines | Normal | Join without moving the cursor |
| `<C-n>` | Add cursor | Normal/Visual | Add a cursor at the next match (`<Esc>` back to one) |
| `<C-p>` | Skip match | Normal/Visual | Skip this match while adding cursors |
| `<leader>M` | Cursors at all matches | Normal/Visual | One cursor on every match |
| `<C-q>` | Toggle cursor | Normal/Visual | Add or remove a cursor here |
| `>` / `<` | Indent / unindent | Visual | Indent and keep the selection |
| `<A-j>` / `<A-k>` | Move line down / up | Normal/Visual | Move line/selection |
| `<leader>P` | Paste and keep | Visual | Paste over the selection without losing the register |
| `ys` | Add surround | Normal | Add surround (quotes, brackets) |
| `ds` | Delete surround | Normal | Remove surround |
| `cs` | Change surround | Normal | Change surround |
| `S` | Surround selection | Visual | Wrap the selection |
| `<leader>sr` | Search and replace | Normal/Visual | Project-wide replace with live preview (grug-far) |
| `<C-z>,` | Expand Emmet | Insert | Expand an Emmet abbreviation (HTML/CSS/JSX) |

## Diagnostics & Problems

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>xx` | Diagnostics | Normal | All diagnostics (Trouble) |
| `<leader>xX` | Buffer diagnostics | Normal | Current buffer only (Trouble) |
| `<leader>xs` | Symbols | Normal | Symbol outline (Trouble) |
| `<leader>xl` | LSP | Normal | Definitions/references side panel (Trouble) |
| `<leader>xL` | Location list | Normal | Open location list (Trouble) |
| `<leader>xQ` | Quickfix list | Normal | Open quickfix list (Trouble) |
| `<leader>xq` | Quickfix (editable) | Normal | Quickfix you can edit and save; `>` / `<` show more/less context |
| `<leader>xt` | Todo list | Normal | All TODOs (Trouble) |
| `<leader>xT` | Todo/Fix list | Normal | TODO, FIX and FIXME only (Trouble) |
| `<leader>st` | Todo picker | Normal | Search TODO comments |
| `<leader>sd` | Diagnostics picker | Normal | Search diagnostics |
| `]q` / `[q` | Next / previous item | Normal | Trouble item, or quickfix item when Trouble is closed |
| `]t` / `[t` | Next / previous todo | Normal | Jump to next/previous TODO |

## Search

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>sb` | Buffer lines | Normal | Fuzzy search lines in the buffer |
| `<leader>su` | Undo history | Normal | Browse and restore undo states |
| `<leader>sn` | Notifications | Normal | Notification history |
| `<leader>s/` | Search history | Normal | Browse `/` history |
| `<leader>s"` | Registers | Normal | Browse and paste registers |
| `<leader>sm` | Marks | Normal | Jump to a mark |
| `<leader>sj` | Jumps | Normal | Browse the jump list |
| `<leader>sC` | Commands | Normal | Search all commands |
| `<leader>sH` | Highlights | Normal | Search highlight groups |
| `<leader>sq` | Quickfix | Normal | Search the quickfix list |
| `<leader>.` | Scratch buffer | Normal | Floating notes buffer that persists |
| `<leader>s.` | Select scratch | Normal | Pick a scratch buffer |
| `<leader>fy` / `<leader>fY` | Copy path | Normal | Copy the relative / absolute file path |

## UI Toggles

which-key shows the current state of each toggle.

| Key | Toggle |
|-----|--------|
| `<leader>uf` | Format on save |
| `<leader>us` | Spelling |
| `<leader>uw` | Wrap |
| `<leader>ul` | Line numbers |
| `<leader>uL` | Relative numbers |
| `<leader>ud` | Diagnostics |
| `<leader>uh` | Inlay hints |
| `<leader>ug` | Indent guides |
| `<leader>uT` | Treesitter highlight |
| `<leader>uD` | Dim inactive code |
| `<leader>uz` | Zen mode |
| `<leader>uZ` | Zoom the window |
| `<leader>uv` | Diagnostic lines under the code |
| `<leader>ub` | Git blame on the current line |
| `<leader>um` | Render markdown |
| `<leader>uS` | Smooth scrolling |

## Terminal

**There are TWO terminal options:**

### Snacks terminal (Floating Terminal)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<C-\>` | Toggle terminal | Normal/Terminal | Toggle floating terminal (Ctrl+Backslash) |
| `<Esc><Esc>` | Exit terminal mode | Terminal | Return to normal mode (one `<Esc>` goes to the program) |

### Nanabrowser Terminal Panel
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>tt` | Open terminal | Normal | Open terminal in nanabrowser panel |
| `<leader>p` | Toggle panels | Normal | Toggle all nanabrowser panels |

**Note:** `<C-\>` is Control+Backslash, NOT `<leader>C\` (Space+C+Backslash)

## Theme Switcher

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>th` | Theme switcher | Normal | Open theme picker with all installed colorschemes |
| `<leader>tb` | Toggle background | Normal | Toggle blackout ⇄ the theme's own background (blacked out by default) |

### Inside Theme Picker
| Key | Action | Description |
|-----|--------|-------------|
| `j` / `<Down>` | Move down | Navigate theme list |
| `k` / `<Up>` | Move up | Navigate theme list |
| `gg` | Jump to top | Go to first theme |
| `G` | Jump to bottom | Go to last theme |
| `/` | Search mode | Start filtering themes by name |
| `<BS>` | Backspace | Delete character in search (when searching) |
| `<C-c>` | Clear search | Clear search filter completely |
| `<Enter>` | Apply/Exit search | Apply theme and close (or exit search mode) |
| `<Space>` | Apply theme | Apply selected theme and close |
| `p` | Preview | Preview theme (auto-happens on navigation) |
| `q` / `<Esc>` | Close | Close picker (or exit search mode) |

**Background Modes:**
- **Blackout** (default): Pure black (#000000) background, keeping the theme's text/foreground colors
- **Normal**: The theme's own background (`<leader>tb` toggles back to this)
- **Terminal**: Transparent background (available via `:lua require("theme-switcher").set_background("terminal")`)

## Nanabrowser (Web Browser + Terminal + TODO Panels)

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>p` | Toggle panels | Normal | Toggle Browser / Terminal / TODO (tabbed float by default) |
| `<leader>pz` | Zoom panel | Normal | Focus one panel full-size / show all again |
| `<Tab>` / `<S-Tab>` | Cycle panels | Panel | Switch between panels in the float layout |
| `<leader>wb` | Browse URL (in-editor) | Normal | Open URL in the in-editor text browser (auto-detects w3m → lynx → elinks) |
| `<leader>wo` | Open URL (external) | Normal | Open URL in your external browser |
| `gx` | Open URL in browser | Normal/Visual | Open URL under cursor in external browser |
| `<leader>tt` | Open terminal | Normal | Open terminal panel |
| `<leader>td` | Focus TODO | Normal | Focus TODO panel |

**Note:** The in-editor browser is an interactive text browser (w3m/lynx/elinks). If none is installed it falls back to your external browser automatically. For JS-heavy sites use `gx` or `<leader>wo`.

## Utility

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<C-s>` | Save | Normal/Insert/Visual | Save current file |
| `<leader>q` | Quit | Normal | Quit current window |
| `<leader>Q` | Quit all | Normal | Quit Neovim |
| `<Esc>` | Clear search | Normal | Clear search highlighting |
| `n` / `N` | Next / previous match | Normal | Jump and center the match |
| `<C-d>` / `<C-u>` | Half page | Normal | Scroll and keep the cursor centered |
| `<leader>l` | Lazy | Normal | Open plugin manager |
| `<leader>m` | Mason | Normal | Open LSP/tool installer |
| `<leader>?` | Buffer keymaps | Normal | which-key for the current buffer |
| `q` | Close | Help/quickfix/tool windows | Close the window |
| `u` | Undo | Normal | Undo last change |
| `<C-r>` | Redo | Normal | Redo last undo |
| `.` | Repeat | Normal | Repeat last command |

## Visual Mode

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `v` | Character select | Normal | Enter visual mode |
| `V` | Line select | Normal | Enter line visual mode |
| `<C-v>` | Block select | Normal | Enter block visual mode |
| `gv` | Reselect | Normal | Reselect last selection |
| `o` | Other end | Visual | Jump to other end of selection |
| `O` | Other corner | Visual Block | Jump to other corner |

## Treesitter Selection

Smart node-aware selection, built in to Neovim 0.12 (`an` / `in`). Each press expands to the enclosing node (expression → statement → block → function → ...).

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<C-Space>` | Start selection | Normal | Select the node under cursor |
| `<C-Space>` | Expand selection | Visual | Grow selection to parent node |
| `<BS>` | Shrink selection | Visual | Step back to a child node |
| `]n` / `[n` | Next / previous node | Visual | Move the selection to a sibling node |

## Text Objects

### Treesitter (code-aware)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `af` / `if` | Function | Visual/Operator | Around / inside function |
| `ac` / `ic` | Class | Visual/Operator | Around / inside class |
| `aa` / `ia` | Argument | Visual/Operator | Around / inside argument |
| `]f` / `[f` | Function start | Normal/Visual/Operator | Next / previous function |
| `]F` / `[F` | Function end | Normal/Visual/Operator | Next / previous function end |
| `]c` / `[c` | Class start | Normal/Visual/Operator | Next / previous class (diff mode: next / previous change) |
| `]a` / `[a` | Argument | Normal/Visual/Operator | Next / previous argument |
| `[x` | Context | Normal | Jump to the context line pinned at the top |

### Built-in
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `iw` / `aw` | Word | Visual/Operator | Inner word / a word |
| `is` / `as` | Sentence | Visual/Operator | Inner sentence / a sentence |
| `ip` / `ap` | Paragraph | Visual/Operator | Inner paragraph / a paragraph |
| `i"` / `a"` | Quotes | Visual/Operator | Inside / around quotes |
| `i(` / `a(` | Parens | Visual/Operator | Inside / around parentheses |
| `i{` / `a{` | Braces | Visual/Operator | Inside / around braces |
| `i[` / `a[` | Brackets | Visual/Operator | Inside / around brackets |
| `it` / `at` | Tag | Visual/Operator | Inside / around HTML tag |

## Custom Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/formatter installer |
| `:checkhealth nananvim` | Check every external tool the config uses |
| `:checkhealth vim.lsp` | Show LSP status for current buffer (`:LspInfo` is an alias) |
| `:lsp restart` | Restart the LSP servers |
| `:ConformInfo` | Show which formatter runs for this buffer |
| `:FormatToggle` | Toggle format on save (`!` for the current buffer only) |
| `:NananvimUpdate` | Pull the latest nananvim and the tested plugin versions |
| `:SudaWrite` / `:SudaRead` | Save or open a file that needs root |
| `:LspCopilotSignIn` | Sign in to Copilot (when `suggestions = "copilot"`) |
| `:TokenCount [model]` | Exact Claude token count of the buffer or selection (needs `ANTHROPIC_API_KEY`, else a rough estimate) |
| `:TSUpdate` | Update installed treesitter parsers |
| `:TSInstall <lang>` | Install a specific parser |
| `:TSUninstall <lang>` | Remove a parser |
| `:TSLog` | Show treesitter install log |
| `:GrugFar` | Open search and replace |
| `:AvanteToggle` | Toggle Avante window (if configured) |
| `:AvanteChat` | Open Avante chat (if configured) |
| `:Neotree reveal` | Reveal current file in tree |

## Tips

- Most commands work with counts: `3dd` deletes 3 lines
- Commands can be combined: `ci"` changes text inside quotes, `daa` deletes an argument, `yif` yanks a function body
- Use `:` to enter command mode for more options
- The which-key plugin shows available keys when you pause
- AI is opt-in: create `lua/config/local.lua` to enable Windsurf suggestions and Avante chat (`return {}` is enough)
- Configure Avante's provider in that same `lua/config/local.lua`
