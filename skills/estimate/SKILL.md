---
name: project-estimate
description: "Phase 3 of Project Builder. AI-native estimation that goes beyond story points. Estimates token consumption, model mix (Haiku/Sonnet/Opus), tool call overhead, iteration budget, and parallelizability for each work item. Produces cost projections (tokens × price), timeline projections (sequential vs parallel vs realistic), and dependency graphs with critical path analysis."
---

# Phase 3: AI-Native Estimation

Traditional estimation asks "how many dev hours?" AI-native estimation asks "how many tokens, which models, and what's the iteration budget?" This phase produces cost and timeline projections grounded in how AI agents actually work.

## Prerequisites

Read from the project workspace:
- `state/project-scope.json` — requirements and scope
- `state/architecture.json` — components, APIs, data model

Also read `references/estimation-benchmarks.json` from the project-builder skill directory for reference data on token costs and model capabilities.

If `retro/estimation-calibration.json` exists from a previous project, read it and apply the calibration factors to improve accuracy of token and cost estimates for this project.

## Step 1: Work Item Decomposition

Break each in-scope requirement into atomic work items. A work item is the smallest unit of work that produces a testable output.

### Decomposition Rules

1. **One work item = one testable deliverable** — A function, an endpoint, a migration, a test suite, a config file
2. **Work items map to requirements** — Every work item traces back to at least one REQ-ID
3. **Include hidden work** — Don't just list features. Include: setup/scaffolding, testing, documentation, CI/CD configuration, deployment scripts, monitoring setup
4. **Separate research from implementation** — If a work item requires investigation (choosing a library, figuring out an API, reading docs), that's a separate work item

### Work Item Template

For each work item:

```
WI-{NNN}: {Title}
  Requirement: {REQ-IDs}
  Component: {which architectural component}
  Type: scaffold | feature | api_endpoint | data_model | migration | test | config | docs | research | integration | deployment
  Description: {What needs to be done}
  Inputs: {What's needed to start — other WIs, decisions, external info}
  Output: {What gets produced — file, endpoint, config, etc.}
  Dependencies: {WI-IDs that must complete first}
  Parallelizable: {yes | no | partial}
```

## Step 2: Per-Item Estimation

For each work item, estimate these dimensions:

### Token Estimation

Tokens are the fundamental unit of AI work. Estimate based on:

| Estimation Factor | Description | How to Estimate |
|---|---|---|
| **Context tokens** | Code/docs the agent needs to read to understand the task | File sizes of relevant code + documentation |
| **Reasoning tokens** | Thinking through the approach | Complexity × reasoning multiplier (see benchmarks) |
| **Output tokens** | Code, tests, docs generated | Expected output size (lines × ~4 tokens/line for code) |
| **Tool call tokens** | File reads, writes, bash commands | ~500 tokens per tool call round-trip |
| **Iteration tokens** | Retries, fixes, test-fail-fix cycles | Base estimate × iteration multiplier |

### Model Mix

Not every task needs the most capable model. Recommend a model for each work item:

| Model | Best For | Token Cost (approx) |
|---|---|---|
| **Haiku** | Boilerplate, simple CRUD, config files, formatting, simple tests | $0.25/M input, $1.25/M output |
| **Sonnet** | Standard features, API endpoints, moderate logic, most tests | $3/M input, $15/M output |
| **Opus** | Complex algorithms, architecture decisions, subtle bugs, security review | $15/M input, $75/M output |

### Complexity Assessment

Rate each work item:

| Complexity | Description | Token Multiplier | Iteration Budget |
|---|---|---|---|
| **Trivial** | Copy-paste with adaptation, config changes | 1x | 1 iteration |
| **Simple** | Standard patterns, well-understood | 1.5x | 1-2 iterations |
| **Medium** | Some design decisions, moderate logic | 2x | 2-3 iterations |
| **Complex** | Novel approach needed, multiple components | 3x | 3-5 iterations |
| **Research** | Unknown territory, exploration required | 5x | 5-10 iterations |

### Risk Factor

Add a risk multiplier:

| Risk Level | Multiplier | When |
|---|---|---|
| Low | 1.0 | Well-understood domain, proven patterns |
| Medium | 1.3 | Some unknowns, standard but unfamiliar tech |
| High | 1.8 | New tech, external dependencies, unclear requirements |
| Very High | 2.5 | Bleeding edge, regulatory, real-time constraints |

### Per-Item Estimate

```json
{
  "id": "WI-001",
  "title": "User authentication endpoint",
  "estimate": {
    "context_tokens": 15000,
    "reasoning_tokens": 8000,
    "output_tokens": 12000,
    "tool_calls": 25,
    "tool_call_tokens": 12500,
    "iteration_budget": 3,
    "total_tokens_per_iteration": 47500,
    "total_tokens_estimated": 142500,
    "model": "sonnet",
    "complexity": "medium",
    "risk": "low",
    "risk_multiplier": 1.0,
    "final_token_estimate": 142500,
    "parallelizable": true,
    "estimated_wall_time_minutes": 8,
    "dependencies": []
  }
}
```

## Step 3: Cost Model

Calculate total cost from token estimates:

```
Per work item:
  base_cost = (input_tokens × input_price) + (output_tokens × output_price)
  tool_cost = tool_calls × avg_tool_cost
  iteration_cost = base_cost × iteration_budget
  risk_adjusted = iteration_cost × risk_multiplier

Total:
  subtotal = sum(all work items risk_adjusted cost)
  buffer = subtotal × buffer_percentage (default 20%)
  total = subtotal + buffer
```

