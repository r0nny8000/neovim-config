#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/nvim"
TARGET="$HOME/.config/nvim"

mkdir -p "$HOME/.config"

if [[ -L "$TARGET" ]]; then
    current_target="$(readlink "$TARGET")"
    if [[ "$current_target" == "$SOURCE" ]]; then
        echo "Already installed: $TARGET -> $SOURCE"
    else
        echo "Replacing existing symlink: $TARGET -> $current_target"
        rm "$TARGET"
        ln -s "$SOURCE" "$TARGET"
        echo "Installed: $TARGET -> $SOURCE"
    fi
elif [[ -e "$TARGET" ]]; then
    backup="${TARGET}.bak.$(date +%Y%m%d_%H%M%S)"
    echo "Backing up existing config to: $backup"
    mv "$TARGET" "$backup"
    ln -s "$SOURCE" "$TARGET"
    echo "Installed: $TARGET -> $SOURCE"
else
    ln -s "$SOURCE" "$TARGET"
    echo "Installed: $TARGET -> $SOURCE"
fi

# Install formatter tools (used by conform.nvim)
echo ""
echo "Installing formatter tools via Homebrew..."
brew install black prettier shfmt stylua
echo "Formatter tools installed."
