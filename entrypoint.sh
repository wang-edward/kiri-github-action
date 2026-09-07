#!/bin/bash

# This script is used to parse environment variable from the
# Github Actions workflow and run Kiri.

if [ -n "${KIRI_DEBUG}" ]; then
    set -x
fi

# Get the current workspace ownership and restore it when Kiri exits.
OWNER_ID=$(stat -c '%u' "$GITHUB_WORKSPACE")
GROUP_ID=$(stat -c '%g' "$GITHUB_WORKSPACE")
restore_workspace_owner() {
    sudo chown -R "${OWNER_ID}:${GROUP_ID}" "$GITHUB_WORKSPACE"
}
trap restore_workspace_owner EXIT

if [ "${OWNER_ID}" != "${USER}" ]; then
    sudo chown -R "${USER}:${USER}" "$GITHUB_WORKSPACE"
fi

. /home/github/.profile

KIRI_ARGS=(--no-server)

# KIRI_OUTPUT_DIR -> --output-dir
if [ -n "${KIRI_OUTPUT_DIR}" ]; then
    KIRI_ARGS+=(--output-dir "$KIRI_OUTPUT_DIR")
fi

# KIRI_REMOVE -> --remove
if [ -n "${KIRI_REMOVE}" ]; then
    KIRI_ARGS+=(--remove)
fi

# KIRI_ARCHIVE -> --archive
if [ -n "${KIRI_ARCHIVE}" ]; then
    KIRI_ARGS+=(--archive)
fi

# KIRI_PCB_PAGE_FRAME -> --page-frame
if [ -n "${KIRI_PCB_PAGE_FRAME}" ]; then
    KIRI_ARGS+=(--page-frame)
fi

# KIRI_FORCE_LAYOUT_VIEW -> --layout
if [ -n "${KIRI_FORCE_LAYOUT_VIEW}" ]; then
    KIRI_ARGS+=(--layout)
fi

# KIRI_SKIP_KICAD6_SCHEMATICS -> --skip-kicad6
if [ -n "${KIRI_SKIP_KICAD6_SCHEMATICS}" ]; then
    KIRI_ARGS+=(--skip-kicad6)
fi

# KIRI_SKIP_CACHE -> --skip-cache
if [ -n "${KIRI_SKIP_CACHE}" ]; then
    KIRI_ARGS+=(--skip-cache)
fi

# KIRI_OLDER -> --older
if [ -n "${KIRI_OLDER}" ]; then
    KIRI_ARGS+=(--older "$KIRI_OLDER")
fi

# KIRI_NEWER -> --newer
if [ -n "${KIRI_NEWER}" ]; then
    KIRI_ARGS+=(--newer "$KIRI_NEWER")
fi

# KIRI_LAST -> --last
if [ -n "${KIRI_LAST}" ]; then
    KIRI_ARGS+=(--last "$KIRI_LAST")
fi

# KIRI_ALL -> --all
if [ -n "${KIRI_ALL}" ]; then
    KIRI_ARGS+=(--all)
fi

# Run Kiri and pass through all action arguments.
if [ -n "${KIRI_PROJECT_FILE}" ]; then
    kiri "${KIRI_ARGS[@]}" "$@" "$KIRI_PROJECT_FILE"
else
    kiri "${KIRI_ARGS[@]}" "$@"
fi
KIRI_STATUS=$?
exit "$KIRI_STATUS"
