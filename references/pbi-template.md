# PBI Template

Use this template for every Product Backlog Item. Each PBI must be independently deliverable, testable, and traceable to requirements.

## Template

```markdown
# PBI-{NNN}: {Title}

## User Story

As a **{specific role}**,
I want **{goal/action}**,
So that **{measurable benefit}**.

### Role Guidance
- Be specific: not "user" but "project manager", "API consumer", "billing admin"
- For internal/system stories, use Technical Story format:
  As the **{system/service}**,
  I need to **{technical capability}**,
  So that **{what this enables}**.

### Benefit Guidance
- Must be measurable or observable
- Bad: "so it works" / "for better UX"
- Good: "reducing manual data entry from 30 minutes to 2 minutes" / "enabling real-time price updates without page refresh"

## Acceptance Criteria

### AC-{PBI}-001: {Descriptive title — POSITIVE SCENARIO}
**Given** {precondition — specific, testable state}
**When** {action/trigger — one action per AC}
**Then** {expected result — observable, verifiable}
**Source:** REQ-{NNN}

### AC-{PBI}-002: {Title — NEGATIVE SCENARIO}
**Given** {invalid/error condition}
**When** {action}
**Then** {error behavior — specific error code/message}
**And** {system state unchanged — verify no side effects}
**Source:** REQ-{NNN}

### AC-{PBI}-003: {Title — BOUNDARY CONDITION}
**Given** {edge value for numeric/date/size field}
**When** {action at the boundary}
**Then** {correct behavior at the boundary}
**Source:** REQ-{NNN}

## AC Writing Rules

1. **Every AC must be testable** — if you can't write a test for it, rewrite it
2. **Given/When/Then format is mandatory** — no exceptions
3. **One AC = one behavior** — never combine multiple behaviors
4. **At least one negative AC per PBI** — what happens when things go wrong
5. **Boundary ACs for any numeric/date fields** — min, max, min-1, max+1
6. **Each AC traces to a REQ-ID** — orphan ACs not allowed

## AC Anti-Patterns (Avoid These)

| Bad AC | Good AC |
|---|---|
| "System handles errors" | "Given an invalid email format, When registration is submitted, Then error INVALID_EMAIL is returned with HTTP 400" |
| "Response is fast" | "Given a standard API request, When processed, Then response returns within 200ms (p95)" |
| "Data saves correctly" | "Given a completed form, When submitted, Then all fields match the submitted values when retrieved" |
| "Works on mobile" | "Given a viewport width of 375px, When the dashboard loads, Then all charts are readable and interactive" |

## Business Rules Applied
- BR-{NNN}: {description}
- BR-{NNN}: {description}

## Work Items
- WI-{NNN}: {title} [{model}, {estimated time}, ${estimated cost}]
- WI-{NNN}: {title} [{model}, {estimated time}, ${estimated cost}]

## Dependencies
- {PBI-IDs this PBI depends on}
- {External dependencies — APIs, services, decisions}

## Definition of Done
- [ ] Code written and reviewed
- [ ] Unit tests passing (≥80% coverage for new code)
- [ ] Integration tests passing (if applicable)
- [ ] All ACs verified
- [ ] Documentation updated (if user-facing changes)
- [ ] No P1/P2 open bugs
- [ ] Performance within stated thresholds

## Traceability
| REQ-ID | AC-IDs | WI-IDs | Test Case IDs | Coverage |
|--------|--------|--------|---------------|----------|
| REQ-{NNN} | AC-{PBI}-001, AC-{PBI}-002 | WI-{NNN} | TC-{PBI}-001, TC-{PBI}-002 | Full |
```

## Decomposition Rules

1. **Each PBI = one independently deliverable unit** — ideally completable in one sprint/iteration
2. **INVEST criteria:** Independent, Negotiable, Valuable, Estimable, Small, Testable
3. **Group by component boundary** — a PBI shouldn't span more than 2 components
4. **If a PBI spans 3+ components** → split it into smaller PBIs
5. **If a PBI has 8+ ACs** → likely too large, consider splitting
