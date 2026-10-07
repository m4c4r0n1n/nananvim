# AI Setup

AI is **off by default** to keep startup lean and reliable, no binary downloads, no `make` build, nothing loads until you opt in. Inline suggestions and Avante (chat) are gated behind a single file: `lua/config/local.lua`. Create it and they turn on.

**Just want free Windsurf suggestions?** That's the whole setup (then run `:Codeium Auth` once to log in):

```bash
cp ~/.config/nvim/lua/config/local.example.lua ~/.config/nvim/lua/config/local.lua
```

**Got GitHub Copilot instead?** Set `suggestions = "copilot"` in that file and run `:LspCopilotSignIn` once. It runs on Neovim 0.12's built-in inline completion, so there's no Copilot plugin at all. `suggestions = false` turns suggestions off but keeps Avante.

With no `avante` table, Avante uses Claude Sonnet 5.5 and reads `ANTHROPIC_API_KEY`. For a different provider, put its config in that same file (see below), or `avante = false` to drop it.

## Windsurf / Copilot (Inline Suggestions)

**Keybindings** (once enabled):
- `<Tab>` - Accept suggestion (while the completion menu is open, `<Tab>` moves in the menu instead)
- `<M-]>` - Next suggestion
- `<M-[>` - Previous suggestion
- `<C-]>` - Dismiss suggestion (Windsurf)

## Avante (AI Chat) - Optional

For AI chat (like ChatGPT in nvim), you'll need to configure a provider:

### Option 1: FREE - Groq (Recommended)

1. Get a free API key: https://console.groq.com
2. Add to your shell:
```bash
   echo 'export GROQ_API_KEY="your-key"' >> ~/.zshrc
   source ~/.zshrc
```
3. Create config override:
```bash
   mkdir -p ~/.config/nvim/lua/config
   nvim ~/.config/nvim/lua/config/local.lua
```
4. Add this:
```lua
   return {
     avante = {
       provider = "openai",
       providers = {
         openai = {
           endpoint = "https://api.groq.com/openai/v1",
           model = "llama-3.3-70b-versatile",
           extra_request_body = {
             temperature = 0,
             max_tokens = 4096,
           },
         },
       },
     },
   }
```

### Option 2: Claude (Non-free option)

1. Get API key: https://console.anthropic.com
2. Add to shell:
```bash
   echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.zshrc
   source ~/.zshrc
```
3. Create `~/.config/nvim/lua/config/local.lua`:
```lua
   return {
     avante = {
       provider = "claude",
       providers = {
         claude = {
           endpoint = "https://api.anthropic.com",
           model = "claude-sonnet-5-5", -- or "claude-opus-5-5" for harder tasks
           extra_request_body = {
             max_tokens = 16000,
           },
         },
       },
     },
   }
```
(Don't set `temperature` for Claude Sonnet 5.5, it rejects non-default sampling params.) This is also the built-in default, so `return {}` gets you the same thing.

### Option 3: Skip AI entirely

Just don't create `local.lua`, no AI plugins load at all (no Windsurf, no Avante, no build step). You still get:
- ✅ LSP autocomplete
- ✅ Everything else in the config

**Avante keybindings** (only if configured):
- `<leader>aa` - Ask AI
- `<leader>ae` - Edit code with AI (visual mode)
- `<leader>ar` - Refresh
- `<leader>at` - Toggle Avante window
- `<leader>ac` - Open chat window
- `<leader>af` - Focus Avante window
