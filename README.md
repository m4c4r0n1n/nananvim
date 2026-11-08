<div align="center">

# nananvim

<img width="1704" height="1386" alt="nananvim home screen" src="docs/images/home.png" />

<p>
  <a href="https://github.com/m4c4r0n1n/nananvim/actions/workflows/ci.yml"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/m4c4r0n1n/nananvim/ci.yml?branch=main&event=push&label=CI&logo=githubactions&logoColor=e0def4&color=9ccfd8&style=for-the-badge&labelColor=232136" /></a>
  <a href="https://github.com/neovim/neovim/releases"><img alt="Neovim 0.12+" src="https://img.shields.io/badge/Neovim-0.12%2B-c4a7e7?logo=neovim&logoColor=e0def4&style=for-the-badge&labelColor=232136" /></a>
  <a href="https://github.com/m4c4r0n1n/nananvim/commits/main"><img alt="Last commit" src="https://img.shields.io/github/last-commit/m4c4r0n1n/nananvim?logo=git&logoColor=e0def4&color=f6c177&style=for-the-badge&labelColor=232136" /></a>
  <a href="https://github.com/m4c4r0n1n/nananvim/commits/main"><img alt="Maintained: yes" src="https://img.shields.io/badge/Maintained%3F-yes-9ccfd8?style=for-the-badge&labelColor=232136" /></a>
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/github/license/m4c4r0n1n/nananvim?color=ea9a97&style=for-the-badge&labelColor=232136" /></a>
  <a href="https://ko-fi.com/koifist"><img alt="Ko-fi" src="https://img.shields.io/badge/Ko--fi-support-eb6f92?logo=kofi&logoColor=e0def4&style=for-the-badge&labelColor=232136" /></a>
</p>

TIRED OF LAZYVIM? WANT SOMETHING LESS BLOATED? TRY NANANVIM! In all seriousness, I didn't build this for stars, I didn't build it to compete with anyone or anything like that. I built it for me, with just the things I find useful in day to day life and kept adding more as work demanded it. I figure *maybe* someone else will stumble upon this and want something a bit lighter and easier to customize and learn; but is also ready to use out of the box. Or maybe someone just looking for something new and bored with everything else. So I documented it.

Latest: I've added a bunch of quality of life stuff (sessions, oil, harpoon, multiple cursors, a test runner, diffview, NananvimUpdate command, rendered markdown and more), and your own settings now live in one file that updates never touch. Web dev is in too: Vue, Svelte, Astro, MDX and working Emmet. Full rundown in the [CHANGELOG](CHANGELOG.md).

---

**[<kbd> <br> Install <br> </kbd>](docs/installation.md)**
**[<kbd> <br> Features <br> </kbd>](docs/features.md)**
**[<kbd> <br> Configure <br> </kbd>](docs/customization-guide.md)**
**[<kbd> <br> Keybindings <br> </kbd>](KEYBINDINGS.md)**
**[<kbd> <br> Troubleshooting <br> </kbd>](docs/troubleshooting.md)**

---

</div>

## Why nananvim?

Because why not. I don't do promoting, so it's like you'll be part of an exclusive club! One of neovim's best kept secrets, if you will. And while you're here, here are some specs:

- **Kinda fast**: ~35ms startup on average, everything else waits for its trigger
- **Built on Neovim 0.12, not around it**: native LSP, commenting, selection and borders, less plugin glue
- **Custom plugins**: a [Browser │ Terminal │ TODO workspace](https://github.com/m4c4r0n1n/nana-panels.nvim) and a [live theme switcher](https://github.com/m4c4r0n1n/theme-switcher.nvim)
- **Batteries included, bloat optional**: completion UI, linting, debugging and tests each turn off with one `false`
- **Updates don't eat your settings**: your stuff lives in one gitignored file, `lua/config/local.lua`
- **AI is opt-in**: nothing loads until you make that file
- **Tested, not vibes**: every push installs on Arch, Fedora, Debian, Ubuntu, NixOS, Void, Gentoo and macOS

## Screenshots
Some of these are a bit old, I'll update them soon. But clone it and check the tools for yourself!
<p align="center">
  <img width="48.7%" alt="Git page with clean branches" src="https://github.com/user-attachments/assets/ea1738c4-bf20-4f65-93f4-2bcef95e7808" />
  <img width="48.7%" alt="Git page with GitHub and GitLab logos" src="docs/images/git-page.png" />
</p>

<p align="center">
  <img width="32.3%" alt="Picker with inline image preview" src="https://github.com/user-attachments/assets/a36b2720-f89e-4226-93c6-452d5127a9f6" />
  <img width="32.3%" alt="Editing with LSP and Treesitter" src="https://github.com/user-attachments/assets/c3855bf3-304a-4bdd-80bd-640c596a1046" />
  <img width="32.3%" alt="Panel workspace" src="https://github.com/user-attachments/assets/b98bac43-4de5-4aa4-b6ec-db4d8055b7ea" />
</p>

<p align="center">
  <img width="33%" alt="Theme picker" src="https://github.com/user-attachments/assets/d93ea09b-8973-4884-af19-5ab23d7dc9fc" />
  <img width="64.2%" alt="Debugging with DAP" src="https://github.com/user-attachments/assets/4605dfd2-5450-4466-b242-79402f5ce90e" />
</p>

## License

Apache-2.0

---

<div align="center">Made with ❤️ (and way too much caffeine).</div>
