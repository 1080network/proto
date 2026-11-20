#!/bin/bash
# Generate the client SDK sources for the roles a member can play (issuer, acceptor), plus the
# shared member and common definitions, using buf.gen.yaml. Output goes to ./gen/<language>.
#
# Usage: ./generate.sh [language ...]   (default: all languages in buf.gen.yaml)
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v buf >/dev/null; then
    echo "buf is required: https://buf.build/docs/installation" >&2
    exit 1
fi

rm -rf gen
buf generate \
    --path mica/issuer --path mica/acceptor --path mica/member --path mica/common --path micashared \
    .

if [[ $# -gt 0 ]]; then
    # Keep only the requested languages
    for dir in gen/*/; do
        lang=$(basename "$dir")
        keep=false
        for want in "$@"; do [[ "$lang" == "$want" ]] && keep=true; done
        $keep || rm -rf "$dir"
    done
fi
echo "Generated: $(ls gen | tr '\n' ' ')"
