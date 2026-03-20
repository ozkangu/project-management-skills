---
name: project-plan
description: "Phase 4 of Project Builder. Generates all project documentation from discovery, scope, architecture, and estimation outputs. Produces: Project Charter, Technical Architecture Document, Work Breakdown Structure, PBIs with User Stories and Given/When/Then Acceptance Criteria, automated test cases, Risk Register, Release Plan, and Cost Report. All documents are cross-referenced with full traceability (REQ → PBI → AC → TC → WI)."
---

# Phase 4: Project Plan & Documentation

Generate the full suite of project documents. This phase reads all previous phase outputs and produces professional, cross-referenced documentation.

## Prerequisites

Read from the project workspace:
- `state/discovery-report.json` (Phase 0)
- `state/project-scope.json` (Phase 1)
- `state/architecture.json` (Phase 2)
- `state/estimate.json` (Phase 3)

All four should exist. If any are missing, the corresponding sections will be thinner but the phase can still run with whatever is available.

Also read these reference templates from the project-builder skill directory:
- `references/doc-templates/project-charter.md`
- `references/doc-templates/architecture-doc.md`
- `references/doc-templates/wbs.md`
- `references/doc-templates/risk-register.md`
- `references/pbi-template.md`
- `references/test-case-template.md`

## Document Generation Sequence

Generate documents in this order (each builds on the previous):

### 1. Project Charter → `docs/project-charter.md`

The charter is the single-page summary that anyone should be able to read and understand the project. Follow the template in `references/doc-templates/project-charter.md`. Key sections:

- **Project Name & Slug**
- **Problem Statement** — from discovery
- **Objectives** — measurable outcomes
- **Scope Summary** — in/out/deferred from scope phase
- **Key Stakeholders** — roles and decision authority
- **Architecture Summary** — style, components, key tech choices
- **Cost & Timeline** — from estimation (the three scenarios)
- **Key Risks** — top 5 risks with mitigations
- **Success Criteria** — how to know the project succeeded
- **Approval** — who needs to sign off

### 2. Technical Architecture Document → `docs/architecture-doc.md`

The detailed technical blueprint. Follow `references/doc-templates/architecture-doc.md`. Key sections:

- **Architecture Overview** — style, rationale, component diagram
- **Component Specifications** — each component in detail
- **API Contracts** — all endpoints with request/response schemas
- **Data Model** — entities, relationships, ER diagram
- **Critical Flows** — sequence diagrams for key workflows
- **Infrastructure** — deployment architecture, environments
- **Security Architecture** — auth model, data protection, threat model overview
- **Failure Modes & Mitigations** — from architecture phase
- **Technology Decisions** — key choices with rationale (ADR-style)
- **Open Questions** — decisions still pending

Embed Mermaid diagrams from `diagrams/` directory.

### 3. Work Breakdown Structure → `docs/wbs.md`

The complete work tree. Follow `references/doc-templates/wbs.md`. Structure:

```
1. {Project Name}
  1.1 Setup & Infrastructure
    1.1.1 WI-001: Project scaffolding [Sonnet, 4min, $0.42]
    1.1.2 WI-002: CI/CD pipeline [Sonnet, 6min, $0.85]
  1.2 Core Features
    1.2.1 Authentication
      1.2.1.1 WI-003: Auth endpoints [Sonnet, 8min, $1.20]
      1.2.1.2 WI-004: Session management [Sonnet, 5min, $0.70]
    1.2.2 Primary Workflow
      ...
  1.3 Testing & Quality
    1.3.1 WI-015: Unit test suite [Haiku, 10min, $0.35]
    1.3.2 WI-016: E2E tests [Sonnet, 12min, $2.10]
  1.4 Documentation & Deployment
    ...
```

Include: work item ID, title, model assignment, estimated time, estimated cost, dependencies.

### 4. PBIs (Product Backlog Items) → `docs/pbis/`

Generate one file per PBI in `docs/pbis/PBI-{NNN}.md`. Each PBI follows the template in `references/pbi-template.md`.

#### PBI Structure

```markdown
# PBI-{NNN}: {Title}

## User Story
As a **{specific role}**,
I want **{goal/action}**,
So that **{measurable benefit}**.

## Acceptance Criteria

**AC-{PBI}-001: {Descriptive title}**
Given {precondition}
When {action/trigger}
Then {expected result}
Source: REQ-{NNN}

**AC-{PBI}-002: {Title — NEGATIVE SCENARIO}**
Given {invalid/error condition}
When {action}
Then {error behavior}
And {system state unchanged}
Source: REQ-{NNN}

## Business Rules Applied
- BR-{NNN}: {description}

## Work Items
- WI-{NNN}: {title} [{model}, {time}, ${cost}]

## Dependencies
- {PBI-IDs or external dependencies}

## Definition of Done
- [ ] Code written and reviewed
- [ ] Unit tests passing (≥80% coverage)
- [ ] Integration tests passing
- [ ] ACs verified
- [ ] Documentation updated
- [ ] No P1/P2 bugs

## Traceability
| REQ-ID | AC-IDs | WI-IDs | Coverage |
|--------|--------|--------|----------|
| REQ-{NNN} | AC-{PBI}-001, AC-{PBI}-002 | WI-{NNN} | Full |
```

#### PBI Writing Rules

