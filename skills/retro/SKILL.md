---
name: project-retro
description: "Phase 6 of Project Builder. Retrospective and estimation calibration. Compares actual vs estimated performance across tokens, cost, time, iterations, and provider/model fit. Calibration quality is gated by telemetry quality from execution."
---

# Phase 6: Retrospective & Calibration

Learn from what happened. This phase compares estimates against actuals, identifies patterns, and produces calibration data.

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

## Provider and Model Analysis

Compare not only complexity and work type, but also:
- provider choice
- model tier choice
- resolved model choice
- pricing source quality

Calibration should remain provider-aware. Do not emit global corrections that assume one vendor forever.

## Output Files

### retro-report.json
Include telemetry quality and provider context.

### estimation-calibration.json
This file should be keyed by provider and optionally by model tier. Example:

```json
{
  "providers": {
    "openai": {
      "tiers": {
        "balanced": {"token_mult": 1.2, "time_mult": 1.1}
      }
    }
  }
}
```
