# Neovim Config

Minimal Neovim configuration with [lazy.nvim](https://github.com/folke/lazy.nvim) as plugin manager.

## Install

```bash
bash install.sh
```

This creates a symlink `~/.config/nvim` pointing to the `nvim/` directory in this repo. Existing configs are backed up with a timestamp suffix.

## Structure

```
nvim/
├── init.lua                # Entry point
└── lua/
    └── config/
        ├── options.lua     # Editor options (line numbers, search, indent, clipboard)
        ├── keymaps.lua     # Key mappings (leader = space)
        └── lazy.lua        # lazy.nvim bootstrap
```

## Key Mappings

> Leader key is `<Space>`

### File Explorer (nvim-tree)

- `<leader>e` — Toggle the file explorer panel open/closed
- `<leader>E` — Open the explorer and jump to the current file

**Inside nvim-tree:**

- `<CR>` / `o` — Open file or expand/collapse folder
- `a` — Create new file or directory (end with `/` for a directory)
- `d` — Delete file or directory
- `r` — Rename file or directory
- `q` — Close the explorer panel

Files and folders are intermixed and sorted alphabetically by name (not folders-first).

### Window Navigation

- `<C-h>` / `<C-l>` — Move to the window on the left / right
- `<C-j>` / `<C-k>` — Move to the window below / above

### Formatting

- `<leader>f` — Format the current buffer (or selection in visual mode)
- Files are also auto-formatted on save via conform.nvim

### Editing

- `<leader>p` *(visual)* — Paste without overwriting the yank register
- `J` / `K` *(visual)* — Move selected lines down / up

### Navigation & Search

- `<C-d>` / `<C-u>` — Scroll half-page down / up (cursor stays centered)
- `<Esc>` — Clear search highlight

## Plugins

| Plugin                                                                | Purpose                                                  |
| --------------------------------------------------------------------- | -------------------------------------------------------- |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)           | Default colorscheme (tokyonight-night)                   |
| [github-nvim-theme](https://github.com/projekt0n/github-nvim-theme)   | GitHub Dark / Default colorschemes                       |
| [onedark.nvim](https://github.com/navarasu/onedark.nvim)              | Atom One Dark colorscheme                                |
| [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)           | Gruvbox colorscheme                                      |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting, indentation (requires Neovim 0.12+) |
| [conform.nvim](https://github.com/stevearc/conform.nvim)              | Auto-formatting (format-on-save + `<leader>f`)           |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)           | File explorer side panel (`<leader>e` toggle)            |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)   | File type icons (requires a Nerd Font in the terminal)   |

Pre-installed parsers: bash, html, javascript, json, lua, markdown, markdown_inline, python, yaml. Install additional parsers with `:TSInstall <lang>`.

Switch colorscheme at runtime with `:colorscheme <name>` (e.g., `:colorscheme github_dark_default`).

### Formatters

Installed via Homebrew by `install.sh`:

| Formatter                                         | Filetypes                              |
| ------------------------------------------------- | -------------------------------------- |
| [black](https://github.com/psf/black)             | python                                 |
| [prettier](https://prettier.io/)                  | html, javascript, json, markdown, yaml |
| [shfmt](https://github.com/mvdan/sh)              | bash, sh                               |
| [stylua](https://github.com/JohnnyMorganz/StyLua) | lua                                    |

Files are formatted automatically on save. Use `<leader>f` for manual formatting. Run `:ConformInfo` to check formatter status for the current buffer.

## Testing

```bash
bash tests/test_treesitter.sh
```

Smoke tests that verify each sample file opens without errors and has an active treesitter parser.

## Adding Plugins

Add plugin specs to `nvim/lua/config/lazy.lua` in the `spec` table, or create a `nvim/lua/plugins/` directory and lazy.nvim will auto-load specs from there.
