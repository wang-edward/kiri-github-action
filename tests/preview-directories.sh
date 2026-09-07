#!/usr/bin/env bash
set -euo pipefail

root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT

default_output=$(scripts/resolve-output-dir.sh '' 'boards/control.kicad_pro')
[ "$default_output" = 'boards/.kiri' ]
custom_output=$(scripts/resolve-output-dir.sh 'build/kiri output' 'boards/control.kicad_pro')
[ "$custom_output" = 'build/kiri output' ]

mkdir -p "$root/output-one" "$root/output-two" "$root/gh-pages/pr-previews/2"
printf 'first preview\n' > "$root/output-one/index.html"
printf 'updated preview\n' > "$root/output-two/index.html"
printf 'other preview\n' > "$root/gh-pages/pr-previews/2/index.html"

scripts/manage-preview.sh update "$root/output-one" "$root/gh-pages" 1
scripts/manage-preview.sh update "$root/output-two" "$root/gh-pages" 1
[ "$(<"$root/gh-pages/pr-previews/1/index.html")" = 'updated preview' ]
[ "$(<"$root/gh-pages/pr-previews/2/index.html")" = 'other preview' ]

scripts/manage-preview.sh delete "$root/gh-pages" 1
[ ! -e "$root/gh-pages/pr-previews/1" ]
[ "$(<"$root/gh-pages/pr-previews/2/index.html")" = 'other preview' ]
