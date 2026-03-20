# Architecture Document Template

Generate the architecture document following this structure. Pull data from architecture.json and related Mermaid diagrams.

---

# {Project Name} — Technical Architecture

## 1. Architecture Overview

### Style & Rationale
**Architecture Style:** {style}
**Rationale:** {Why this style was chosen — reference the decision framework from the architecture phase}

### Component Diagram
{Embed or reference diagrams/component.mermaid}

### Key Design Principles
{List the architectural principles guiding this design — e.g., "separation of concerns", "fail gracefully", "design for observability"}

## 2. Component Specifications

For each component from architecture.json:

### {Component Name}

**Responsibility:** {single sentence}
**Requirements Served:** {REQ-IDs}

**Interfaces:**
- Input: {what it receives, from where, format}
- Output: {what it produces, to where, format}

**Internal Design:**
{How the component works internally — key classes, patterns, algorithms}

**Dependencies:**
{What this component needs — other components, external services, libraries}

**Data Owned:**
{What data this component is source-of-truth for}

**Technology:**
{Specific tech choices for this component}

## 3. API Contracts

### {Resource/Endpoint Group}

#### {METHOD} {/path}
**Purpose:** {what it does}
**Auth:** {required/optional/none}
**Rate limit:** {if applicable}

**Request:**
```json
{request schema with example}
```

**Validation Rules:**
{field-level validation}

**Response — Success ({status code}):**
```json
{response schema with example}
```

**Response — Error ({status codes}):**
```json
{error response schema}
```

{Repeat for each endpoint}

## 4. Data Model

### Entity Relationship Diagram
{Embed or reference diagrams/data-model.mermaid}

### Entity Specifications

#### {Entity Name}

| Field | Type | Constraints | Description |
|---|---|---|---|
| id | UUID | PK | Primary identifier |
| {field} | {type} | {constraints} | {description} |
| created_at | timestamp | NOT NULL | Record creation time |
| updated_at | timestamp | NOT NULL | Last update time |

**Relationships:** {list}
**Indexes:** {list with justification}
**Business Rules:** {data-level rules}

## 5. Critical Flows

For each critical flow identified in the architecture phase:

### {Flow Name}
{Embed or reference diagrams/sequence-{flow-name}.mermaid}

**Description:** {What this flow accomplishes}
**Components Involved:** {list}
**Error Handling:** {What happens when each step fails}
**Performance Notes:** {Any latency or throughput considerations}

## 6. Infrastructure Architecture

### Deployment Architecture
{Describe the deployment model — containers, serverless, VMs, etc.}
{Include deployment diagram if helpful}

### Environments
| Environment | Purpose | Infrastructure |
|---|---|---|
| Development | Local dev and testing | {details} |
| Staging | Pre-production validation | {details} |
| Production | Live system | {details} |

### CI/CD Pipeline
{Describe the build and deployment pipeline}

## 7. Security Architecture

### Authentication & Authorization
{Auth model — JWT, sessions, API keys, OAuth, etc.}
{Permission model — roles, scopes, ACLs}

### Data Protection
{Encryption at rest and in transit}
{PII handling}
{Data retention policy}

### Threat Model Overview
{Top threats and mitigations — reference OWASP Top 10 where applicable}

## 8. Failure Modes & Mitigations

| Component | Failure Mode | Impact | Detection | Mitigation |
|---|---|---|---|---|
| {from architecture.json failure_modes} |

### Resilience Patterns
{Circuit breakers, retries, fallbacks, graceful degradation}

## 9. Technology Decisions

For each significant technology choice:

### Decision: {What was decided}
**Context:** {Why a decision was needed}
**Options Considered:** {What alternatives existed}
**Decision:** {What was chosen}
**Rationale:** {Why — including tradeoffs}
**Consequences:** {What this means going forward}

## 10. Open Questions

{From architecture.json open_decisions — decisions still pending with their options and impact}
