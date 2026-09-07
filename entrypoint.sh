#!/usr/bin/env bash
set -euo pipefail

if [ -n "${KIRI_DEBUG:-}" ]; then
    set -x
fi

kiri_args=(--no-server)

if [ -n "${KIRI_OUTPUT_DIR:-}" ]; then
    kiri_args+=(--output-dir "$KIRI_OUTPUT_DIR")
fi
if [ -n "${KIRI_REMOVE:-}" ]; then
    kiri_args+=(--remove)
fi
if [ -n "${KIRI_ARCHIVE:-}" ]; then
    kiri_args+=(--archive)
fi
if [ -n "${KIRI_PCB_PAGE_FRAME:-}" ]; then
    kiri_args+=(--page-frame)
fi
if [ -n "${KIRI_FORCE_LAYOUT_VIEW:-}" ]; then
    kiri_args+=(--layout)
fi
if [ -n "${KIRI_OLDER:-}" ]; then
    kiri_args+=(--older "$KIRI_OLDER")
fi
if [ -n "${KIRI_NEWER:-}" ]; then
    kiri_args+=(--newer "$KIRI_NEWER")
fi
if [ -n "${KIRI_LAST:-}" ]; then
    kiri_args+=(--last "$KIRI_LAST")
fi
if [ -n "${KIRI_ALL:-}" ]; then
    kiri_args+=(--all)
fi

if [ -n "${KIRI_PROJECT_FILE:-}" ]; then
    exec kiri "${kiri_args[@]}" "$@" "$KIRI_PROJECT_FILE"
else
    exec kiri "${kiri_args[@]}" "$@"
fi
