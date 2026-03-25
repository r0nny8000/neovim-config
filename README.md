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

## Adding Plugins

Add plugin specs to `nvim/lua/config/lazy.lua` in the `spec` table, or create a `nvim/lua/plugins/` directory and lazy.nvim will auto-load specs from there.
