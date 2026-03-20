---
name: project-execute
description: "Phase 5 of Project Builder. Sprint orchestration and delivery execution. Implements a Think → Plan → Build → Review → Test → Ship cycle for each work item. Manages dependency-aware scheduling, configurable approval gates, progress tracking, and the fix-first review principle. Runs work items through a structured delivery pipeline."
---

# Phase 5: Sprint Execution

Turn plans into delivered software. This phase orchestrates the actual build process, running work items through a structured delivery pipeline with quality gates.

## Prerequisites

Read from the project workspace:
- `state/estimate.json` — work items, dependencies, timeline
- `state/architecture.json` — technical blueprint
- `docs/release-plan.md` — sprint groupings

Also read any PBIs relevant to the current sprint from `docs/pbis/`.

## Execution Model

Each work item goes through six stages:

```
THINK → PLAN → BUILD → REVIEW → TEST → SHIP
```

### Stage Details

**THINK** — Understand the work item fully before writing any code.
- Read the PBI and all linked ACs
- Read relevant architecture decisions
- Identify which files need to change
- Note edge cases and failure modes from the architecture phase
- Estimate: is the original estimate still accurate? Flag if not.

**PLAN** — Design the approach.
- List the specific files to create or modify
- Outline the implementation approach (pseudocode level)
- Identify test strategy (what tests to write, which to run)
- Note any decisions needed from user

**BUILD** — Write the code.
- Implement the work item
- Write unit tests alongside the code (not after)
- Follow the tech stack conventions from the codebase
- Keep commits small and focused

**REVIEW** — Fix-first review principle.
- Review your own output with fresh eyes
- Fix issues you find BEFORE presenting to user
- Check against the ACs — does each one pass?
- Verify completeness: ALL ACs must be satisfied, not just the obvious ones (apply "boil the lake" principle — uncover and address all edge cases and requirements)
- Check for: security issues, error handling, edge cases, naming, documentation
- The goal is to present clean work, not work-in-progress

**TEST** — Verify everything works.
- Run unit tests — all must pass
- Run integration tests if applicable
- Manually verify against ACs
- Check error paths and edge cases
- If tests fail, go back to BUILD — don't ship broken code

**SHIP** — Mark complete and move on.
- Update the execution log
- Note any deviations from the estimate
- Flag any concerns for the retro
- Move to the next work item

## Sprint Orchestration

### Sprint Start

For each sprint:

1. **Load the sprint** — Get work items for this sprint from the release plan
2. **Dependency check** — Verify all dependencies from previous sprints are satisfied
3. **Capacity check** — Is the sprint scope realistic given the estimates?
4. **Present sprint plan:**

```
SPRINT {N}: {Sprint Name}
━━━━━━━━━━━━━━━━━━━━━━━

Work Items: {count}
Estimated: {hours} hours, ${cost}
Dependencies satisfied: {yes/no — list any blockers}

Items:
  1. WI-{NNN}: {title} [{model}, {time}] — depends on: {deps or "none"}
  2. WI-{NNN}: {title} [{model}, {time}] — depends on: {deps or "none"}
  3. ...

Execution order (dependency-aware):
  Parallel Group 1: WI-001, WI-002
  Sequential: WI-003 (needs WI-001)
  Parallel Group 2: WI-004, WI-005 (need WI-003)
  ...

Ready to start?
```

### Dependency-Aware Scheduling

Determine execution order automatically:

1. Build a DAG from work item dependencies
2. Identify independent groups (can run in parallel via subagents)
3. Calculate the critical path
4. Present the execution order

For items that CAN run in parallel — use the Agent tool to spawn concurrent work if the environment supports it. If not, run sequentially in dependency order.

### Approval Gates

Some transitions require user approval. Configurable in `config/pipeline-config.json`, defaults:

| Gate | Default | Description |
|---|---|---|
| Sprint start | Required | User confirms sprint scope |
| Build → Review | Auto | No gate — always review your own work |
| Review → Test | Auto | No gate — always test |
| Test → Ship | Optional | User reviews final output |
| Sprint complete | Required | User confirms sprint is done |

When a gate is required, present the output and wait for user confirmation:

```
APPROVAL GATE: {gate_name}
━━━━━━━━━━━━━━━━━━━━━━━━

Work Item: WI-{NNN}: {title}
Stage: {current stage}

Output:
  {summary of what was produced}
  {files created/modified}
  {test results}

ACs verified:
  ✅ AC-001: {title}
  ✅ AC-002: {title}
  ⚠️ AC-003: {title} — partial (explain)

Approve to continue? Or provide feedback to revise.
```

## Fix-First Review Principle

