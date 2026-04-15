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

| Key | Mode | Action |
|-----|------|--------|
| `<Space>` | n | Leader key |
| `<Esc>` | n | Clear search highlight |
| `<C-h/j/k/l>` | n | Window navigation |
| `J` / `K` | v | Move lines up/down |
| `<C-d>` / `<C-u>` | n | Scroll half-page (centered) |
| `<leader>p` | x | Paste without overwriting register |
| `<leader>f` | n, v | Format buffer (conform.nvim) |

## Plugins

| Plugin | Purpose |
|--------|---------|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Default colorscheme (tokyonight-night) |
| [github-nvim-theme](https://github.com/projekt0n/github-nvim-theme) | GitHub Dark / Default colorschemes |
| [onedark.nvim](https://github.com/navarasu/onedark.nvim) | Atom One Dark colorscheme |
| [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim) | Gruvbox colorscheme |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting, indentation (requires Neovim 0.12+) |
| [conform.nvim](https://github.com/stevearc/conform.nvim)             | Auto-formatting (format-on-save + `<leader>f`)            |

Pre-installed parsers: bash, html, javascript, json, lua, markdown, markdown_inline, python, yaml. Install additional parsers with `:TSInstall <lang>`.

Switch colorscheme at runtime with `:colorscheme <name>` (e.g., `:colorscheme github_dark_default`).

### Formatters

Installed via Homebrew by `install.sh`:

| Formatter                                          | Filetypes                              |
| -------------------------------------------------- | -------------------------------------- |
| [black](https://github.com/psf/black)              | python                                 |
| [prettier](https://prettier.io/)                   | html, javascript, json, markdown, yaml |
| [shfmt](https://github.com/mvdan/sh)               | bash, sh                               |
| [stylua](https://github.com/JohnnyMorganz/StyLua)  | lua                                    |

Files are formatted automatically on save. Use `<leader>f` for manual formatting. Run `:ConformInfo` to check formatter status for the current buffer.

## Testing

```bash
bash tests/test_treesitter.sh
```

Smoke tests that verify each sample file opens without errors and has an active treesitter parser.

## Adding Plugins

Add plugin specs to `nvim/lua/config/lazy.lua` in the `spec` table, or create a `nvim/lua/plugins/` directory and lazy.nvim will auto-load specs from there.
