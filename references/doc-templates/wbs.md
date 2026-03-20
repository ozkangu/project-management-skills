# Work Breakdown Structure Template

Generate the WBS from estimate.json work items. Organize hierarchically by project area, then component, then individual work items.

---

# {Project Name} — Work Breakdown Structure

## Summary

| Metric | Value |
|---|---|
| Total Work Items | {count} |
| Estimated Total Time | {realistic hours from estimate.json} |
| Estimated Total Cost | {total from estimate.json} |
| Model Mix | Haiku: {count}, Sonnet: {count}, Opus: {count} |
| Critical Path Length | {hours} |

## WBS Hierarchy

```
1. {Project Name}
│
├── 1.1 Setup & Infrastructure
│   ├── 1.1.1 WI-{NNN}: {title}
│   │   Model: {model} | Time: {min} | Cost: ${cost} | Deps: {deps or "none"}
│   ├── 1.1.2 WI-{NNN}: {title}
│   │   Model: {model} | Time: {min} | Cost: ${cost} | Deps: {deps}
│   └── Subtotal: {time}, ${cost}
│
├── 1.2 Core Features
│   ├── 1.2.1 {Feature Area 1}
│   │   ├── 1.2.1.1 WI-{NNN}: {title}
│   │   │   Model: {model} | Time: {min} | Cost: ${cost} | Deps: {deps}
│   │   ├── 1.2.1.2 WI-{NNN}: {title}
│   │   │   Model: {model} | Time: {min} | Cost: ${cost} | Deps: {deps}
│   │   └── Subtotal: {time}, ${cost}
│   │
│   ├── 1.2.2 {Feature Area 2}
│   │   └── ...
│   └── Subtotal: {time}, ${cost}
│
├── 1.3 Testing & Quality
│   ├── 1.3.1 WI-{NNN}: {title}
│   │   ...
│   └── Subtotal: {time}, ${cost}
│
├── 1.4 Documentation
│   └── ...
│
└── 1.5 Deployment & Launch
    └── ...
```

## Dependency Graph

```
{Visual representation of dependencies}
{Show critical path highlighted}
```

## Work Items by Priority

### P1 — Must Complete
{List P1 work items with time and cost}

### P2 — Should Complete
{List P2 work items}

### P3 — Nice to Complete
{List P3 work items}

## Work Items by Model

### Opus Tasks ({count}, ${cost})
{List — these are the complex/critical items}

### Sonnet Tasks ({count}, ${cost})
{List — standard implementation work}

### Haiku Tasks ({count}, ${cost})
{List — boilerplate and simple tasks}

## Notes

- Times are wall-clock estimates for AI agent execution
- Costs include buffer ({buffer_pct}%)
- Critical path items are marked with ★
- Dependencies must be respected — parallel execution only where marked
