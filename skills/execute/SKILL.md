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

### THINK

Read the work item description, acceptance criteria, and relevant architecture context. Identify the implementation approach: which patterns to use, which components are affected, and any risks or unknowns to resolve before coding.

### PLAN

Break the work item into concrete sub-steps. Identify files to create or modify. List any dependencies on other work items or external resources. If the work item is too large for a single pass, define iteration boundaries.

### BUILD

Write the code. Make tool calls (file creation, edits, shell commands). Follow the architectural decisions from `state/architecture.json`. Stay within the scope of the current work item — do not fix unrelated issues or refactor adjacent code.

### REVIEW

Self-review the implementation against the work item's acceptance criteria. Run the linter if configured. Check for security concerns (injection, hardcoded secrets, missing input validation at system boundaries). If issues are found, return to BUILD.

### TEST

Run the relevant test suite. Capture pass/fail counts. If tests fail, return to BUILD with the failure details. If no test suite exists for this work item, note it as `tests_skipped` with a reason.

### SHIP

Mark the work item as done in the execution log. Record the completion timestamp. Update the execution log entry with final telemetry. If this work item unblocks others, note that they are now ready.

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

### Capture Strategies

There are three ways to capture telemetry data. Choose the best available:

1. **Agent self-report** — The agent records its own estimates after completing each work item. This is the default strategy. Mark `telemetry_quality` as `"estimated"`.

2. **Environment instrumented** — A wrapper script or environment integration captures actual API usage (token counts, timing, cost) from the provider. Mark `telemetry_quality` as `"exact"`.

3. **Post-hoc from billing** — Download usage data from the provider dashboard after execution completes and backfill the execution log. Mark `telemetry_quality` as `"exact"` if provider data is granular enough to map to individual work items, otherwise `"estimated"`.

If no telemetry is available at all, mark `telemetry_quality` as `"missing"` and record qualitative notes about what happened.

### Required Telemetry Fields

For every shipped work item, capture at minimum:
- `telemetry_quality`: `exact` | `estimated` | `missing`
- `provider`
- `model`
- `input_tokens`
- `output_tokens`
- `cached_tokens`
- `tool_calls`
- `wall_time_minutes`
- `iteration_count`
- `tests_passed`
- `tests_failed`
- `pricing_source`
- `estimated_cost_usd`

If a field cannot be captured, set it to `null` rather than omitting it.

Phase 6 depends on this file. Do not claim retro calibration quality higher than the telemetry quality supports.

## execution-log.json Schema

Save to `state/execution-log.json`:

```json
{
  "phase": "execute",
  "status": "IN_PROGRESS | DONE | BLOCKED",
  "started_at": "ISO-8601",
  "completed_at": "ISO-8601 | null",
  "execution_mode": "manual | hybrid | auto",
  "provider_context": {
    "provider": "openai",
    "model_aliases": {}
  },
  "work_items": [
    {
      "wi_id": "WI-001",
      "title": "",
      "type": "feature",
      "status": "pending | in_progress | done | blocked | skipped",
      "started_at": "ISO-8601 | null",
      "completed_at": "ISO-8601 | null",
      "stages": {
        "think":  { "started_at": "", "completed_at": "" },
        "plan":   { "started_at": "", "completed_at": "" },
        "build":  { "started_at": "", "completed_at": "" },
        "review": { "started_at": "", "completed_at": "" },
        "test":   { "started_at": "", "completed_at": "" },
        "ship":   { "started_at": "", "completed_at": "" }
      },
      "telemetry": {
        "telemetry_quality": "exact | estimated | missing",
        "provider": "",
        "model": "",
        "input_tokens": 0,
        "output_tokens": 0,
        "cached_tokens": 0,
        "tool_calls": 0,
        "wall_time_minutes": 0,
        "iteration_count": 1,
        "tests_passed": 0,
        "tests_failed": 0,
        "pricing_source": "runtime | config_override | benchmark | user_supplied",
        "estimated_cost_usd": 0
      },
      "blockers": [
        {
          "description": "",
          "resolved_at": "ISO-8601 | null",
          "resolution": ""
        }
      ],
      "notes": ""
    }
  ],
  "summary": {
    "total_wi": 0,
    "completed": 0,
    "blocked": 0,
    "total_tokens": 0,
    "total_cost_usd": 0,
    "total_wall_time_minutes": 0,
    "budget_burn_pct": {
      "tokens": 0,
      "cost": 0,
      "time": 0
    }
  }
}
```

## Progress Tracking with Budget Burn

After each work item completes, compute burn rates against the budget from `state/estimate.json`:

- `tokens_burn = tokens_used / tokens_budgeted`
- `cost_burn = cost_used / cost_budgeted`
- `time_burn = time_used / time_budgeted`

Update `summary.budget_burn_pct` in the execution log after every work item.

**Budget warning:** If any burn dimension exceeds 80% while work items remain unfinished, flag a budget warning. Present the burn rate to the user:
- In `manual` and `hybrid` modes: show the warning at the next approval gate
- In `auto` mode: pause execution and request user decision on whether to continue, re-scope, or stop

## Handling Blockers

When a work item is blocked:
1. Identify the blocker
2. Assess impact
3. Present options unless in fully automatic mode and a safe reorder is obvious
4. Wait for user decision when the blocker affects scope, architecture, security, cost controls, or external dependencies
