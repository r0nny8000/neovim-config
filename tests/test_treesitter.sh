#!/usr/bin/env bash
set -euo pipefail

# Test that Neovim opens sample files without treesitter errors
# and that highlighting is active for each filetype.
#
# Usage: bash tests/test_treesitter.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SAMPLES_DIR="$SCRIPT_DIR/samples"
PASS=0
FAIL=0

test_file() {
    local file="$1"
    local lang="$2"
    local basename
    basename="$(basename "$file")"

    # Test 1: Open file without errors
    local errors
    errors=$(nvim --headless -c "e $file" -c "sleep 1" -c "qa" 2>&1)
    if [[ -n "$errors" ]]; then
        echo "FAIL  $basename — errors on open:"
        echo "      $errors"
        FAIL=$((FAIL + 1))
        return
    fi

    # Test 2: Check that treesitter highlighting is active
    local hl_active
    hl_active=$(nvim --headless -c "e $file" -c "lua local ok, hl = pcall(vim.treesitter.get_parser, 0, '$lang'); if ok and hl then print('TS_ACTIVE') else print('TS_INACTIVE') end" -c "qa" 2>&1)
    if [[ "$hl_active" == *"TS_ACTIVE"* ]]; then
        echo "PASS  $basename — treesitter active ($lang)"
        PASS=$((PASS + 1))
    else
        echo "FAIL  $basename — treesitter not active ($lang)"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== Treesitter Smoke Tests ==="
echo ""

test_file "$SAMPLES_DIR/example.py"   "python"
test_file "$SAMPLES_DIR/example.md"   "markdown"
test_file "$SAMPLES_DIR/example.yaml" "yaml"
test_file "$SAMPLES_DIR/example.json" "json"
test_file "$SAMPLES_DIR/example.lua"  "lua"
test_file "$SAMPLES_DIR/example.sh"   "bash"
test_file "$SAMPLES_DIR/example.html" "html"
test_file "$SAMPLES_DIR/example.js"   "javascript"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="

if [[ "$FAIL" -gt 0 ]]; then
    exit 1
fi
