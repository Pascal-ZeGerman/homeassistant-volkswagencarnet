---
phase: 02-na-library-integration
plan: 01
subsystem: config
tags: [volkswagencarnet, home-assistant, config-flow, na-library, country-selector]

# Dependency graph
requires:
  - phase: 01-dev-environment
    provides: Dev environment for running HA with the integration
provides:
  - Forked NA-capable volkswagencarnet library as the integration's dependency
  - Country dropdown config flow (15 VW-market countries + Other escape hatch)
  - CONF_COUNTRY / COUNTRY_LIST constants for use by migration plan (02-02)
  - VERSION=4 config entry schema
affects:
  - 02-02-migration (reads CONF_REGION fallback established here)

# Tech tracking
tech-stack:
  added:
    - volkswagencarnet @ git+https://github.com/Pascal-ZeGerman/volkswagencarnet@main (forked library with NA+EU support)
  patterns:
    - CONF_COUNTRY with CONF_REGION fallback for backward compat in coordinator and reauth
    - vol.In(COUNTRY_LIST) dropdown with Other + custom-code escape hatch
    - Collapse "OTHER" to raw 2-char code before storing in config entry

key-files:
  created: []
  modified:
    - requirements.txt
    - custom_components/volkswagencarnet/manifest.json
    - custom_components/volkswagencarnet/const.py
    - custom_components/volkswagencarnet/config_flow.py
    - custom_components/volkswagencarnet/__init__.py
    - custom_components/volkswagencarnet/strings.json
    - custom_components/volkswagencarnet/translations/en.json

key-decisions:
  - "Track forked library via git URL (not PyPI) — targets main branch until stable release"
  - "vol.Required(CONF_COUNTRY) with no default — user must explicitly pick country"
  - "CONF_REGION kept in imports for migration fallback reads in Plan 02-02"
  - "VERSION bumped 3->4 to trigger async_migrate_entry for existing entries"
  - "Other collapse: store cleaned 2-char code in CONF_COUNTRY, never store country_custom in config entry"

patterns-established:
  - "Country selector pattern: vol.In(COUNTRY_LIST) with OTHER + free-text collapse"
  - "Backward compat pattern: data.get(CONF_COUNTRY, data.get(CONF_REGION, DEFAULT_COUNTRY))"

requirements-completed: [NAL-01, NAL-02, NAL-03, NAL-04, NAL-06]

# Metrics
duration: 2min
completed: 2026-03-07
---

# Phase 2 Plan 1: NA Library Integration - Country Dropdown Config Flow Summary

**Swapped volkswagencarnet to forked NA-capable git library and replaced free-text region field with a 15-country dropdown (US/CA/DE/etc.) with Other escape hatch, VERSION bumped to 4**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-07T15:49:57Z
- **Completed:** 2026-03-07T15:52:13Z
- **Tasks:** 2
- **Files modified:** 7

## Accomplishments

- Replaced `volkswagencarnet==5.4.5` with forked git URL in both `requirements.txt` and `manifest.json` for HA auto-install
- Added `CONF_COUNTRY`, `CONF_COUNTRY_CUSTOM`, `DEFAULT_COUNTRY`, and `COUNTRY_LIST` (15 countries + OTHER) to `const.py`
- Updated config flow DATA_SCHEMA to `vol.Required(CONF_COUNTRY): vol.In(COUNTRY_LIST)` with Optional `CONF_COUNTRY_CUSTOM` for the Other path
- Bumped `VERSION = 4`, added Other-collapse logic (validates 2-char ISO code, stores clean code, strips `country_custom` before saving to config entry)
- Updated reauth and coordinator `Connection()` calls to use `CONF_COUNTRY` with `CONF_REGION` fallback for pre-migration entries
- Replaced `CONF_REGION` free-text in options flow with `CONF_COUNTRY` dropdown using same fallback logic
- Updated `strings.json` and `translations/en.json`: replaced `region`/`debug` keys with `country`/`country_custom`, added `invalid_country_code` error
- Zero entity platform files modified — drop-in library with same API surface

## Task Commits

Each task was committed atomically:

1. **Task 1: Swap library dependency and define country constants** - `8ec8344` (feat)
2. **Task 2: Update config flow, coordinator, and UI strings for country selector** - `f153b0c` (feat)

## Files Created/Modified

- `requirements.txt` - Changed from `volkswagencarnet==5.4.5` to git URL of forked library
- `custom_components/volkswagencarnet/manifest.json` - Set requirements array to forked git URL for HA auto-install
- `custom_components/volkswagencarnet/const.py` - Added CONF_COUNTRY, CONF_COUNTRY_CUSTOM, DEFAULT_COUNTRY, COUNTRY_LIST (16 entries including OTHER)
- `custom_components/volkswagencarnet/config_flow.py` - Country dropdown in DATA_SCHEMA, Other collapse logic, VERSION=4, updated reauth and options flow
- `custom_components/volkswagencarnet/__init__.py` - Coordinator Connection now uses CONF_COUNTRY with CONF_REGION fallback
- `custom_components/volkswagencarnet/strings.json` - country/country_custom fields, invalid_country_code error, removed region/debug
- `custom_components/volkswagencarnet/translations/en.json` - Same changes mirrored from strings.json

## Decisions Made

- Track forked library via git URL (not PyPI) — user decision to target main branch until stable release on PyPI
- `vol.Required(CONF_COUNTRY)` with no default — user must explicitly pick, no silent default country
- `CONF_REGION` kept in imports for backward compat fallback; migration in Plan 02-02 will handle full conversion
- VERSION bumped 3->4 to signal schema change and trigger migration handler for existing installs

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required. The forked library will be auto-installed by Home Assistant when the integration loads.

## Next Phase Readiness

- Config flow accepts country selection and passes it to `Connection(country=...)` for both NA and EU routing
- Existing config entries (VERSION 3, CONF_REGION) will still work via fallback logic until migration in Plan 02-02
- Plan 02-02 can now implement `async_migrate_entry` to upgrade v3 entries: map CONF_REGION value to CONF_COUNTRY, bump version to 4

## Self-Check: PASSED

- FOUND: const.py
- FOUND: config_flow.py
- FOUND: __init__.py
- FOUND: 02-01-SUMMARY.md
- FOUND commit: 8ec8344 (Task 1)
- FOUND commit: f153b0c (Task 2)

---
*Phase: 02-na-library-integration*
*Completed: 2026-03-07*
