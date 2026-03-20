# Project Charter Template

Generate the charter following this structure. Replace all `{placeholders}` with actual project data from discovery, scope, architecture, and estimation phases.

---

# {Project Name} — Project Charter

## Executive Summary

{2-3 sentences: What is this project, what problem does it solve, and why does it matter?}

## Problem Statement

{Clear description of the problem being solved. Include who has this problem and how painful it is. Reference discovery-report.json for details.}

## Objectives

1. {Measurable objective 1 — include success metric}
2. {Measurable objective 2}
3. {Measurable objective 3}

## Scope

### In Scope (v1)
{List from project-scope.json scope_boundary.in_scope}

### Deferred (Future Versions)
{List from project-scope.json scope_boundary.deferred with target version}

### Out of Scope
{List from project-scope.json scope_boundary.out_of_scope with reasoning}

## Stakeholders

| Role | Responsibility | Decision Authority |
|---|---|---|
| {Project Owner} | {Overall direction and priorities} | {Final scope decisions} |
| {Tech Lead} | {Architecture and technical decisions} | {Tech stack, patterns} |
| {Users} | {Feedback and acceptance} | {Feature prioritization input} |

## Architecture Summary

**Style:** {architecture_style from architecture.json}
**Key Components:** {list main components}
**Tech Stack:** {languages, frameworks, infrastructure}

{Include or reference the component diagram}

## Timeline & Cost

| Scenario | Duration | Cost |
|---|---|---|
| Sequential (worst case) | {from estimate.json} | {from estimate.json} |
| Parallel (best case) | {from estimate.json} | {from estimate.json} |
| Realistic | {from estimate.json} | {from estimate.json} |

**Confidence Level:** {from estimate.json — High/Medium/Low with percentage range}

## Key Risks

| # | Risk | Probability | Impact | Mitigation |
|---|---|---|---|---|
| 1 | {Top risk} | {H/M/L} | {H/M/L} | {mitigation} |
| 2 | {Second risk} | {H/M/L} | {H/M/L} | {mitigation} |
| 3 | {Third risk} | {H/M/L} | {H/M/L} | {mitigation} |

(See Risk Register for complete list)

## Success Criteria

The project is successful when:
1. {Criterion 1 — specific and measurable}
2. {Criterion 2}
3. {Criterion 3}

## Assumptions

{List from scope phase — things taken as true without verification}

## Constraints

{Timeline, budget, technology, compliance, team constraints from scope phase}

## Approval

| Role | Name | Date |
|---|---|---|
| {Approver role} | {Name} | {Date} |
