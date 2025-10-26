# nananvim Keybindings Reference

Leader key is `<Space>`.

## Navigation

### File & Buffer Navigation
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `f` | Find files | Normal | Telescope file picker |
| `<leader>fg` | Live grep | Normal | Search text in all files |
| `<leader>fb` | Buffer list | Normal | Show open buffers |
| `<leader>fo` | Recent files | Normal | Show recently opened files |
| `<leader>fh` | Help tags | Normal | Search Neovim help |
| `<leader>fc` | Colorschemes | Normal | Preview and select themes |
| `<leader>fr` | Resume | Normal | Resume last Telescope picker |
| `<leader>:` | Command history | Normal | Browse command history |

### Window Navigation
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<C-h>` | Go left | Normal | Move to left window |
| `<C-j>` | Go down | Normal | Move to lower window |
| `<C-k>` | Go up | Normal | Move to upper window |
| `<C-l>` | Go right | Normal | Move to right window |
| `<C-w>v` | Split vertical | Normal | Create vertical split |
| `<C-w>s` | Split horizontal | Normal | Create horizontal split |
| `<C-w>q` | Close window | Normal | Close current window |

### Buffer Management
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<S-h>` | Previous buffer | Normal | Cycle to previous buffer |
| `<S-l>` | Next buffer | Normal | Cycle to next buffer |
| `[b` | Previous buffer | Normal | Alternative prev buffer |
| `]b` | Next buffer | Normal | Alternative next buffer |
| `<leader>bp` | Pin buffer | Normal | Pin/unpin buffer |
| `<leader>bP` | Delete non-pinned | Normal | Close all unpinned buffers |
| `<leader>bo` | Delete others | Normal | Close all other buffers |

