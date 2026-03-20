---
name: project-estimate
description: "Phase 3 of Project Builder. Provider-aware estimation that goes beyond story points. Estimates token consumption, provider/model tier selection, tool call overhead, iteration budget, and parallelizability for each work item. Produces cost projections, timeline projections, and dependency graphs with critical path analysis."
---

# Phase 3: Provider-Aware Estimation

Traditional estimation asks "how many dev hours?" AI-native estimation asks "how many tokens, which provider/model tier, and what's the iteration budget?" This phase produces cost and timeline projections grounded in how AI agents actually work.

## Prerequisites

Read from the project workspace:
- `state/project-scope.json` — requirements and scope
- `state/architecture.json` — components, APIs, data model
- `state/project-meta.json` — provider context and execution mode

Also read `references/estimation-benchmarks.json` from the project-builder skill directory for reference data on token costs, provider tiers, and model capabilities.

If `retro/estimation-calibration.json` exists from a previous project, read it and apply the calibration factors.

Also read `references/calibration-history.jsonl` from the skill directory if it exists. This file contains cross-project calibration data appended by the Retro phase. Compute running averages across all projects for `work_type_multipliers` and `provider_multipliers`. Use these running averages as a baseline. If a project-specific `estimation-calibration.json` is also available, its values override the cross-project averages for any overlapping keys.

## Provider and Model Selection

Do not hard-code a single vendor. Resolve models in this order:
1. User override
2. `state/project-meta.json` provider context
3. `config/pipeline-config.json` defaults
4. Benchmarks file tier recommendation

Estimate by model tier first (`fast`, `balanced`, `deep`), then map the tier to a provider-specific model name.

If current provider pricing is unknown, either:
- ask the user for pricing guidance, or
- mark cost as `NEEDS_CONTEXT`, while still producing token and timeline estimates.

## Step 1: Work Item Decomposition

Break each in-scope requirement into atomic work items. A work item is the smallest unit of work that produces a testable output.

### Decomposition Rules

1. One work item = one testable deliverable
2. Work items map to requirements
3. Include hidden work: setup, testing, docs, CI/CD, deployment, monitoring
4. Separate research from implementation

### Work Item Template

```
WI-{NNN}: {Title}
  Requirement: {REQ-IDs}
  Component: {which architectural component}
  Type: scaffold | feature | api_endpoint | data_model | migration | test | config | docs | research | integration | deployment
  Description: {What needs to be done}
  Inputs: {What's needed to start}
  Output: {What gets produced}
  Dependencies: {WI-IDs that must complete first}
  Parallelizable: {yes | no | partial}
```

## Step 2: Per-Item Estimation

For each work item, estimate these dimensions:
- context tokens
- reasoning tokens
- output tokens
- tool call count
- iteration budget
- provider
- model tier
- resolved model name
- wall time

### Complexity Assessment

| Complexity | Description | Token Multiplier | Iteration Budget |
|---|---|---|---|
| Trivial | Copy-paste with adaptation, config changes | 1x | 1 iteration |
| Simple | Standard patterns, well-understood | 1.5x | 1-2 iterations |
| Medium | Some design decisions, moderate logic | 2x | 2-3 iterations |
| Complex | Novel approach needed, multiple components | 3x | 3-5 iterations |
| Research | Unknown territory, exploration required | 5x | 5-10 iterations |

### Risk Factor

| Risk Level | Multiplier | When |
|---|---|---|
| Low | 1.0 | Well-understood domain, proven patterns |
| Medium | 1.3 | Some unknowns, standard but unfamiliar tech |
| High | 1.8 | New tech, external dependencies, unclear requirements |
| Very High | 2.5 | Bleeding edge, regulatory, real-time constraints |

## Step 3: Cost Model

Calculate total cost from token estimates using provider-aware pricing. Cost output must always include:
- provider used
- model or tier used
- pricing source (`runtime`, `config override`, `benchmark example`, `user supplied`)
- whether the estimate is exact or provisional

If pricing is provisional, say so clearly.

## Step 4: Timeline Projection

Calculate three timeline scenarios:
- Sequential
- Parallel
- Realistic

Use `execution.mode` when projecting review-gate overhead. `manual` adds the highest coordination delay, `auto` the lowest.

## Step 5: Confidence Assessment

Be honest about confidence. If provider pricing is provisional, cost confidence cannot exceed `medium`.

## Output: estimate.json

Save to `state/estimate.json` and include provider fields:

```json
{
  "phase": "estimate",
  "status": "DONE",
  "provider_context": {
    "provider": "openai",
    "pricing_source": "runtime",
    "model_aliases": {
      "fast": "gpt-5.4-mini",
      "balanced": "gpt-5.4",
      "deep": "gpt-5.4"
    }
  }
}
```

If cost cannot be resolved reliably, return `DONE_WITH_CONCERNS` or `NEEDS_CONTEXT` instead of inventing precision.
