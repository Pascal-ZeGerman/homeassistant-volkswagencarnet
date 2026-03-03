---
phase: 01-dev-environment
plan: 01
subsystem: infra
tags: [docker, docker-compose, home-assistant, inotifywait, bash]

# Dependency graph
requires: []
provides:
  - Docker Compose dev environment with persistent and fresh profiles
  - Entrypoint script that installs volkswagencarnet before launching HA
  - Host-side file watcher that restarts HA container on .py changes
  - Minimal HA configuration with debug logging for the integration
affects:
  - 02-na-library-integration

# Tech tracking
tech-stack:
  added: [docker, docker-compose, inotifywait]
  patterns:
    - Volume-mount pattern for live code reload without container rebuild
    - Entrypoint pip-install pattern for runtime dependency injection
    - Host-side inotifywait watcher with polling fallback for cross-filesystem compatibility

key-files:
  created:
    - dev/compose.yaml
    - dev/entrypoint.sh
    - dev/watch.sh
    - config/configuration.yaml
  modified:
    - .gitignore

key-decisions:
  - "Use ghcr.io/home-assistant/home-assistant:stable (official image, always latest stable)"
  - "Mount custom_components/ as volume — no COPY step, edits reflected immediately"
  - "Entrypoint pip-installs requirements.txt at startup — ensures volkswagencarnet available even if HA manifest auto-install fails"
  - "Host-side inotifywait watcher (not container-side) — inotify events don't propagate into containers"
  - "config/ excluded from git, config/configuration.yaml force-tracked via !config/configuration.yaml gitignore negation"

patterns-established:
  - "Watcher pattern: inotifywait --polling on host, 2s debounce, docker restart"
  - "Fresh profile pattern: named volume instead of host mount for clean-slate testing"

requirements-completed: [DEV-01, DEV-02, DEV-03, DEV-04]

# Metrics
duration: 2min
completed: 2026-03-03
---

# Phase 1 Plan 01: Dev Environment Summary

**Docker Compose HA dev environment with inotifywait file watcher, pip-install entrypoint, and persistent/fresh profiles for edit-restart-test loop**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-03T17:36:48Z
- **Completed:** 2026-03-03T17:38:43Z
- **Tasks:** 2 of 2
- **Files modified:** 5

## Accomplishments

- Docker Compose setup with default (persistent) and fresh (clean-slate) profiles for HA dev
- Entrypoint script that pip-installs volkswagencarnet from requirements.txt before launching HA, preventing ModuleNotFoundError
- Host-side file watcher using inotifywait with polling fallback and 2s debounce for reliable auto-restart
- HA configuration with debug logging enabled for the integration from the start

## Task Commits

Each task was committed atomically:

1. **Task 1: Create Docker dev environment infrastructure** - `45e215b` (feat)
2. **Task 2: Create file watcher script and validate Docker setup** - `47f0aaa` (feat)

## Files Created/Modified

- `dev/compose.yaml` - Docker Compose v2 with homeassistant (default) and homeassistant-fresh (fresh profile) services, named volume ha-fresh-config
- `dev/entrypoint.sh` - Bash startup script: pip installs requirements.txt then execs python -m homeassistant
- `dev/watch.sh` - Host-side watcher: inotifywait --polling on custom_components/, 2s debounce, docker restart ha-dev
- `config/configuration.yaml` - Minimal HA config with debug logging for custom_components.volkswagencarnet and volkswagencarnet
- `.gitignore` - Added config/ exclusion and !config/configuration.yaml negation to track only the minimal config

## Decisions Made

- Used `ghcr.io/home-assistant/home-assistant:stable` (the GitHub Container Registry image) as specified in the plan
- Ran `git add -f config/configuration.yaml` because git won't stage files inside an ignored directory even with negation patterns — this is expected behavior and the file is correctly tracked in git history
- `inotifywait --polling` flag used for cross-filesystem reliability (bind mounts, network filesystems, WSL2)
- `docker compose config --quiet` validated both default and fresh profiles successfully

## Deviations from Plan

None - plan executed exactly as written.

One minor implementation note: `git add -f` was required to force-track `config/configuration.yaml` because git ignores all files in `config/` before evaluating the `!config/configuration.yaml` negation pattern. This is expected git behavior and not a deviation from the plan's intent.

## Issues Encountered

None - all verification checks passed on first attempt.

## User Setup Required

None - no external service configuration required. Developer can run `docker compose up` from the `dev/` directory immediately.

## Next Phase Readiness

- Dev environment is fully operational: `cd dev && docker compose up` starts HA with the integration loaded
- File watcher: `cd dev && ./watch.sh` on the host enables auto-restart on code changes
- Fresh testing: `docker compose --profile fresh up` for clean HA config
- Phase 2 (NA library integration) can proceed — the dev environment will load whatever integration code is mounted

---
*Phase: 01-dev-environment*
*Completed: 2026-03-03*

## Self-Check: PASSED

- dev/compose.yaml: FOUND
- dev/entrypoint.sh: FOUND
- dev/watch.sh: FOUND
- config/configuration.yaml: FOUND
- 01-01-SUMMARY.md: FOUND
- Commit 45e215b: FOUND
- Commit 47f0aaa: FOUND
