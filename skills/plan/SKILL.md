---
name: project-plan
description: "Phase 4 of Project Builder. Generates all project documentation from discovery, scope, architecture, and estimation outputs. Produces project docs plus a machine-readable release plan for end-to-end automation."
---

# Phase 4: Project Plan & Documentation

Generate the full suite of project documents. This phase reads previous outputs and produces both human-readable documents and machine-readable planning artifacts.

## Prerequisites

> **Spec Execution Phase.** This phase runs automatically from the spec. It reads all upstream state files and generates planning artifacts. If upstream files are missing, run in degraded mode with DONE_WITH_CONCERNS rather than blocking.

Read from the project workspace:
- `state/discovery-report.json`
- `state/project-scope.json`
- `state/architecture.json`
- `state/estimate.json`

If any are missing, do not claim full traceability. Either:
- run in degraded mode with `DONE_WITH_CONCERNS`, or
- block and ask for the missing inputs.

Never report 100% traceability unless all required upstream artifacts exist.

## Outputs

Generate the standard markdown docs in `docs/`, plus:
- `state/release-plan.json` — machine-readable sprint and release structure

## release-plan.json Contract

Save a structured plan that Phase 5 can consume directly:

```json
{
  "releases": [
    {
      "id": "REL-1",
      "name": "MVP",
      "sprints": [
        {
          "id": "SPR-1",
          "name": "Foundation",
          "work_items": ["WI-001", "WI-002"],
          "dependencies": [],
          "execution_mode": "hybrid"
        }
      ]
    }
  ]
}
```

The markdown `docs/release-plan.md` is for humans. `state/release-plan.json` is the source of truth for Phase 5.

## Traceability Matrix

Any broken chain means something was missed. If upstream files are missing, mark the traceability result partial and explain why.

## Output

All documents saved to `docs/`. Update `state/project-meta.json` with `phases_completed` including `plan`.
