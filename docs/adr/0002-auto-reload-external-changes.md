# 2. Auto-reload externally changed files

Date: 2026-03-25

Status: Accepted

## Context

External tools (e.g., Claude Code) modify files that are open in Neovim. Without a reload, the UI shows stale content.

## Decision

`autoread` is enabled plus a `checktime` autocmd on `FocusGained` and `CursorHold` (200ms).

## Alternatives

None recorded.

## Rationale

`autoread` alone only reloads when Neovim checks the file. The `checktime` autocmd triggers that check when focus returns and after 200ms of idle cursor, so changes appear in the UI without manual `:e`.
