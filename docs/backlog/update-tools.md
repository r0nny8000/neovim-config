---
status: open
priority: medium
acceptance:
  - A single command lists each pinned tool with its pinned and latest version
  - On confirmation it bumps the versions in install.sh and reruns the install
  - Pinning stays: nothing updates without an explicit run
  - Both tests pass after an update on macOS and the Pi
---

# Update functionality for pinned tools

`install.sh` pins Neovim, tree-sitter, stylua, shfmt, black and prettier ([ADR 7](../adr/0007-tools-from-github-releases.md)). Updating means looking up each release by hand and editing the version variables.

Add an update command that compares the pinned versions against the latest releases (GitHub API, PyPI for black, npm registry for prettier), shows the differences, and on confirmation writes the new versions into `install.sh` and reruns it. The bumped `install.sh` is then committed, so the Mac and the Pi pick up the same versions.

Open questions:

- Script language: bash like `install.sh`, or Python (preferred for automation).
- Whether it also covers plugin updates (`:Lazy update` plus committing `lazy-lock.json`) and mdformat, which is not pinned today.
- Major-version bumps: update them too, or only report them.

Candidate: mason.nvim with mason-tool-installer instead of a custom script. Checked against the Mason registry (2026-10-08): it has stylua, shfmt, black, prettier and tree-sitter-cli, with pinnable versions and `:MasonToolsUpdate`. It does not cover Neovim itself, nor mdformat with the gfm, frontmatter and tables plugins (the registry package is plain mdformat, which loses table alignment, see [ADR 6](../adr/0006-mdformat-for-markdown.md)). System prerequisites stay the same: Node/npm for prettier, Python for black, a C compiler for parsers. Choosing it reverses part of [ADR 7](../adr/0007-tools-from-github-releases.md) and needs its own ADR.
