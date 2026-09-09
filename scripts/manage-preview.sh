#!/usr/bin/env bash
set -euo pipefail

command=$1
pages_dir=$2
pr_number=$3
preview_dir="$pages_dir/pr-previews/$pr_number"

case "$command" in
  update)
    output_dir=$2
    pages_dir=$3
    pr_number=$4
    preview_dir="$pages_dir/pr-previews/$pr_number"
    rm -rf "$preview_dir"
    mkdir -p "$preview_dir"
    cp -a "$output_dir/." "$preview_dir/"
    # delete unused diff file to not blowup storage
    rm -f "$preview_dir/diff.txt"
    ;;
  delete)
    rm -rf "$preview_dir"
    ;;
  *)
    printf 'Usage: %s {update OUTPUT_DIR PAGES_DIR PR_NUMBER|delete PAGES_DIR PR_NUMBER}\n' "$0" >&2
    exit 64
    ;;
esac
