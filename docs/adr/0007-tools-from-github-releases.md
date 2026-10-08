# 7. Neovim and tools from GitHub releases

Date: 2026-10-08

Status: Accepted

## Context

The config runs on a Mac and on a Raspberry Pi (Debian 13 trixie, aarch64). `install.sh` installed every formatter with `brew install`, which does not exist on the Pi, so formatting failed there. Highlighting failed too: nvim-treesitter `main` ([ADR 3](0003-nvim-treesitter-main-branch.md)) needs Neovim 0.12+ and tree-sitter-cli 0.26.1+, but apt only ships Neovim 0.10.4 and tree-sitter-cli 0.22.6. Only the parsers bundled with Neovim (lua, markdown) worked.

## Decision

`install.sh` installs the same pinned versions on both platforms, without a package manager:

| Tool                               | Source                                                                          |
| ---------------------------------- | ------------------------------------------------------------------------------- |
| Neovim, tree-sitter, stylua, shfmt | GitHub release binaries into `~/.local`                                         |
| black, mdformat                    | `uv tool install` on uv-managed Python ([ADR 6](0006-mdformat-for-markdown.md)) |
| prettier                           | `npm install -g --prefix ~/.local` on the system Node                           |

Versions are pinned at the top of `install.sh`. The script detects OS and architecture with `uname` and maps them to each project's asset names (macOS and Linux, arm64 and x86_64).

## Alternatives

- Homebrew on macOS, apt on Linux — rejected. Two code paths, and apt's Neovim and tree-sitter-cli are too old for nvim-treesitter `main`.
- Switch back to the nvim-treesitter `master` API on the Pi — rejected. Reverses ADR 3 and makes the configs diverge.
- Always fetch the latest release — rejected. Not reproducible; a run could pull in a breaking version.
- Node from the nodejs.org tarball for prettier — rejected in favor of the system Node (`brew install node` / `apt install nodejs npm`), keeping the script smaller.
- black from GitHub releases — rejected. The standalone `black_linux-arm` binary is 32-bit only; uv works the same everywhere.

## Rationale

Identical versions on every machine, no sudo, one code path. GitHub publishes macOS and Linux binaries for arm64 and x86_64 for all four binary tools.

## Consequences

- Nothing updates automatically. Bump the version variables and rerun `install.sh`.
- Node/npm and uv are prerequisites; `install.sh` stops before installing anything if one is missing.
- `~/.local/bin` must come first in PATH. On the Mac, Homebrew copies of the same tools would otherwise win; `install.sh` warns when `nvim` resolves elsewhere.
