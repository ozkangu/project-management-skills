---
name: project-execute
description: "Phase 5 of Project Builder. Sprint orchestration and delivery execution. Supports manual, hybrid, and auto execution modes, structured telemetry capture, and machine-readable release plans for dependency-aware delivery."
---

# Phase 5: Sprint Execution

Turn plans into delivered software. This phase orchestrates the actual build process, running work items through a structured delivery pipeline with quality gates.

## Prerequisites

Read from the project workspace:
- `state/estimate.json`
- `state/architecture.json`
- `state/release-plan.json`
- `state/project-meta.json`

Also read any PBIs relevant to the current sprint from `docs/pbis/`.

Treat `state/release-plan.json` as the machine-readable source of truth. `docs/release-plan.md` is optional supporting documentation.

## Execution Modes

Honor `execution.mode` from config or project meta:
- `manual`: require approval at every major gate
- `hybrid`: require approval at sprint boundaries, auto-progress within a sprint unless blocked
- `auto`: proceed end-to-end unless blocked, missing context, or a safety-critical decision requires intervention

## Execution Model

Each work item goes through six stages:

```
THINK → PLAN → BUILD → REVIEW → TEST → SHIP
```

## Dependency-Aware Scheduling

Determine execution order automatically from `state/release-plan.json`:
1. Build a DAG from work item dependencies
2. Identify independent groups
3. Identify the critical path
4. Present the execution order unless in `auto` mode

## Approval Gates

Resolve gates from the configured execution mode. Do not use one fixed approval policy for all runs.

## Telemetry Contract

Maintain `state/execution-log.json` throughout execution.

Telemetry is required for every shipped work item. Capture at minimum:
- provider
- model
- input_tokens
- output_tokens
- cached_tokens
- tool_calls
- wall_time_minutes
- iteration_count
- tests_passed
- tests_failed
- pricing_source

If exact token or cost telemetry is unavailable, record:
- `telemetry_quality`: `exact` | `estimated` | `missing`
- `telemetry_notes`: why the value is estimated or missing

Phase 6 depends on this file. Do not claim retro calibration quality higher than the telemetry quality supports.

## Progress Tracking

Maintain `state/execution-log.json` with telemetry and stage timestamps.

## Handling Blockers

When a work item is blocked:
1. Identify the blocker
2. Assess impact
3. Present options unless in fully automatic mode and a safe reorder is obvious
4. Wait for user decision when the blocker affects scope, architecture, security, cost controls, or external dependencies
