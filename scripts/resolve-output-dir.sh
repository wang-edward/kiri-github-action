#!/usr/bin/env bash
set -euo pipefail

output_dir=$1
project_file=$2

if [ -n "$output_dir" ]; then
  printf '%s\n' "$output_dir"
elif [ -n "$project_file" ]; then
  printf '%s/.kiri\n' "$(dirname -- "$project_file")"
else
  printf '.kiri\n'
fi
