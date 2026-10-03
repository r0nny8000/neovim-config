# 4. conform.nvim for auto-formatting

Date: 2026-04-15

Status: Accepted

## Context

Files should be formatted automatically on save, with a manual keymap as well.

## Decision

Add `stevearc/conform.nvim`:

- Lazy-loaded on `BufWritePre` event — only loads when a file is first saved
- Format-on-save enabled with 1000ms timeout
- Manual format keymap: `<leader>f` (defined in the plugin's `keys` spec for lazy-loading)
- Formatter tools installed via Homebrew: `black`, `prettier`, `shfmt`, `stylua`
- Both `bash` and `sh` filetypes mapped to `shfmt` (Neovim uses `sh` for `.sh` files, `bash` for bash-specific files)
- `install.sh` updated to `brew install` the formatter tools
- Uses `lsp_format = "fallback"` (current API; old `lsp_fallback` is deprecated)

Markdown later moved from `prettier` to `mdformat`, see [ADR 6](0006-mdformat-for-markdown.md).

## Alternatives

None recorded.
