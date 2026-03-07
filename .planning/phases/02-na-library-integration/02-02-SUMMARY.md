---
phase: 02-na-library-integration
plan: 02
subsystem: config
tags: [home-assistant, repairs, config-migration, volkswagencarnet, country-selector]

# Dependency graph
requires:
  - phase: 02-na-library-integration
    plan: 01
    provides: CONF_COUNTRY, COUNTRY_LIST, DEFAULT_COUNTRY in const.py; config flow v4 with country dropdown
provides:
  - v3->v4 migration block in async_migrate_entry (renames CONF_REGION to CONF_COUNTRY in data and options)
  - HA Repairs fixable issue created after migration (confirm_country_{entry_id})
  - repairs.py with ConfirmCountryRepairFlow and async_create_fix_flow
  - Repair UI strings in strings.json and translations/en.json
  - README North America setup section and upgrade instructions
affects:
  - Future config entry handling (version 4 is now the current version)
  - Existing EU users upgrading (Repairs notification guides them to confirm country)

# Tech tracking
tech-stack:
  added: [homeassistant.components.repairs.RepairsFlow, homeassistant.helpers.issue_registry]
  patterns:
    - HA Repairs framework for post-migration user confirmation
    - Inline import of issue_registry inside migration block to avoid module-level dependency
    - async_create_fix_flow dispatcher pattern for routing repair issues to flows

key-files:
  created:
    - custom_components/volkswagencarnet/repairs.py
  modified:
    - custom_components/volkswagencarnet/__init__.py
    - custom_components/volkswagencarnet/strings.json
    - custom_components/volkswagencarnet/translations/en.json
    - README.md

key-decisions:
  - "Inline import of issue_registry inside v3->v4 block to avoid importing at module level where it may not be needed"
  - "Repair issue ID uses entry_id suffix (confirm_country_{entry_id}) to support multiple vehicles"
  - "async_create_fix_flow raises ValueError for unknown issue IDs to surface unexpected repair registrations"

patterns-established:
  - "HA Repairs pattern: async_migrate_entry creates issue -> repairs.py handles async_create_fix_flow -> ConfirmCountryRepairFlow shows form"
  - "Migration pattern: pop old key, set new key in both data and options dicts before calling async_update_entry"

requirements-completed: [NAL-05, NAL-07]

# Metrics
duration: 2min
completed: 2026-03-07
---

# Phase 02 Plan 02: NA Library Integration Migration Summary

**v3->v4 config entry migration with HA Repairs country confirmation flow and North America README documentation**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-07T15:54:44Z
- **Completed:** 2026-03-07T15:56:31Z
- **Tasks:** 2
- **Files modified:** 5

## Accomplishments

- Added v3->v4 migration block to `async_migrate_entry` that renames `CONF_REGION` to `CONF_COUNTRY` in both `entry.data` and `entry.options`, then creates a fixable HA Repairs issue
- Created `repairs.py` with `ConfirmCountryRepairFlow` that shows a pre-populated country dropdown and reloads the integration after user confirmation
- Added `issues.confirm_country` strings to both `strings.json` and `translations/en.json` for the Repairs UI
- Updated README with a dedicated North America Setup section explaining the country picker, VW Car-Net credentials for US/CA users, and upgrade instructions for the Repairs notification flow

## Task Commits

Each task was committed atomically:

1. **Task 1: Add v3-to-v4 migration and repairs flow** - `459a339` (feat)
2. **Task 2: Update README with NA setup instructions** - `91ef1dc` (docs)

## Files Created/Modified

- `custom_components/volkswagencarnet/__init__.py` - Added v3->v4 migration block with async_create_issue call
- `custom_components/volkswagencarnet/repairs.py` - New file: ConfirmCountryRepairFlow and async_create_fix_flow
- `custom_components/volkswagencarnet/strings.json` - Added issues.confirm_country repair strings
- `custom_components/volkswagencarnet/translations/en.json` - Added issues.confirm_country repair strings (EN)
- `README.md` - Added North America Setup section and updated Configuration section

## Decisions Made

- Inline import of `issue_registry as ir` inside the `if version == 3:` block, consistent with HA patterns and avoids module-level import of a module only needed during migration
- Repair issue ID uses `entry_id` suffix (`confirm_country_{entry.entry_id}`) so multi-vehicle setups each get their own repair notification
- `async_create_fix_flow` raises `ValueError` for unknown issue IDs to surface unexpected dispatch

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Migration and documentation complete; Phase 02 (NA Library Integration) is now fully implemented
- Existing EU users who upgrade will see the Repairs notification and can confirm their country without manual intervention
- NA users have clear README instructions for initial setup

---
*Phase: 02-na-library-integration*
*Completed: 2026-03-07*
