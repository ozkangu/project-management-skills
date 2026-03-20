---
name: project-retro
description: "Phase 6 of Project Builder. Retrospective and estimation calibration. Compares actual vs estimated performance across all dimensions: tokens, cost, time, iterations, model accuracy. Generates calibration data that improves future estimates. Captures lessons learned systematically."
---

# Phase 6: Retrospective & Calibration

Learn from what happened. This phase compares estimates against actuals, identifies patterns, and produces calibration data that makes future estimates more accurate.

## Prerequisites

Read from the project workspace:
- `state/estimate.json` — original estimates
- `state/execution-log.json` — actual execution data
- `state/project-scope.json` — what was planned
- `state/architecture.json` — technical decisions made

## Step 1: Actual vs Estimated Comparison

### Per Work Item Analysis

For each work item, calculate deviation:

```
WORK ITEM COMPARISON
━━━━━━━━━━━━━━━━━━━

WI-001: Project scaffolding
  Tokens:  23,500 estimated → 28,000 actual (+19%)
  Time:    4 min estimated  → 5 min actual (+25%)
  Cost:    $0.42 estimated  → $0.50 actual (+19%)
  Model:   Sonnet (correct)
  Iters:   1 estimated → 1 actual (match)
  Verdict: WITHIN RANGE ✅

WI-003: Auth endpoints
  Tokens:  142,500 estimated → 210,000 actual (+47%)
  Time:    8 min estimated   → 14 min actual (+75%)
  Cost:    $1.20 estimated   → $2.85 actual (+137%)
  Model:   Sonnet (should have been Opus for the token validation logic)
  Iters:   3 estimated → 5 actual (+67%)
  Verdict: SIGNIFICANT DEVIATION ⚠️
  Root cause: Token validation edge cases required more iterations than anticipated
```

### Aggregate Comparison

```
AGGREGATE COMPARISON
━━━━━━━━━━━━━━━━━━━

                    Estimated    Actual      Variance
Tokens:             2,650,000    3,180,000   +20%
Cost:               $105.12      $134.50     +28%
Time (realistic):   14 hours     17.5 hours  +25%
Work items:         19           19          0%
Sprints:            3            3           0%

Items within 20% of estimate:    12/19 (63%)
Items significantly over:         5/19 (26%)
Items significantly under:        2/19 (11%)
```

## Step 2: Pattern Analysis

Look for systematic patterns in the deviations:

### By Complexity

Did certain complexity levels consistently over- or under-estimate?

```
ACCURACY BY COMPLEXITY
━━━━━━━━━━━━━━━━━━━━━

Trivial:  avg +5% (accurate)
Simple:   avg +12% (slightly optimistic)
Medium:   avg +35% (consistently under-estimated)
Complex:  avg +48% (significantly under-estimated)
Research: avg +15% (buffer was right, base was wrong)
```

### By Type

Were certain work types harder to estimate?

```
ACCURACY BY WORK TYPE
━━━━━━━━━━━━━━━━━━━━

scaffold:       avg +8%   (good estimates)
feature:        avg +25%  (moderate underestimate)
api_endpoint:   avg +15%  (reasonable)
data_model:     avg +5%   (well-understood)
test:           avg +40%  (consistently underestimated)
integration:    avg +55%  (worst category)
config:         avg -10%  (slightly overestimated)
```

### By Model Assignment

Were model assignments correct?

```
MODEL ASSIGNMENT ACCURACY
━━━━━━━━━━━━━━━━━━━━━━━━

Correct model: 15/19 (79%)
Should have used a more capable model: 3/19
Should have used a simpler model: 1/19

Specific corrections:
  WI-003: Sonnet → Opus (complex token validation logic)
  WI-007: Sonnet → Opus (subtle concurrency bugs)
  WI-012: Sonnet → Opus (security review needed deeper analysis)
  WI-015: Sonnet → Haiku (simple boilerplate tests)
```

### Iteration Budget Accuracy

```
ITERATION ACCURACY
━━━━━━━━━━━━━━━━━━

Items needing more iterations than budgeted: 6/19
Items needing fewer: 3/19
Items matching: 10/19

Common reasons for extra iterations:
  • Test failures revealing edge cases (4 items)
  • API contract changes mid-implementation (1 item)
  • Unclear requirements discovered during build (1 item)
```

## Step 3: Estimation Calibration

Produce calibration factors that can improve future estimates.

### Calibration Factors

