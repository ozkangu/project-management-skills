---
name: project-retro
description: "Phase 6 of Project Builder. Retrospective and estimation calibration. Compares actual vs estimated performance across tokens, cost, time, iterations, and provider/model fit. Calibration quality is gated by telemetry quality from execution."
---

# Phase 6: Retrospective & Calibration

Learn from what happened. This phase compares estimates against actuals, identifies patterns, and produces calibration data that improves future estimates.

## Prerequisites

Read from the project workspace:
- `state/estimate.json`
- `state/execution-log.json`
- `state/project-scope.json`
- `state/architecture.json`

## Telemetry Quality Gate

Before calculating calibration factors, inspect execution telemetry quality:
- `exact`: safe to generate provider/model calibration and cost multipliers
- `estimated`: generate calibration with `DONE_WITH_CONCERNS`
- `missing`: skip quantitative calibration and produce qualitative retro only

Never present precise calibration factors from missing telemetry.

## Comparison Methodology

Follow these steps in order:

### Step 1: Load Data

Read `state/estimate.json` and `state/execution-log.json`. Match work items by `wi_id`.

### Step 2: Per-Work-Item Comparison

For each work item, compare estimated vs actual across these dimensions:
- `input_tokens` + `output_tokens` (total tokens)
- `tool_calls`
- `iteration_count`
- `wall_time_minutes`
- `estimated_cost_usd`

Record both the estimated and actual value for each dimension.

### Step 3: Deviation Calculation

For each dimension on each work item, calculate percentage deviation:

```
deviation_pct = (actual - estimated) / estimated * 100
```

Positive values mean underestimation. Negative values mean overestimation.

### Step 4: Work-Type Aggregation

Group work items by their `type` field (scaffold, feature, api_endpoint, data_model, etc.). For each type, compute:
- Average token deviation percentage
- Average time deviation percentage
- Average iteration deviation percentage
- Tendency: `under_estimates` | `over_estimates` | `accurate` (based on whether avg deviation exceeds the configured `deviation_threshold_pct`)

### Step 5: Provider and Tier Analysis

Group work items by `provider` and `model_tier`. For each provider/tier combination:
- Token accuracy: average absolute deviation in token estimates
- Cost accuracy: average absolute deviation in cost estimates
- Time accuracy: average absolute deviation in wall time estimates

Compare not only complexity and work type, but also provider choice, model tier choice, resolved model choice, and pricing source quality.

Calibration should remain provider-aware. Do not emit global corrections that assume one vendor forever.

### Step 6: Risk Accuracy Check

Evaluate whether risk predictions correlated with actual deviations:
- Identify items estimated as HIGH or VERY_HIGH risk
- Check whether those items actually had larger deviations than LOW/MEDIUM risk items
- Record false positives (predicted high risk, performed on target) and false negatives (predicted low risk, deviated significantly)

## Output Files

### retro-report.json

Save to `retro/retro-report.json` with this schema:

```json
{
  "phase": "retro",
  "status": "DONE",
  "timestamp": "ISO-8601",
  "telemetry_quality": "exact | estimated | missing",
  "summary": {
    "total_wi": 0,
    "on_target": 0,
    "over": 0,
    "under": 0,
    "biggest_miss": {
      "wi_id": "WI-001",
      "dimension": "tokens",
      "deviation_pct": 0
    }
  },
  "per_item_comparison": [
    {
      "wi_id": "WI-001",
      "title": "",
      "type": "feature",
      "estimated": {
        "tokens": 0, "tool_calls": 0, "iterations": 0,
        "wall_time_minutes": 0, "cost_usd": 0
      },
      "actual": {
        "tokens": 0, "tool_calls": 0, "iterations": 0,
        "wall_time_minutes": 0, "cost_usd": 0
      },
      "deviation_pct": {
        "tokens": 0, "tool_calls": 0, "iterations": 0,
        "wall_time_minutes": 0, "cost_usd": 0
      }
    }
  ],
  "work_type_patterns": {
    "feature": {
      "count": 0,
      "avg_token_deviation": 0,
      "avg_time_deviation": 0,
      "tendency": "under_estimates | over_estimates | accurate"
    }
  },
  "provider_analysis": {
    "openai": {
      "balanced": {
        "token_accuracy": 0,
        "cost_accuracy": 0,
        "time_accuracy": 0
      }
    }
  },
  "risk_accuracy": {
    "predicted_high_items": 0,
    "actual_high_items": 0,
    "false_positives": 0,
    "false_negatives": 0
  },
  "lessons": {
    "went_well": [],
    "didnt_go_well": [],
    "do_differently": [],
    "surprises": []
  },
  "calibration_recommendations": []
}
```

### estimation-calibration.json

Save to `retro/estimation-calibration.json`. This file is keyed by provider, work type, and risk level:

```json
{
  "project_id": "",
  "timestamp": "ISO-8601",
  "telemetry_quality": "exact | estimated",
  "providers": {
    "openai": {
      "balanced": {
        "token_mult": 1.2,
        "time_mult": 1.1,
        "cost_mult": 1.15
      }
    }
  },
  "work_types": {
    "feature": {
      "token_mult": 1.3,
      "iteration_mult": 1.1,
      "sample_count": 5
    }
  },
  "risk_calibration": {
    "low": { "actual_deviation_avg": 8 },
    "medium": { "actual_deviation_avg": 18 },
    "high": { "actual_deviation_avg": 45 },
    "very_high": { "actual_deviation_avg": 72 }
  }
}
```

## Cross-Project Calibration

After generating project-level calibration, append a summary line to `references/calibration-history.jsonl` in the skill directory. This builds a cross-project calibration history that the Estimate phase can use as a baseline for future projects.

### JSONL Line Format

Each line is a self-contained JSON object:

```json
{
  "project_id": "",
  "date": "ISO-8601",
  "telemetry_quality": "exact | estimated",
  "work_type_multipliers": {
    "feature": { "token_mult": 1.3, "iteration_mult": 1.1 }
  },
  "provider_multipliers": {
    "openai": {
      "balanced": { "token_mult": 1.2, "time_mult": 1.1 }
    }
  },
  "sample_sizes": {
    "total_wi": 0,
    "by_type": { "feature": 5 }
  }
}
```

Only append if `telemetry_quality` is `exact` or `estimated`. Do not write calibration from `missing` telemetry.
