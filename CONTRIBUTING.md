# Contributing to nananvim

Thanks for considering contributing to nananvim!

## Ground Rules

1. **No bloat** 
2. **Performance matters** 
3. **It has to work**
4. **Keep it readable**

## How to Contribute

### Reporting Bugs

Before creating an issue:
- Run `:checkhealth` and include the output
- Check if it's already reported
- Try with a minimal config to isolate the issue

Include in your bug report:
- Neovim version (`nvim --version`)
- OS and distro
- Steps to reproduce
- Expected vs actual behavior
- Error messages (check `:messages`)
- Relevant config sections

### Suggesting Features

Open an issue with:
- Clear use case
- Potential implementation approach
- Performance impact assessment

### Pull Requests

1. **Fork and branch**
   ```bash
   git clone https://github.com/YOUR_USERNAME/nananvim
   cd nananvim
   git checkout -b feature/your-feature
   ```

2. **Make your changes**
   - Follow existing code style
   - Comment complex logic
   - Update docs if needed

3. **Test thoroughly**
   ```bash
   # Test fresh install
   rm -rf ~/.local/share/nvim ~/.cache/nvim
   nvim +":Lazy sync" +qa
   nvim
   
   # Run health check
   nvim +":checkhealth"
   
   # Test your specific feature
   ```

4. **Commit with clear messages**
   ```bash
   git commit -m "feat: add feature"
   # or
   git commit -m "fix: resolve issue with X"
   # or  
   git commit -m "perf: optimize Y startup time"
   ```

5. **Push and create PR**
   - Describe what and why
   - Reference any related issues
   - Include screenshots if UI changes

## Code Style

### Lua Style
- 2 spaces indentation
- Snake_case for variables and functions
- PascalCase for classes/modules
- Descriptive names over comments

```lua
-- Good
local function find_project_root()
  -- implementation
end

-- Bad
local function fpr() -- finds project root
  -- implementation
end
```

### Plugin Structure
Each plugin should have:
```lua
return {
  "author/plugin-name",
  event = "VeryLazy",  -- or specific trigger
  dependencies = { },   -- explicit deps
  opts = { },           -- configuration
  config = function()   -- if complex setup needed
    -- setup code
  end,
}
```

### Performance Guidelines
- Lazy load everything possible
- Use `event`, `cmd`, `ft`, or `keys` triggers
- Profile with `:Lazy profile` after changes

## Testing

Run these before submitting PR:

```bash
# Lua linting
luacheck lua/

# Format check
stylua --check lua/

# Test on fresh config
./scripts/test-fresh-install.sh

# Test specific language servers
nvim test.py  # Python
nvim test.ts  # TypeScript
nvim test.lua # Lua
```

## Adding Plugins

New plugins must:
1. Solve a real problem
2. Be actively maintained
3. Not duplicate existing functionality
4. Be performant
5. Have good documentation

Create the plugin file in appropriate category:
- `lua/plugins/ui.lua` - Interface elements
- `lua/plugins/editor.lua` - Editor features
- `lua/plugins/coding.lua` - Code completion, snippets
- `lua/plugins/lsp.lua` - Language servers
- `lua/plugins/git.lua` - Git integration
- `lua/plugins/diagnostics.lua` - Error handling

## Documentation

Update these when adding features:
- `README.md` - If adding major feature
- `docs/KEYBINDINGS.md` - For new keymaps
- Plugin file comments - Explain complex configs
- `:help` tags if applicable

## Language Server Support

To add a new language:

1. Add to `lua/plugins/lsp.lua`:
```lua
servers = {
  -- existing servers...
  your_ls = {
    settings = {
      -- language-specific settings
    }
  }
}
```

2. Add formatter to `lua/plugins/lsp.lua`:
```lua
formatters_by_ft = {
  -- existing...
  your_lang = { "your_formatter" },
}
```

3. Add Treesitter parser:
```lua
ensure_installed = {
  -- existing...
  "your_lang",
}
```

4. Test that it actually works!

## Commit Message Format

Follow conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `perf:` - Performance improvement
- `docs:` - Documentation only
- `style:` - Code style changes
- `refactor:` - Code restructuring
- `test:` - Test additions
- `chore:` - Maintenance tasks

annnd yeah.. that's about it. 
