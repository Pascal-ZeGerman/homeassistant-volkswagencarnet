#!/bin/bash
# watch.sh -- Host-side file watcher for VW CarNet HA integration development
#
# Monitors custom_components/ for .py file changes and auto-restarts the HA container.
# Run this on the HOST machine (not inside the container).
#
# Usage:
#   cd dev && ./watch.sh
#   HA_CONTAINER=my-container ./watch.sh   # override container name

set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
WATCH_DIR="$(realpath "${SCRIPT_DIR}/../custom_components")"
HA_CONTAINER="${HA_CONTAINER:-ha-dev}"
DEBOUNCE_SECS=2

echo "[watch] Watching: ${WATCH_DIR}"
echo "[watch] Container: ${HA_CONTAINER}"
echo "[watch] Debounce: ${DEBOUNCE_SECS}s after last change"
echo "[watch] Press Ctrl+C to stop"

do_restart() {
    echo "[watch] Change detected — waiting ${DEBOUNCE_SECS}s for writes to settle..."
    sleep "${DEBOUNCE_SECS}"
    echo "[watch] Restarting container: ${HA_CONTAINER}"
    docker restart "${HA_CONTAINER}"
    echo "[watch] Container restarted. Resuming watch..."
}

if command -v inotifywait &>/dev/null; then
    echo "[watch] Using inotifywait (inotify-tools)"
    while true; do
        # --polling for reliability on all filesystem types (incl. network/bind mounts)
        # close_write: file saved; moved_to: atomic save (editors like vim)
        inotifywait --polling -r -e close_write,moved_to \
            --include '\.py$' \
            "${WATCH_DIR}" &>/dev/null
        do_restart
    done
else
    echo "[watch] inotifywait not found — falling back to polling (install inotify-tools for better performance)"
    prev_hash=""
    while true; do
        # Compute combined md5 of all .py files in watch dir
        current_hash=$(find "${WATCH_DIR}" -name "*.py" -type f -exec md5sum {} + 2>/dev/null | sort | md5sum | awk '{print $1}')
        if [ -n "${prev_hash}" ] && [ "${current_hash}" != "${prev_hash}" ]; then
            do_restart
        fi
        prev_hash="${current_hash}"
        sleep 2
    done
fi
