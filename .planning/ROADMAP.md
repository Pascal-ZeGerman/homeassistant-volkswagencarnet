# Roadmap: VW CarNet HA Integration — NA Expansion

## Overview

Two phases deliver the complete expansion: first, a containerized dev environment that makes iteration fast and reliable; then, the NA library integration that adds country-based backend routing so North American VW owners can use the same integration EU users already rely on.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Dev Environment** - Containerized HA instance with the integration pre-loaded for local testing (completed 2026-03-03)
- [ ] **Phase 2: NA Library Integration** - Drop-in backend replacement with country selector and EU backward compatibility

## Phase Details

### Phase 1: Dev Environment
**Goal**: Developer can build, run, and iterate on the integration in a local Docker container
**Depends on**: Nothing (first phase)
**Requirements**: DEV-01, DEV-02, DEV-03, DEV-04
**Success Criteria** (what must be TRUE):
  1. Developer runs a single command and gets a running HA instance with the integration loaded
  2. Developer can open the HA UI in a host browser and reach the integrations config flow
  3. Developer edits integration source code, rebuilds the container, and the change is reflected without manual file copying
  4. Container environment includes all required dependencies (volkswagencarnet library and HA requirements) with no manual pip installs
**Plans:** 1/1 plans complete

Plans:
- [x] 01-01-PLAN.md — Docker dev environment: compose, entrypoint, watcher, config

### Phase 2: NA Library Integration
**Goal**: Users in North America can add the integration using a country picker that routes to the correct backend, while existing EU users continue working without reconfiguration
**Depends on**: Phase 1
**Requirements**: NAL-01, NAL-02, NAL-03, NAL-04, NAL-05, NAL-06, NAL-07
**Success Criteria** (what must be TRUE):
  1. Config flow shows a country selector and uses it to route to either the NA or EU backend library transparently
  2. An NA VW account completes setup and exposes the same entity types (sensor, binary_sensor, lock, switch, climate, number, select, device_tracker) as an EU account
  3. An existing EU config entry upgrades to the new country-based format without requiring the user to reconfigure
  4. Scan interval and 480-calls/day rate limiting behavior works identically for both NA and EU vehicles
**Plans:** 2 plans

Plans:
- [ ] 02-01-PLAN.md — Library swap + country selector config flow (NAL-01, NAL-02, NAL-03, NAL-04, NAL-06)
- [ ] 02-02-PLAN.md — Config entry migration, repairs flow, and documentation (NAL-05, NAL-07)

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Dev Environment | 1/1 | Complete   | 2026-03-03 |
| 2. NA Library Integration | 0/2 | Not started | - |
