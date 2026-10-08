# 3. nvim-treesitter on `main` branch for Neovim 0.12+

Date: 2026-04-14

Status: Accepted

## Context

nvim-treesitter was pinned to the `v0.9.3` tag, which uses the old `master` API. Neovim 0.12+ is targeted by the `main` branch rewrite.

## Decision

Upgrade from the pinned `v0.9.3` tag to the `main` branch. The new API:

- Parsers installed via `require("nvim-treesitter").install({ ... })`
- Highlighting enabled via `vim.treesitter.start()` in a `FileType` autocmd
- Indentation via `vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"`
- `lazy = false` required (plugin does not support lazy-loading)
- `tree-sitter-cli` required (installed by `install.sh`, see [ADR 7](0007-tools-from-github-releases.md))

Installed parsers: bash, html, javascript, json, lua, markdown, markdown_inline, python, yaml.

## Alternatives

Stay pinned to `v0.9.3` with the old `master` API.

## Consequences

- The plugin cannot be lazy-loaded.
- `tree-sitter-cli` must be installed.
