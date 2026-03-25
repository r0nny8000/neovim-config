#!/usr/bin/env bash
set -euo pipefail

# Sample Bash file for treesitter testing

NAME="${1:-world}"
COUNT=3

greet() {
    local who="$1"
    echo "Hello, ${who}!"
}

for i in $(seq 1 "$COUNT"); do
    if [[ "$i" -eq 1 ]]; then
        greet "$NAME"
    else
        echo "Iteration $i"
    fi
done
