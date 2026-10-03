# 5. nvim-tree file explorer

Date: 2026-05-05

Status: Accepted

## Context

The config needs a file explorer side panel with file type icons.

## Decision

Add `nvim-tree/nvim-tree.lua` with `nvim-web-devicons` for file type icons. netrw is disabled in `init.lua` (set `vim.g.loaded_netrw` / `vim.g.loaded_netrwPlugin` before plugin load, as recommended by the plugin).

- Lazy-loaded via `keys` (`<leader>e`, `<leader>E`) and `cmd` (`NvimTree*`)
- `<leader>e` → `:NvimTreeToggle`
- `<leader>E` → `:NvimTreeFindFile`
- `view.width = 32`
- Dotfiles and git-ignored files are shown (`filters.dotfiles = false`, `filters.git_ignored = false`)
- Requires a Nerd Font in the terminal for icons to render
- Files and folders are intermixed and sorted alphabetically by name (`sort.folders_first = false`, `sort.sorter = "name"`), instead of the default folders-first grouping (2026-06-16)

## Alternatives

netrw, Neovim's built-in explorer — disabled in favor of nvim-tree.

## Consequences

The terminal needs a Nerd Font for icons to render.
