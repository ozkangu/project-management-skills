---
name: project-scope
description: "Phase 1 of Project Builder. Defines project scope through forcing questions, premise challenges, and requirements extraction. Implements four scope modes (Expansion, Selective, Hold, Reduction) to help teams make deliberate scope decisions. Detects ambiguities and produces structured requirements with traceability."
---

# Phase 1: Project Scope

Turn discovery findings into a clear, bounded scope with structured requirements. This is where ambiguity gets resolved and decisions get made.

## Prerequisites

Read `state/discovery-report.json` from the project workspace. If it doesn't exist, run Phase 0 first or ask the user to provide project context directly.

## Step 1: Forcing Questions

These questions force clarity on things teams avoid deciding early. Adapt them to the project type — not all apply to every project.

### Universal Forcing Questions

Ask 3-5 of the most relevant ones (don't dump all at once):

1. **"What does 'done' look like?"** — Define the finish line before starting. A specific, testable statement of what success means.

2. **"What are you willing to cut?"** — Everything has a cost. Identify the lowest-priority items now so they don't become surprises later.

3. **"What's the hardest part?"** — The thing the team is avoiding discussing is usually the riskiest. Name it and plan for it.

4. **"Who decides when we disagree?"** — Unclear decision authority kills projects. Establish the tiebreaker.

5. **"What's good enough?"** — Perfection is the enemy. Define acceptable quality for each deliverable.

6. **"What's the real deadline?"** — Is it a hard external date (conference, regulatory, contract) or an internal aspiration? The answer changes everything.

7. **"What can we reuse?"** — Existing code, libraries, services, or patterns that save time. Don't rebuild what exists.

8. **"What's the deployment story?"** — How does this get to users? If deployment is complex, it affects scope.

### Project-Type Specific Questions

**Web/Mobile Apps:**
- "Offline support needed?"
- "Which browsers/devices must work on day 1?"
- "Auth model — build or buy?"
- "Internationalization from the start or later?"

**APIs/Backends:**
- "Who are the consumers? Internal only or external?"
- "Rate limiting, quotas, or billing from day 1?"
- "Backwards compatibility requirements?"
- "Data migration needed?"

**Data Pipelines:**
- "Real-time or batch?"
- "Data volume expectations (daily/monthly)?"
- "Data quality guarantees?"
- "Recovery from failure — replay or skip?"

**ML/AI Systems:**
- "What's the baseline to beat?"
- "Training data — do you have it?"
- "Latency requirements for inference?"
- "How do you measure model quality?"

Process answers before asking more. Each answer may change which follow-up matters.

## Step 2: Scope Mode Selection

Help the user choose a deliberate scope strategy. Present these four options:

### EXPANSION Mode
**When:** The project has room to grow, timeline is flexible, the goal is comprehensive coverage.
- Add features and capabilities beyond the minimum
- Include nice-to-haves with clear priority ordering
- Plan for extensibility
- Risk: Scope creep if not managed. Mitigate with hard priority tiers.

### SELECTIVE Mode (Recommended Default)
**When:** Normal project with bounded resources. Ship the most impactful subset.
- Focus on the highest-value items
- Explicitly defer lower-priority items (not cut — deferred)
- Each item must justify its inclusion against the timeline
- Risk: Deferring too aggressively can miss systemic needs.

### HOLD Mode
**When:** Requirements are fixed (contractual, regulatory, migration). No scope negotiation.
- All stated requirements are in scope — period
- Focus shifts to prioritization and ordering, not inclusion/exclusion
- Risk: Hidden complexity in "fixed" requirements. Surface it early.

### REDUCTION Mode
**When:** Aggressive timeline, limited resources, or need to validate an idea fast.
- Strip to absolute minimum viable product
- Single core workflow, no edge cases in v1
- Explicit list of what's NOT included and why
- Risk: Cutting too deep can make the product useless. Validate the core still holds.

Ask the user to pick a mode (or suggest one based on their constraints). The mode shapes every subsequent decision.

## Step 3: Requirements Extraction

Structure all known requirements. For each requirement:

```
REQ-{NNN}: {Title}
  Description: {Clear, complete description}
  Type: functional | non_functional | constraint | assumption
  Priority: P1 (must have) | P2 (should have) | P3 (nice to have) | P4 (future)
  Source: discovery | user_interview | document | inferred
  Business Rules:
    BR-{NNN}: IF {condition} THEN {behavior}
  Affected Components: {list}
  Dependencies: {other REQ-IDs this depends on}
  ⚠️ Ambiguity: {any unclear points — ALWAYS flag these}
```

### Ambiguity Detection

This is the highest-value activity in scoping. For every requirement, actively look for:

1. **Vague quantifiers** — "fast", "scalable", "user-friendly", "secure". Ask: fast means what exactly?
2. **Implicit requirements** — Things obviously needed but not stated (auth, error handling, logging, monitoring)
3. **Boundary conditions** — What happens at limits? Max users, max data, max concurrent requests
4. **Error paths** — Only happy path described? What happens when things fail?
5. **Integration assumptions** — "Connects to X" but how? What's the contract? What if X is down?
6. **Data lifecycle** — Created but never deleted? What about updates? Archival?
7. **Permission model** — Who can do what? What if unauthorized?

Present ambiguities as questions, not criticisms:

```
⚠️ AMBIGUITIES DETECTED
━━━━━━━━━━━━━━━━━━━━━━

REQ-003: "The system should respond quickly"
  → What latency target? (suggest: p95 < 200ms for API, p95 < 3s for page load)

REQ-007: "Users can upload files"
  → Max file size? Allowed formats? Storage limit per user?

REQ-012: "Admin dashboard"
  → Who is an admin? How are they different from regular users? What actions are admin-only?

Need answers before proceeding — these affect architecture.
```

## Step 4: Scope Boundary

Create an explicit in/out boundary:

```
SCOPE BOUNDARY — {scope_mode} MODE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

IN SCOPE (v1):
  ✓ REQ-001: User authentication (email + password)
  ✓ REQ-002: Core CRUD operations
  ✓ REQ-003: API with rate limiting
  ✓ REQ-004: Basic monitoring

DEFERRED (v2+):
  ↦ REQ-005: OAuth integration
  ↦ REQ-006: Advanced analytics
  ↦ REQ-008: Mobile app

OUT OF SCOPE:
  ✗ REQ-007: ML recommendations — different project
  ✗ REQ-009: Multi-tenant — not needed for target users

ASSUMPTIONS:
  • Cloud hosting (AWS or GCP)
  • Single-region deployment initially
  • English-only v1
```

Get explicit user confirmation on the scope boundary before proceeding.

## Output: project-scope.json

Save to `state/project-scope.json`:

```json
{
  "phase": "scope",
  "status": "DONE",
  "timestamp": "2026-03-20T11:00:00Z",
  "scope_mode": "selective",
  "forcing_questions": {
    "asked": ["question 1", "question 2"],
    "answers": {"question 1": "answer", "question 2": "answer"}
  },
  "requirements": [
    {
      "id": "REQ-001",
      "title": "User Authentication",
      "description": "Email and password authentication with session management",
      "type": "functional",
      "priority": "P1",
      "source": "user_interview",
      "business_rules": [
        {"id": "BR-001", "rule": "IF login fails 5 times THEN lock account for 30 minutes"}
      ],
      "affected_components": ["AuthService", "UserDB"],
      "dependencies": [],
      "ambiguities_resolved": ["Password complexity requirements: min 8 chars, 1 uppercase, 1 number"],
      "ambiguities_open": []
    }
  ],
  "scope_boundary": {
    "in_scope": ["REQ-001", "REQ-002", "REQ-003"],
    "deferred": [{"id": "REQ-005", "reason": "v2 feature", "target": "v2"}],
    "out_of_scope": [{"id": "REQ-007", "reason": "Separate project"}],
    "assumptions": ["Cloud hosting", "Single region initially"]
  },
  "ambiguities": {
    "resolved": [{"question": "...", "answer": "...", "affected_reqs": ["REQ-001"]}],
    "open": [{"question": "...", "impact": "blocks architecture decisions", "affected_reqs": ["REQ-003"]}]
  },
  "requirement_count": {
    "total": 12,
    "p1": 4,
    "p2": 5,
    "p3": 3,
    "functional": 9,
    "non_functional": 3
  }
}
```

## Phase Completion

```
SCOPE COMPLETE — {project_name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mode: {scope_mode}
Requirements: {total} ({p1} P1, {p2} P2, {p3} P3)
In Scope: {count} | Deferred: {count} | Out: {count}
Ambiguities: {resolved_count} resolved, {open_count} remaining

Status: {DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED}
{If DONE_WITH_CONCERNS: list concerns}
{If NEEDS_CONTEXT: list what's needed}
{If BLOCKED: list blockers}

```

If status is DONE, advance to Phase 2 (Architecture). If NEEDS_CONTEXT or BLOCKED, resolve before advancing.
