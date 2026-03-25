# Instructions

Document important decisions and architecture changes in the README.md. If the file does not exist, create it.

After any changes to the config, check README.md and update it if the changes affect documented structure, keymaps, install instructions, or usage.

## Decisions

### nvim-treesitter pinned to `v0.9.3` tag (2026-03-25)

nvim-treesitter renamed their default branch from `master` to `main`. The `main` branch is a full rewrite that requires Neovim 0.12+ (nightly only). We pin to `tag = "v0.9.3"` which uses the old `require("nvim-treesitter.configs").setup()` API.

Additionally, even v0.9.3's Python highlight queries reference `except*` (a Python 3.11 syntax node) which Neovim 0.11.x's treesitter query engine can't parse. The `build` function patches this out after install.

**When upgrading to Neovim 0.12+:**
1. In `nvim/lua/config/lazy.lua`, remove `tag = "v0.9.3"` (lazy.nvim will use the default `main` branch)
2. Replace the entire spec — the `main` branch removed `require("nvim-treesitter.configs").setup()`. The new minimal spec is:
   ```lua
   { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }
   ```
   Parsers: `:TSInstall <lang>` or `require("nvim-treesitter").install { ... }`. Highlighting requires a `FileType` autocmd calling `vim.treesitter.start()`. See the [official README](https://github.com/nvim-treesitter/nvim-treesitter).
3. Remove the `build` function with the `except*` patch (no longer needed in 0.12)
4. Ensure `tree-sitter-cli` is installed (`brew install tree-sitter-cli`) — required by `main` branch
5. Run `:Lazy sync` and `:TSUpdate` to rebuild all parsers
6. Run `bash tests/test_treesitter.sh` to verify all parsers work

### Colorscheme: tokyonight-night (2026-03-25)

Default colorscheme is `tokyonight-night`. Multiple themes are installed for easy switching via `:colorscheme`:
- `tokyonight-night`, `tokyonight`, `tokyonight-storm` (folke/tokyonight.nvim)
- `github_dark_default`, `github_dark` (projekt0n/github-nvim-theme)
- `onedark` with style variants (navarasu/onedark.nvim)
- `gruvbox` (ellisonleao/gruvbox.nvim)

Ghostty terminal uses the matching `TokyoNight Night` theme — background colors are identical (`#1a1b26`). When changing the default Neovim colorscheme, verify the Ghostty theme still matches.

### Auto-reload externally changed files (2026-03-25)

`autoread` is enabled plus a `checktime` autocmd on `FocusGained` and `CursorHold` (200ms). This ensures files modified by external tools (e.g., Claude Code) are reloaded in the Neovim UI.