When reviewing (your own or someone else's output), follow the fix-first principle:

1. **Don't just find problems — fix them.** If you see an issue and can fix it, do it. Don't make a list of issues and hand it back.
2. **Categorize what you can't fix:**
   - **Must fix** — Blocks shipping. Wrong behavior, security issue, data corruption risk.
   - **Should fix** — Not blocking but harmful. Poor naming, missing error messages, inefficient queries.
   - **Could fix** — Nice to have. Style preferences, minor optimizations.
3. **Fix everything in "must fix" before presenting for approval.**
4. **Fix "should fix" items if time permits.**
5. **Note "could fix" items for future improvement.**

## Progress Tracking

Maintain `state/execution-log.json` throughout execution:

```json
{
  "phase": "execute",
  "started_at": "2026-03-20T14:00:00Z",
  "current_sprint": 1,
  "sprints": [
    {
      "sprint_number": 1,
      "name": "Foundation",
      "started_at": "2026-03-20T14:00:00Z",
      "completed_at": null,
      "work_items": [
        {
          "id": "WI-001",
          "title": "Project scaffolding",
          "status": "shipped",
          "stages": {
            "think": {"started": "...", "completed": "..."},
            "plan": {"started": "...", "completed": "..."},
            "build": {"started": "...", "completed": "..."},
            "review": {"started": "...", "completed": "...", "issues_found": 2, "issues_fixed": 2},
            "test": {"started": "...", "completed": "...", "tests_passed": 8, "tests_failed": 0},
            "ship": {"started": "...", "completed": "..."}
          },
          "estimate": {
            "original_tokens": 23500,
            "actual_tokens": 28000,
            "original_minutes": 4,
            "actual_minutes": 5,
            "original_cost": 0.42,
            "actual_cost": 0.50
          },
          "deviations": ["Needed extra iteration for test setup"],
          "files_created": ["src/index.ts", "package.json", "tsconfig.json"],
          "files_modified": []
        }
      ],
      "summary": {
        "items_total": 3,
        "items_shipped": 2,
        "items_in_progress": 1,
        "items_blocked": 0,
        "estimated_hours": 3.5,
        "actual_hours": 4.2,
        "estimated_cost": 8.50,
        "actual_cost": 10.20
      }
    }
  ]
}
```

### Progress Display

After each work item ships, show progress:

```
SPRINT {N} PROGRESS
━━━━━━━━━━━━━━━━━━

[████████░░░░░░░░] 50% (3/6 items shipped)

Shipped:
  ✅ WI-001: Project scaffolding (5min, $0.50)
  ✅ WI-002: CI/CD pipeline (7min, $0.90)
  ✅ WI-003: Database setup (4min, $0.35)

In Progress:
  🔄 WI-004: Auth endpoints (BUILD stage)

Remaining:
  ⬚ WI-005: Core CRUD
  ⬚ WI-006: Protected routes

Time: {actual} / {estimated} hours
Cost: ${actual} / ${estimated}
```

## Handling Blockers

When a work item is blocked:

1. **Identify the blocker** — Missing dependency? Unclear requirement? Technical issue?
2. **Assess impact** — Does this block other items? Can we reorder?
3. **Present to user:**

```
⛔ BLOCKED: WI-{NNN}: {title}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Blocker: {description}
Impact: Blocks {list of dependent WIs}

Options:
  1. Resolve the blocker: {what needs to happen}
  2. Skip and continue: {what we can work on instead}
  3. Descope: Remove from current sprint
```

4. **Wait for user decision** — don't auto-skip important work.

## Sprint Completion

At the end of each sprint:

```
SPRINT {N} COMPLETE
━━━━━━━━━━━━━━━━━━

Items: {shipped}/{total} shipped
Time: {actual_hours} hours (estimated: {estimated_hours})
Cost: ${actual} (estimated: ${estimated})

Variance:
  Time: {+/- percentage}%
  Cost: {+/- percentage}%

Deviations:
  • {notable deviation 1}
  • {notable deviation 2}

Concerns for retro:
  • {concern 1}
  • {concern 2}

Next sprint: {sprint name} ({item_count} items, {estimated_hours} hours)
Continue?
```

## Phase Completion

When all sprints are complete:

```
EXECUTION COMPLETE — {project_name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sprints: {completed}/{total}
Work Items: {shipped}/{total} shipped
Total Time: {actual_hours} hours (estimated: {estimated_hours})
Total Cost: ${actual} (estimated: ${estimated})

Overall Variance:
  Time: {+/- percentage}%
  Cost: {+/- percentage}%

Items with significant deviation: {list}
Blockers encountered: {count}

Status: DONE

Ready for Phase 6 (Retrospective)?
```