**Note on token pricing:** For the cost model above, `input_tokens` = `context_tokens` + `reasoning_tokens` (the total tokens consumed before generating output), and `output_tokens` = the tokens generated. This split determines which model's pricing tier applies to each portion of work.

Present as a cost breakdown table:

```
COST ESTIMATE
━━━━━━━━━━━━

Work Items by Model:
  Haiku tasks:  {count} items  — ${cost}
  Sonnet tasks: {count} items  — ${cost}
  Opus tasks:   {count} items  — ${cost}

Subtotal:                        ${subtotal}
Buffer (20%):                    ${buffer}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL ESTIMATED COST:            ${total}

Token Breakdown:
  Input tokens:  {total_input}M
  Output tokens: {total_output}M
  Tool calls:    {total_tool_calls}
```

## Step 4: Timeline Projection

Calculate three timeline scenarios:

### Sequential (Worst Case)
All work items done one after another: sum of all wall-time estimates.

### Parallel (Best Case)
Maximum parallelism: critical path only (longest chain of dependent items).

### Realistic
Account for:
- Parallelism limited by dependencies
- Context switching overhead (10% per concurrent stream)
- Review/approval gates (add delay per gate)
- User feedback loops (estimate turnaround time)

### Dependency Graph

Build a dependency graph and identify the critical path:

```
DEPENDENCY GRAPH
━━━━━━━━━━━━━━━

WI-001: Setup/scaffolding ────┬── WI-003: Auth endpoints
                              ├── WI-004: Data models
                              └── WI-005: API scaffolding
WI-003: Auth endpoints ───────┬── WI-006: Protected routes
WI-004: Data models ──────────┤
WI-005: API scaffolding ──────┘
WI-006: Protected routes ─────── WI-008: E2E tests
WI-007: Frontend components ──── WI-008: E2E tests
WI-008: E2E tests ────────────── WI-009: Deployment

CRITICAL PATH: WI-001 → WI-003 → WI-006 → WI-008 → WI-009
Critical path duration: {X} hours
```

### Timeline Summary

```
TIMELINE PROJECTION
━━━━━━━━━━━━━━━━━━

Sequential:  {X} hours ({Y} days)
Parallel:    {X} hours ({Y} days)
Realistic:   {X} hours ({Y} days)

Critical path: {list of WIs on critical path}
Bottleneck: {the WI or dependency that constrains the most}

Parallelism efficiency: {parallel_time / sequential_time}%
```

## Step 5: Confidence Assessment

Rate overall estimation confidence:

| Confidence | When | What It Means |
|---|---|---|
| **High (±15%)** | Familiar domain, proven patterns, clear requirements | Estimates are reliable |
| **Medium (±30%)** | Some unknowns, most patterns known | Expect some variance |
| **Low (±50%)** | Significant unknowns, new tech, unclear requirements | Treat as order-of-magnitude |
| **Very Low (±100%)** | Research-heavy, bleeding edge, vague requirements | More discovery needed |

Be honest about confidence. A low-confidence estimate with clear reasoning is more valuable than a false-precision high number.

## Output: estimate.json

Save to `state/estimate.json`:

```json
{
  "phase": "estimate",
  "status": "DONE",
  "timestamp": "2026-03-20T13:00:00Z",
  "work_items": [
    {
      "id": "WI-001",
      "title": "Project scaffolding",
      "requirement_ids": ["REQ-001"],
      "component": "Setup",
      "type": "scaffold",
      "model": "sonnet",
      "complexity": "simple",
      "risk": "low",
      "tokens": {
        "context": 5000,
        "reasoning": 3000,
        "output": 8000,
        "tool_calls": 15,
        "total_per_iteration": 23500,
        "iterations": 1,
        "total": 23500
      },
      "cost_usd": 0.42,
      "wall_time_minutes": 4,
      "dependencies": [],
      "parallelizable": true
    }
  ],
  "cost": {
    "by_model": {
      "haiku": {"items": 5, "tokens": 250000, "cost_usd": 1.20},
      "sonnet": {"items": 12, "tokens": 1800000, "cost_usd": 32.40},
      "opus": {"items": 2, "tokens": 600000, "cost_usd": 54.00}
    },
    "subtotal_usd": 87.60,
    "buffer_percent": 20,
    "buffer_usd": 17.52,
    "total_usd": 105.12
  },
  "timeline": {
    "sequential_hours": 24,
    "parallel_hours": 8,
    "realistic_hours": 14,
    "critical_path": ["WI-001", "WI-003", "WI-006", "WI-008", "WI-009"],
    "bottleneck": "WI-003 (Auth endpoints)"
  },
  "confidence": "medium",
  "confidence_reasoning": "Most patterns are well-understood but the payment integration has unknowns",
  "total_tokens": 2650000,
  "total_tool_calls": 350
}
```

## Phase Completion

```
ESTIMATION COMPLETE — {project_name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Work Items: {count}
  Haiku: {count} | Sonnet: {count} | Opus: {count}

Cost: ${total} (${subtotal} + ${buffer} buffer)
Tokens: {total}M total

Timeline:
  Sequential: {X} hours
  Parallel:   {X} hours
  Realistic:  {X} hours ({Y} days)

Confidence: {level} (±{percent}%)
Critical path: {count} items, {X} hours

Status: {DONE | DONE_WITH_CONCERNS}

Ready to proceed to Phase 4 (Plan)?
```
