# 1. Colorscheme: tokyonight-night

Date: 2026-03-25

Status: Accepted

## Context

The editor needs a default colorscheme that matches the terminal. Ghostty uses the `TokyoNight Night` theme.

## Decision

Default colorscheme is `tokyonight-night`. Multiple themes are installed for easy switching via `:colorscheme`:

- `tokyonight-night`, `tokyonight`, `tokyonight-storm` (folke/tokyonight.nvim)
- `github_dark_default`, `github_dark` (projekt0n/github-nvim-theme)
- `onedark` with style variants (navarasu/onedark.nvim)
- `gruvbox` (ellisonleao/gruvbox.nvim)

## Alternatives

The other installed themes stay available at runtime, but none of them matches the Ghostty theme.

## Rationale

Ghostty's `TokyoNight Night` and Neovim's `tokyonight-night` use identical background colors (`#1a1b26`).

## Consequences

When changing the default Neovim colorscheme, verify the Ghostty theme still matches.
