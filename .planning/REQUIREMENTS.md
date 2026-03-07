# Requirements: VW CarNet HA Integration — NA Expansion

**Defined:** 2026-03-02
**Core Value:** NA users can connect their VW vehicles to Home Assistant via a country-based config flow that routes to the correct backend library

## v1 Requirements

### Dev Environment

- [x] **DEV-01**: Developer can build a Docker container running Home Assistant with the custom component loaded
- [x] **DEV-02**: Developer can access HA UI (config flow, integrations page) from host browser
- [x] **DEV-03**: Developer can modify integration source code and rebuild container to test changes
- [x] **DEV-04**: Docker setup includes all dependencies (volkswagencarnet library, HA requirements)

### NA Library Integration

- [x] **NAL-01**: Integration uses new library (drop-in replacement) that supports both NA and EU regions
- [x] **NAL-02**: Config flow presents a country selector instead of the current region code field
- [x] **NAL-03**: Country selection resolves to correct backend path (NA or EU) transparently
- [x] **NAL-04**: All existing entity types (sensor, binary_sensor, lock, switch, climate, number, select, device_tracker) work with NA vehicles
- [x] **NAL-05**: Existing EU users are not broken — migration path from current config to new country selector (validated via code review and tests, no EU credentials available)
- [x] **NAL-06**: API rate limiting behavior is preserved (scan interval, 480 calls/day awareness)
- [x] **NAL-07**: Clear installation and setup instructions for HA admin users (HACS install, manual install, config flow walkthrough)

## v2 Requirements

### Testing & Quality

- **TEST-01**: Automated tests cover country-to-backend routing logic
- **TEST-02**: Config flow migration tests for region → country upgrade
- **TEST-03**: Docker dev environment supports running pytest inside container

## Out of Scope

| Feature | Reason |
|---------|--------|
| NYC Alternate Side Parking | Standalone integration, separate project |
| Mock/stub VW API | Owner has real NA account, mocking adds complexity without value |
| VS Code devcontainer | Simple Docker rebuild workflow preferred |
| New entity types for NA-specific features | Same instruments as EU, drop-in replacement |
| CI/CD pipeline changes | Focus on local dev and integration code |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| DEV-01 | Phase 1 - Dev Environment | Complete |
| DEV-02 | Phase 1 - Dev Environment | Complete |
| DEV-03 | Phase 1 - Dev Environment | Complete |
| DEV-04 | Phase 1 - Dev Environment | Complete |
| NAL-01 | Phase 2 - NA Library Integration | Complete |
| NAL-02 | Phase 2 - NA Library Integration | Complete |
| NAL-03 | Phase 2 - NA Library Integration | Complete |
| NAL-04 | Phase 2 - NA Library Integration | Complete |
| NAL-05 | Phase 2 - NA Library Integration | Complete |
| NAL-06 | Phase 2 - NA Library Integration | Complete |
| NAL-07 | Phase 2 - NA Library Integration | Complete |

**Coverage:**
- v1 requirements: 11 total
- Mapped to phases: 11
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-02*
*Last updated: 2026-03-02 after roadmap creation*