1. **Roles must be specific** — not "user" but "project manager", "API consumer", "admin"
2. **Benefits must be measurable** — not "it works" but "reduce manual data entry by 80%"
3. **Every PBI has at least one negative AC** — what happens when things go wrong
4. **Every AC must be testable** — if you can't write a test for it, rewrite the AC
5. **Given/When/Then format is mandatory** — no exceptions
6. **One AC = one behavior** — don't combine multiple behaviors
7. **Boundary ACs for numeric/date fields** — min, max, min-1, max+1
8. **Each AC traces to a REQ-ID** — orphan ACs are not allowed

#### Coverage Check

After generating all PBIs, verify:

```
REQUIREMENT COVERAGE
━━━━━━━━━━━━━━━━━━━

REQ-001: ✅ Covered by PBI-001 (AC-001-001, AC-001-002, AC-001-003)
REQ-002: ✅ Covered by PBI-002, PBI-003
REQ-003: ⚠️ Partially covered — missing error handling ACs
REQ-004: ✅ Covered by PBI-004

Coverage: {covered}/{total} requirements ({percentage}%)
```

Do not proceed until coverage is 100% for in-scope P1 requirements.

### 5. Test Cases → `docs/test-cases/`

Generate test cases from ACs. Follow `references/test-case-template.md`.

For each AC, generate:
1. **Positive test** — AC's Given/When/Then becomes the test
2. **Negative test** — Precondition violated
3. **Boundary test** — Edge values for numeric/date fields
4. **Data variation** — Same flow, different data

#### Test Case Format

```markdown
## TC-{PBI}-{NNN}: {Title}

- **PBI:** PBI-{NNN}
- **REQ:** REQ-{NNN}
- **AC:** AC-{PBI}-{NNN}
- **Category:** Positive | Negative | Boundary | DataVariation
- **Priority:** P1 (release blocker) | P2 (should fix) | P3 (nice to have)

**Preconditions:**
{What must be true before the test}

**Steps:**
1. {Step 1}
2. {Step 2}
3. {Step 3}

**Test Data:**
{Specific values to use}

**Expected Result:**
{What should happen}
```

Group test cases by PBI. Save as `docs/test-cases/TC-PBI-{NNN}.md`.

#### Test Summary

```
TEST GENERATION SUMMARY
━━━━━━━━━━━━━━━━━━━━━━

Total PBIs: {N} | Total ACs: {N} | Total Test Cases: {N}

By category: Positive {N}, Negative {N}, Boundary {N}, DataVariation {N}
By priority: P1 {N}, P2 {N}, P3 {N}
AC coverage: {N}/{N} ACs have tests ({percentage}%)
```

### 6. Risk Register → `docs/risk-register.md`

Compile all risks from all phases. Follow `references/doc-templates/risk-register.md`.

| Risk ID | Description | Probability | Impact | Score | Mitigation | Owner | Status |
|---|---|---|---|---|---|---|---|
| RISK-001 | {desc} | High/Med/Low | High/Med/Low | {P×I} | {action} | {role} | Open |

Score: High×High=9, High×Med=6, Med×Med=4, etc.

Sort by score descending. Top 5 risks get detailed mitigation plans.

### 7. Release Plan → `docs/release-plan.md`

Organize work items into releases/sprints:

```markdown
# Release Plan

## Release 1 (MVP) — {estimated date}
### Sprint 1: Foundation ({X} hours, ${Y})
- WI-001: Project scaffolding
- WI-002: CI/CD pipeline
- WI-003: Database setup

### Sprint 2: Core Features ({X} hours, ${Y})
- WI-004: Auth endpoints
- WI-005: Core CRUD
- WI-006: Protected routes

## Release 2 — {estimated date}
...
```

Group by dependency order. Each sprint should be deliverable (something testable at the end).

### 8. Cost Report → `docs/cost-report.md`

Summary of all financial projections:

- Total estimated cost by model
- Cost per sprint/release
- Cost per feature area
- Buffer analysis
- Comparison: sequential vs parallel vs realistic cost (different timeline = different overhead)

## Traceability Matrix

The final check — ensure every chain is complete:

```
TRACEABILITY MATRIX
━━━━━━━━━━━━━━━━━━

REQ-001 → PBI-001 → AC-001-001 → TC-001-001 → WI-003 ✅
REQ-001 → PBI-001 → AC-001-002 → TC-001-002 → WI-003 ✅
REQ-002 → PBI-002 → AC-002-001 → TC-002-001 → WI-005 ✅
...

Chains: {total} | Complete: {count} | Broken: {count}
```

Any broken chain means something was missed. Fix it before completing the phase.

## Output

All documents saved to `docs/` directory. Update `state/project-meta.json` with `phases_completed` including "plan".

## Phase Completion

```
PLAN COMPLETE — {project_name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Documents Generated:
  ✅ Project Charter
  ✅ Architecture Document
  ✅ Work Breakdown Structure
  ✅ PBIs: {count}
  ✅ Test Cases: {count}
  ✅ Risk Register: {count} risks
  ✅ Release Plan: {sprint_count} sprints
  ✅ Cost Report

Traceability: {complete_chains}/{total_chains} chains complete

Status: {DONE | DONE_WITH_CONCERNS}

Ready to proceed to Phase 5 (Execute)?
```
