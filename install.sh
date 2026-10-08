#!/usr/bin/env bash
set -euo pipefail

# Pinned tool versions. Bump and rerun install.sh to update.
NVIM_VERSION="v0.12.5"
TREE_SITTER_VERSION="v0.27.1"
STYLUA_VERSION="v2.5.2"
SHFMT_VERSION="v3.14.1"
BLACK_VERSION="26.10.0"
PRETTIER_VERSION="3.9.9"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/nvim"
TARGET="$HOME/.config/nvim"
BIN_DIR="$HOME/.local/bin"
OPT_DIR="$HOME/.local/opt"

# Fail before installing anything, so a missing prerequisite never leaves a half-installed toolset
missing=()
for tool in curl tar unzip gunzip uv npm; do
    command -v "$tool" &>/dev/null || missing+=("$tool")
done
if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Missing prerequisites: ${missing[*]}"
    echo "  macOS:  brew install node uv"
    echo "  Debian: sudo apt install curl tar unzip gzip nodejs npm  (uv: https://docs.astral.sh/uv/)"
    exit 1
fi

# Each project names its release assets differently
case "$(uname -s)-$(uname -m)" in
Darwin-arm64)
    NVIM_ASSET="nvim-macos-arm64" TS_ARCH="macos-arm64" STYLUA_ARCH="macos-aarch64" SHFMT_ARCH="darwin_arm64"
    ;;
Darwin-x86_64)
    NVIM_ASSET="nvim-macos-x86_64" TS_ARCH="macos-x64" STYLUA_ARCH="macos-x86_64" SHFMT_ARCH="darwin_amd64"
    ;;
Linux-aarch64)
    NVIM_ASSET="nvim-linux-arm64" TS_ARCH="linux-arm64" STYLUA_ARCH="linux-aarch64" SHFMT_ARCH="linux_arm64"
    ;;
Linux-x86_64)
    NVIM_ASSET="nvim-linux-x86_64" TS_ARCH="linux-x64" STYLUA_ARCH="linux-x86_64" SHFMT_ARCH="linux_amd64"
    ;;
*)
    echo "Unsupported platform: $(uname -s) $(uname -m)"
    exit 1
    ;;
esac

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

# Install Neovim and tools from GitHub releases (see docs/adr/0007)
mkdir -p "$BIN_DIR" "$OPT_DIR"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo ""
echo "Installing Neovim $NVIM_VERSION..."
curl -fsSL "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$NVIM_ASSET.tar.gz" \
    | tar -xz -C "$TMP_DIR"
# Not ~/.local/share/nvim: that is Neovim's own data directory
rm -rf "$OPT_DIR/nvim"
mv "$TMP_DIR/$NVIM_ASSET" "$OPT_DIR/nvim"
ln -sfn "$OPT_DIR/nvim/bin/nvim" "$BIN_DIR/nvim"

echo "Installing tree-sitter $TREE_SITTER_VERSION..."
curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/download/$TREE_SITTER_VERSION/tree-sitter-$TS_ARCH.gz" \
    | gunzip >"$BIN_DIR/tree-sitter"
chmod +x "$BIN_DIR/tree-sitter"

echo "Installing stylua $STYLUA_VERSION..."
curl -fsSL "https://github.com/JohnnyMorganz/StyLua/releases/download/$STYLUA_VERSION/stylua-$STYLUA_ARCH.zip" \
    -o "$TMP_DIR/stylua.zip"
unzip -oq "$TMP_DIR/stylua.zip" stylua -d "$BIN_DIR"
chmod +x "$BIN_DIR/stylua"

echo "Installing shfmt $SHFMT_VERSION..."
curl -fsSL "https://github.com/mvdan/sh/releases/download/$SHFMT_VERSION/shfmt_${SHFMT_VERSION}_$SHFMT_ARCH" \
    -o "$BIN_DIR/shfmt"
chmod +x "$BIN_DIR/shfmt"

echo "Installing black $BLACK_VERSION and mdformat via uv (uv-managed Python survives patch upgrades)..."
uv tool install "black==$BLACK_VERSION" --python 3.14 --managed-python --reinstall
uv tool install mdformat --with mdformat-gfm --with mdformat-frontmatter --with mdformat-tables \
    --python 3.14 --managed-python --reinstall

echo "Installing prettier $PRETTIER_VERSION via npm..."
# --prefix avoids sudo with a system-wide npm (apt) and lands the binary in ~/.local/bin
npm install -g --prefix "$HOME/.local" --silent "prettier@$PRETTIER_VERSION"

echo ""
echo "Tools installed to $BIN_DIR."
# Older copies (e.g. from Homebrew) earlier in PATH would silently win
if [[ "$(command -v nvim)" != "$BIN_DIR/nvim" ]]; then
    echo "WARNING: 'nvim' resolves to $(command -v nvim || echo nothing), not $BIN_DIR/nvim."
    echo "         Put $BIN_DIR first in PATH or uninstall the other copies (see README)."
fi
