# 6. mdformat for markdown

Date: 2026-05-06

Status: Accepted

## Context

Markdown was formatted by `prettier` ([ADR 4](0004-conform-nvim-auto-formatting.md)). Prettier minifies markdown table columns to minimum width, which breaks visual alignment.

## Decision

Format markdown with `mdformat` plus the plugins `mdformat-gfm`, `mdformat-frontmatter`, and `mdformat-tables`. `prettier` keeps html, javascript, json, and yaml.

mdformat is installed as a uv tool on uv-managed Python (2026-10-03):

```bash
uv tool install mdformat --with mdformat-gfm --with mdformat-frontmatter --with mdformat-tables \
    --python 3.14 --managed-python --reinstall
```

## Alternatives

- `prettier` for markdown — rejected, minifies table columns.
- uv tool on pyenv Python — rejected. The tool environment links to an exact pyenv patch version; removing 3.14.3 after upgrading to 3.14.7 broke mdformat with `ENOENT` on every save.

## Rationale

mdformat pads table cells so pipe separators line up vertically, matching the style used in reports. uv-managed Python environments point to a minor-version directory (`cpython-3.14-...`), so `uv python upgrade` moves them to new patch releases transparently, and uv keeps old patch versions.

## Consequences

A minor Python upgrade (e.g., 3.14 → 3.15) is not automatic. Move the tool with `uv tool upgrade --all --reinstall --python 3.15`.
