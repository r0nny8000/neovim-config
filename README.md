# Neovim Config

Minimal Neovim configuration with [lazy.nvim](https://github.com/folke/lazy.nvim) as plugin manager.

## Install

```bash
bash install.sh
```

This creates a symlink `~/.config/nvim` pointing to the `nvim/` directory in this repo. Existing configs are backed up with a timestamp suffix.

It then installs Neovim, tree-sitter-cli and the formatters into `~/.local` with pinned versions, the same way on macOS and Linux (arm64 and x86_64, e.g. a Raspberry Pi). See [ADR 7](docs/adr/0007-tools-from-github-releases.md).

Prerequisites:

| Platform       | Command                                                                                      |
| -------------- | -------------------------------------------------------------------------------------------- |
| macOS          | `brew install node uv`                                                                       |
| Debian / Pi OS | `sudo apt install curl tar unzip gzip gcc nodejs npm`, plus [uv](https://docs.astral.sh/uv/) |

`~/.local/bin` must come first in `PATH`. When migrating a Mac from the old Homebrew setup, remove the Homebrew copies so they don't shadow the pinned versions:

```bash
brew uninstall neovim tree-sitter tree-sitter-cli stylua shfmt black prettier
```

To update a tool, bump its version at the top of `install.sh` and rerun it.

## Structure

```
install.sh                  # Symlinks nvim/ and installs Neovim, tree-sitter and formatters
docs/adr/                   # Architecture Decision Records
tests/                      # Smoke tests and sample files
nvim/
├── init.lua                # Entry point
├── after/
│   └── ftplugin/
│       └── markdown.lua    # 2-space indentation for markdown
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

Installed by `install.sh`:

| Formatter                                         | Filetypes                    | Installed via                    |
| ------------------------------------------------- | ---------------------------- | -------------------------------- |
| [black](https://github.com/psf/black)             | python                       | `uv tool` (uv-managed Python)    |
| [mdformat](https://github.com/hukkin/mdformat)    | markdown                     | `uv tool` (uv-managed Python)    |
| [prettier](https://prettier.io/)                  | html, javascript, json, yaml | npm (system Node)                |
| [shfmt](https://github.com/mvdan/sh)              | bash, sh                     | GitHub release                   |
| [stylua](https://github.com/JohnnyMorganz/StyLua) | lua                          | GitHub release                   |

Files are formatted automatically on save. Use `<leader>f` for manual formatting. Run `:ConformInfo` to check formatter status for the current buffer.

## Testing

```bash
bash tests/test_formatting.sh
bash tests/test_treesitter.sh
```

- `test_formatting.sh` — verifies each formatter tool runs and conform.nvim formats every sample file without errors
- `test_treesitter.sh` — smoke tests that verify each sample file opens without errors and has an active treesitter parser

## Decisions

The reasoning behind significant decisions is recorded as ADRs in [`docs/adr/`](docs/adr/).

## Adding Plugins

Add plugin specs to `nvim/lua/config/lazy.lua` in the `spec` table, or create a `nvim/lua/plugins/` directory and lazy.nvim will auto-load specs from there.