## File Explorer (Neo-tree)

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>e` | Toggle explorer | Normal | Open/close file tree |
| `<leader>o` | Focus explorer | Normal | Focus file tree |
| `H` | Toggle hidden | Neo-tree | Show/hide hidden files |
| `a` | Add file | Neo-tree | Create new file |
| `A` | Add directory | Neo-tree | Create new directory |
| `d` | Delete | Neo-tree | Delete file/directory |
| `r` | Rename | Neo-tree | Rename file/directory |
| `y` | Copy | Neo-tree | Copy file/directory |
| `x` | Cut | Neo-tree | Cut file/directory |
| `p` | Paste | Neo-tree | Paste file/directory |
| `c` | Copy to clipboard | Neo-tree | Copy path to clipboard |
| `<CR>` | Open | Neo-tree | Open file/directory |

## Language Server (LSP)

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `gd` | Go to definition | Normal | Jump to symbol definition |
| `gD` | Go to declaration | Normal | Jump to symbol declaration |
| `gr` | Find references | Normal | List all references |
| `gi` | Go to implementation | Normal | Jump to implementation |
| `gt` | Go to type definition | Normal | Jump to type definition |
| `K` | Hover | Normal | Show hover documentation |
| `<C-k>` | Signature help | Normal/Insert | Show function signature |
| `<leader>ca` | Code action | Normal/Visual | Show available code actions |
| `<leader>rn` | Rename | Normal | Rename symbol |
| `<leader>cf` | Format | Normal/Visual | Format code |
| `<leader>th` | Toggle hints | Normal | Toggle inlay hints |
| `]d` | Next diagnostic | Normal | Jump to next error/warning |
| `[d` | Previous diagnostic | Normal | Jump to previous error/warning |
| `<leader>d` | Show diagnostic | Normal | Show diagnostic message |
| `<leader>dl` | List diagnostics | Normal | List all diagnostics |

## Git Integration

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `]h` | Next hunk | Normal | Jump to next git change |
| `[h` | Previous hunk | Normal | Jump to previous git change |
| `<leader>hs` | Stage hunk | Normal | Stage current hunk |
| `<leader>hr` | Reset hunk | Normal | Undo changes in hunk |
| `<leader>hS` | Stage buffer | Normal | Stage entire file |
| `<leader>hR` | Reset buffer | Normal | Undo all changes in file |
| `<leader>hu` | Undo stage | Normal | Unstage hunk |
| `<leader>hp` | Preview hunk | Normal | Preview changes in hunk |
| `<leader>hb` | Blame line | Normal | Show git blame for line |
| `<leader>hd` | Diff this | Normal | Show diff view |

## Completion & Snippets

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<C-Space>` | Trigger completion | Insert | Manually trigger completion |
| `<C-n>` | Next item | Insert | Select next completion item |
| `<C-p>` | Previous item | Insert | Select previous completion item |
| `<C-d>` | Scroll docs down | Insert | Scroll completion docs down |
| `<C-f>` | Scroll docs up | Insert | Scroll completion docs up |
| `<CR>` | Confirm | Insert | Accept selected completion |
| `<C-y>` | Confirm | Insert | Accept selected completion (alt) |
| `<Tab>` | Next item | Insert | Next completion item |
| `<S-Tab>` | Previous | Insert | Previous completion item |
| `<C-e>` | Close | Insert | Close completion menu |

## AI Features

### Codeium (Free Inline Suggestions)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<Tab>` | Accept suggestion | Insert | Accept Codeium suggestion |
| `<M-]>` | Next suggestion | Insert | Show next suggestion |
| `<M-[>` | Previous suggestion | Insert | Show previous suggestion |
| `<C-]>` | Dismiss | Insert | Dismiss suggestion |

### Avante (AI Chat - Optional)
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>aa` | Ask AI | Normal/Visual | Ask Avante a question |
| `<leader>ae` | Edit with AI | Visual | Edit selection with AI |
| `<leader>ar` | Refresh | Normal | Refresh Avante response |
| `<leader>at` | Toggle window | Normal | Toggle Avante sidebar |
| `<leader>ac` | Open chat | Normal | Open Avante chat |
| `<leader>af` | Focus window | Normal | Focus Avante window |

**Note:** Avante only works if you've configured an AI provider in `lua/config/local.lua`

## Code Editing

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `gcc` | Comment line | Normal | Toggle comment on line |
| `gc` | Comment | Visual | Toggle comment on selection |
| `gbc` | Block comment | Normal | Toggle block comment |
| `>` | Indent | Visual | Indent selection |
| `<` | Unindent | Visual | Unindent selection |
| `<A-j>` | Move line down | Normal/Visual | Move line/selection down |
| `<A-k>` | Move line up | Normal/Visual | Move line/selection up |
| `ys` | Add surround | Normal | Add surround (quotes, brackets) |
| `ds` | Delete surround | Normal | Remove surround |
| `cs` | Change surround | Normal | Change surround |

## Diagnostics & Problems

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>xx` | Document diagnostics | Normal | Show file diagnostics |
| `<leader>xX` | Workspace diagnostics | Normal | Show all diagnostics |
| `<leader>xL` | Location list | Normal | Open location list |
| `<leader>xQ` | Quickfix list | Normal | Open quickfix list |
| `<leader>xt` | Todo list | Normal | Show all TODOs |
| `<leader>xT` | Todo/Fix list | Normal | Show TODOs and FIXMEs |
| `]t` | Next todo | Normal | Jump to next TODO |
| `[t` | Previous todo | Normal | Jump to previous TODO |

## Terminal

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<C-\>` | Toggle terminal | Normal/Terminal | Toggle floating terminal |
| `<Esc>` | Exit terminal mode | Terminal | Return to normal mode |
| `<C-h/j/k/l>` | Navigate | Terminal | Navigate from terminal |

## Utility

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<C-s>` | Save | Normal/Insert/Visual | Save current file |
| `<leader>q` | Quit | Normal | Quit current window |
| `<leader>Q` | Quit all | Normal | Quit Neovim |
| `<Esc>` | Clear search | Normal | Clear search highlighting |
| `<leader>l` | Lazy | Normal | Open plugin manager |
| `<leader>m` | Mason | Normal | Open LSP installer |
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

## Text Objects

| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `iw` | Inner word | Visual/Operator | Select inner word |
| `aw` | A word | Visual/Operator | Select a word |
| `is` | Inner sentence | Visual/Operator | Select inner sentence |
| `as` | A sentence | Visual/Operator | Select a sentence |
| `ip` | Inner paragraph | Visual/Operator | Select inner paragraph |
| `ap` | A paragraph | Visual/Operator | Select a paragraph |
| `i"` | Inner quotes | Visual/Operator | Select inside quotes |
| `a"` | Around quotes | Visual/Operator | Select around quotes |
| `i(` | Inner parens | Visual/Operator | Select inside parentheses |
| `a(` | Around parens | Visual/Operator | Select around parentheses |
| `i{` | Inner braces | Visual/Operator | Select inside braces |
| `a{` | Around braces | Visual/Operator | Select around braces |
| `i[` | Inner brackets | Visual/Operator | Select inside brackets |
| `a[` | Around brackets | Visual/Operator | Select around brackets |
| `it` | Inner tag | Visual/Operator | Select inside HTML tag |
| `at` | Around tag | Visual/Operator | Select around HTML tag |

## Custom Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/formatter installer |
| `:LspInfo` | Show LSP status for current buffer |
| `:TSInstallInfo` | Show Treesitter parser info |
| `:checkhealth` | Run health checks |
| `:TokenCount` | Count tokens in current buffer |
| `:AvanteToggle` | Toggle Avante window (if configured) |
| `:AvanteChat` | Open Avante chat (if configured) |
| `:TodoTrouble` | Show all project TODOs |
| `:Neotree reveal` | Reveal current file in tree |

## Tips

- Most commands work with counts: `3dd` deletes 3 lines
- Commands can be combined: `ci"` changes text inside quotes
- Use `:` to enter command mode for more options
- Press `g?` in any mode for context-specific help
- The which-key plugin shows available keys when you pause
- Codeium provides free AI suggestions - just start typing!
- Configure Avante in `lua/config/local.lua` for AI chat features