```json
{
  "calibration_version": 1,
  "project_slug": "my-project",
  "generated_at": "2026-03-20T18:00:00Z",
  "sample_size": 19,
  "confidence": "medium",
  "global_factors": {
    "token_multiplier": 1.20,
    "cost_multiplier": 1.28,
    "time_multiplier": 1.25,
    "iteration_multiplier": 1.15
  },
  "complexity_factors": {
    "trivial": {"token_mult": 1.05, "iter_mult": 1.0},
    "simple": {"token_mult": 1.12, "iter_mult": 1.1},
    "medium": {"token_mult": 1.35, "iter_mult": 1.3},
    "complex": {"token_mult": 1.48, "iter_mult": 1.5},
    "research": {"token_mult": 1.15, "iter_mult": 1.2}
  },
  "type_factors": {
    "scaffold": 1.08,
    "feature": 1.25,
    "api_endpoint": 1.15,
    "data_model": 1.05,
    "test": 1.40,
    "integration": 1.55,
    "config": 0.90
  },
  "model_corrections": [
    {"pattern": "token_validation", "current": "sonnet", "recommended": "opus"},
    {"pattern": "concurrency_logic", "current": "sonnet", "recommended": "opus"},
    {"pattern": "security_review", "current": "sonnet", "recommended": "opus"},
    {"pattern": "boilerplate_tests", "current": "sonnet", "recommended": "haiku"}
  ]
}
```

These calibration factors should be saved and referenced in future estimation phases. Over multiple projects, they become increasingly accurate.

## Step 4: Lessons Learned

Capture structured lessons:

### What Went Well
- {Things that worked better than expected}
- {Processes that saved time}
- {Good decisions that paid off}

### What Didn't Go Well
- {Things that took longer than expected and why}
- {Decisions that needed revision}
- {Blockers and their root causes}

### What to Do Differently
- {Concrete, actionable changes for next time}
- {Process improvements}
- {Estimation adjustments}

### Surprises
- {Things nobody anticipated}
- {Risks that materialized (or didn't)}
- {Scope changes during execution}

## Step 5: Critical Path Analysis

Was the critical path prediction accurate?

```
CRITICAL PATH ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━

Predicted critical path: WI-001 → WI-003 → WI-006 → WI-008 → WI-009
Actual critical path:    WI-001 → WI-003 → WI-007 → WI-008 → WI-009
                                                    ↑
                                          WI-007 took longer than expected,
                                          became the bottleneck instead of WI-006

Predicted critical path duration: 8 hours
Actual critical path duration: 10.5 hours (+31%)

Parallelism efficiency:
  Predicted: 33% (8h parallel / 24h sequential)
  Actual: 38% (10.5h / 27.5h)
  Verdict: Slightly less parallel than expected
```

## Output Files

### retro-report.json → `retro/retro-report.json`

```json
{
  "phase": "retro",
  "status": "DONE",
  "timestamp": "2026-03-20T18:00:00Z",
  "comparison": {
    "tokens": {"estimated": 2650000, "actual": 3180000, "variance_pct": 20},
    "cost": {"estimated": 105.12, "actual": 134.50, "variance_pct": 28},
    "time_hours": {"estimated": 14, "actual": 17.5, "variance_pct": 25},
    "work_items": {"total": 19, "within_20pct": 12, "over_20pct": 5, "under_20pct": 2}
  },
  "patterns": {
    "by_complexity": {},
    "by_type": {},
    "by_model": {},
    "iteration_accuracy": {}
  },
  "lessons": {
    "went_well": [],
    "didnt_go_well": [],
    "do_differently": [],
    "surprises": []
  },
  "critical_path": {
    "predicted": [],
    "actual": [],
    "duration_predicted_hours": 8,
    "duration_actual_hours": 10.5
  }
}
```

### estimation-calibration.json → `retro/estimation-calibration.json`

The calibration factors (see Step 3 above). This file is designed to be read by future Phase 3 runs to improve accuracy over time.

## Phase Completion

```
RETROSPECTIVE COMPLETE — {project_name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Estimation Accuracy:
  Token estimate: {variance}% off
  Cost estimate:  {variance}% off
  Time estimate:  {variance}% off
  Within 20%:     {count}/{total} items

Top Lessons:
  1. {most important lesson}
  2. {second lesson}
  3. {third lesson}

Calibration data saved for future projects.

Status: DONE

Project Builder pipeline complete! 🎯
```
