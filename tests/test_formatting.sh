#!/usr/bin/env bash
set -euo pipefail

# Test that formatter tools are installed and conform.nvim can format
# each sample file without errors.
#
# Usage: bash tests/test_formatting.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SAMPLES_DIR="$SCRIPT_DIR/samples"
PASS=0
FAIL=0

# --- Check formatter tools are installed ---

check_tool() {
    local tool="$1"
    if command -v "$tool" &>/dev/null; then
        echo "PASS  $tool found: $(command -v "$tool")"
        PASS=$((PASS + 1))
    else
        echo "FAIL  $tool not found in PATH"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== Formatter Tool Checks ==="
echo ""

check_tool "black"
check_tool "prettier"
check_tool "shfmt"
check_tool "stylua"

echo ""

# --- Check conform.nvim can format each sample file ---

test_format() {
    local file="$1"
    local basename
    basename="$(basename "$file")"

    # Copy sample to a temp file so formatting doesn't modify the original
    local tmpfile
    tmpfile="$(mktemp "/tmp/conform_test_XXXXXX_${basename}")"
    cp "$file" "$tmpfile"

    local errors
    errors=$(nvim --headless \
        -c "e $tmpfile" \
        -c "lua require('conform').format({ async = false, timeout_ms = 5000 })" \
        -c "sleep 1" \
        -c "qa!" 2>&1)

    rm -f "$tmpfile"

    if [[ -z "$errors" ]]; then
        echo "PASS  $basename — formatted without errors"
        PASS=$((PASS + 1))
    else
        echo "FAIL  $basename — errors during format:"
        echo "      $errors"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== Conform.nvim Format Tests ==="
echo ""

test_format "$SAMPLES_DIR/example.py"
test_format "$SAMPLES_DIR/example.js"
test_format "$SAMPLES_DIR/example.html"
test_format "$SAMPLES_DIR/example.json"
test_format "$SAMPLES_DIR/example.lua"
test_format "$SAMPLES_DIR/example.md"
test_format "$SAMPLES_DIR/example.sh"
test_format "$SAMPLES_DIR/example.yaml"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="

if [[ "$FAIL" -gt 0 ]]; then
    exit 1
fi
