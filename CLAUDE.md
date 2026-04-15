# Instructions

Document important decisions and architecture changes in the README.md. If the file does not exist, create it.

After any changes to the config, check README.md and update it if the changes affect documented structure, keymaps, install instructions, or usage.

## Decisions

### nvim-treesitter on `main` branch for Neovim 0.12+ (2026-04-14)

Upgraded from pinned `v0.9.3` tag (old `master` API) to the `main` branch rewrite. The new API:
- Parsers installed via `require("nvim-treesitter").install({ ... })`
- Highlighting enabled via `vim.treesitter.start()` in a `FileType` autocmd
- Indentation via `vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"`
- `lazy = false` required (plugin does not support lazy-loading)
- `tree-sitter-cli` required (`brew install tree-sitter-cli`)

Installed parsers: bash, html, javascript, json, lua, markdown, markdown_inline, python, yaml.

### conform.nvim for auto-formatting (2026-04-15)

Added `stevearc/conform.nvim` for automatic code formatting:
- Lazy-loaded on `BufWritePre` event — only loads when a file is first saved
- Format-on-save enabled with 500ms timeout
- Manual format keymap: `<leader>f` (defined in the plugin's `keys` spec for lazy-loading)
- Formatter tools installed via Homebrew: `black`, `prettier`, `shfmt`, `stylua`
- Both `bash` and `sh` filetypes mapped to `shfmt` (Neovim uses `sh` for `.sh` files, `bash` for bash-specific files)
- `install.sh` updated to `brew install` the formatter tools
- Uses `lsp_format = "fallback"` (current API; old `lsp_fallback` is deprecated)

### Colorscheme: tokyonight-night (2026-03-25)

Default colorscheme is `tokyonight-night`. Multiple themes are installed for easy switching via `:colorscheme`:
- `tokyonight-night`, `tokyonight`, `tokyonight-storm` (folke/tokyonight.nvim)
- `github_dark_default`, `github_dark` (projekt0n/github-nvim-theme)
- `onedark` with style variants (navarasu/onedark.nvim)
- `gruvbox` (ellisonleao/gruvbox.nvim)

Ghostty terminal uses the matching `TokyoNight Night` theme — background colors are identical (`#1a1b26`). When changing the default Neovim colorscheme, verify the Ghostty theme still matches.

### Auto-reload externally changed files (2026-03-25)

`autoread` is enabled plus a `checktime` autocmd on `FocusGained` and `CursorHold` (200ms). This ensures files modified by external tools (e.g., Claude Code) are reloaded in the Neovim UI.
