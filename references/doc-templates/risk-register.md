# Risk Register Template

Compile risks from all phases into a single register. Score and prioritize systematically.

---

# {Project Name} — Risk Register

## Risk Scoring

| Probability | Impact: Low | Impact: Medium | Impact: High |
|---|---|---|---|
| **High** | 3 | 6 | 9 |
| **Medium** | 2 | 4 | 6 |
| **Low** | 1 | 2 | 3 |

**Action thresholds:**
- Score 6-9: Active mitigation required, monitor weekly
- Score 3-4: Mitigation plan in place, monitor bi-weekly
- Score 1-2: Accept and monitor monthly

## Risk Register

| ID | Description | Source Phase | Probability | Impact | Score | Mitigation Strategy | Contingency Plan | Owner | Status |
|---|---|---|---|---|---|---|---|---|---|
| RISK-001 | {description} | {discover/scope/architect/estimate} | H/M/L | H/M/L | {score} | {proactive action to reduce probability or impact} | {reactive plan if risk materializes} | {role} | Open/Mitigating/Closed |

## Top 5 Risks — Detailed Mitigation Plans

### RISK-{NNN}: {Title}

**Description:** {Full description of the risk}
**Probability:** {H/M/L} — {why this rating}
**Impact:** {H/M/L} — {what happens if it materializes}
**Score:** {score}

**Root Cause:** {What causes this risk}
**Early Warning Signs:** {How to detect it's materializing}

**Mitigation Plan:**
1. {Proactive step 1}
2. {Proactive step 2}
3. {Proactive step 3}

**Contingency Plan (if mitigation fails):**
1. {Reactive step 1}
2. {Reactive step 2}

**Owner:** {who is responsible}
**Review Date:** {when to reassess}

{Repeat for top 5 risks}

## Risk Categories

### Technical Risks
{Risks related to technology choices, complexity, unknown tech}

### Scope Risks
{Risks related to requirements, scope creep, unclear requirements}

### Resource Risks
{Risks related to team, tools, compute budget}

### External Risks
{Risks from dependencies, third-party services, compliance changes}

### Schedule Risks
{Risks to the timeline — critical path, parallelism assumptions}

## Risk Trends

Track how risks evolve across project phases:

| Risk ID | Discovery | Scope | Architecture | Estimation | Current |
|---|---|---|---|---|---|
| RISK-001 | Identified | Confirmed | Mitigation planned | Costed | {status} |
