#!/bin/bash
set -e

echo "[dev-entrypoint] Starting VW CarNet development environment"

if [ -f /requirements.txt ]; then
    echo "[dev-entrypoint] Installing requirements from /requirements.txt"
    pip install --quiet --no-cache-dir --force-reinstall -r /requirements.txt
    echo "[dev-entrypoint] Requirements installed"
else
    echo "[dev-entrypoint] No /requirements.txt found, skipping pip install"
fi

echo "[dev-entrypoint] Launching Home Assistant"
exec python -m homeassistant --config /config "$@"
