---
name: project-builder
description: "AI-native project management that transforms any input (idea, repo URL, web app, document, free text) into professional project documentation and execution plans. Runs a 7-phase pipeline: discover → scope → architect → estimate → plan → execute → retro. Use this skill whenever the user mentions 'project', 'build plan', 'project plan', 'estimate this project', 'architect this', 'sprint planning', 'project discovery', 'scope this', 'break this down', 'create PBIs', 'project retro', or wants to go from idea to execution on ANY kind of software project — web apps, APIs, mobile apps, data pipelines, ML systems, infrastructure, or anything else. Also triggers on: 'how long will this take', 'how much will this cost', 'plan the work', 'what should we build first', or any uploaded project document/spec. Even if the user doesn't say 'project' explicitly, trigger when they describe something that needs structured planning, estimation, or multi-phase execution."
---

# Project Builder — AI-Native Project Management

Transform any project input into structured, professional documentation and executable plans.

## What This Skill Does

Project Builder is a 7-phase pipeline that takes you from raw idea to delivered project:

```
Input: Idea / Repo URL / Web App / Document / Free Text
  → Phase 0: /project-discover  — Research & understand the project reality
  → Phase 1: /project-scope     — Define scope, requirements, and boundaries
  → Phase 2: /project-architect  — Design technical architecture
  → Phase 3: /project-estimate   — AI-native cost & time estimation
  → Phase 4: /project-plan       — Generate all project documents
  → Phase 5: /project-execute    — Sprint orchestration & delivery
  → Phase 6: /project-retro      — Retrospective & estimation calibration
```

Each phase builds on the previous one. You can run the full pipeline or any individual phase.

## How to Route

Detect the user's intent and jump to the right phase:

| User says something like... | Start at |
|---|---|
| "I have an idea for..." / pastes a URL / uploads a doc | Phase 0 (Discover) |
| "Here are my requirements" / "scope this" | Phase 1 (Scope) |
| "Design the architecture" / "how should we build this" | Phase 2 (Architect) |
| "How long / how much will this cost" | Phase 3 (Estimate) |
| "Generate the project docs" / "create PBIs" | Phase 4 (Plan) |
| "Start building" / "run the sprint" | Phase 5 (Execute) |
| "How did we do" / "retro" | Phase 6 (Retro) |
| "Plan this project" / "full pipeline" | Phase 0 → all phases |

When uncertain, start at Phase 0 — discovery never hurts.

## Phase Execution

### Reading Phase Skills

Each phase has its own SKILL.md with detailed instructions. Before running any phase, read:

```
skills/{phase-name}/SKILL.md
```

For example, to run Phase 0:
1. Read `skills/discover/SKILL.md` from THIS skill's directory
2. Follow its instructions completely
3. Save outputs to the project workspace

### Project Workspace

All project data lives in a workspace directory. Create it on first run:

```
{output-dir}/{project-slug}/
├── state/
│   ├── project-meta.json      # Created in Phase 0, updated throughout
│   ├── discovery-report.json   # Phase 0 output
│   ├── project-scope.json      # Phase 1 output
│   ├── architecture.json       # Phase 2 output
│   ├── estimate.json           # Phase 3 output
│   └── execution-log.json      # Phase 5 output
├── docs/                       # Phase 4 outputs
│   ├── project-charter.md
│   ├── architecture-doc.md
│   ├── wbs.md
│   ├── risk-register.md
│   ├── pbis/
│   ├── test-cases/
│   └── release-plan.md
├── diagrams/                   # Phase 2 outputs
│   ├── component.mermaid
│   ├── sequence.mermaid
│   └── data-flow.mermaid
└── retro/                      # Phase 6 outputs
    ├── retro-report.json
    └── estimation-calibration.json
```

### State Management

State flows between phases via JSON files in `state/`. Each phase reads its predecessors' outputs and writes its own.

**project-meta.json** is the central manifest — created in Phase 0, enriched by each subsequent phase:

```json
{
  "project_slug": "my-project",
  "project_name": "My Project",
  "created_at": "2026-03-20T10:00:00Z",
  "input_type": "repo_url",
  "input_source": "https://github.com/user/repo",
  "phases_completed": ["discover", "scope"],
  "current_phase": "architect",
  "project_type": "web_app",
  "tech_stack": ["React", "Node.js", "PostgreSQL"],
  "team_context": {
    "size": "solo_dev",
    "experience_level": "senior"
  }
}
```

### Completion Protocol

Every phase ends with one of these statuses:

| Status | Meaning | Next Step |
|---|---|---|
| `DONE` | Phase complete, all outputs generated | Proceed to next phase |
| `DONE_WITH_CONCERNS` | Complete but flagged issues exist | Review concerns, then proceed |
| `BLOCKED` | Cannot complete without resolution | Show blockers, ask user |
| `NEEDS_CONTEXT` | Missing information to proceed | Ask specific questions |

Present the status clearly and wait for user confirmation before advancing to the next phase.

## Quick Start Examples

**"I want to build a task management app"**
→ Start Phase 0 (Discover) → guided interview → tech stack detection → full pipeline

**"Here's my repo: github.com/user/project"**
→ Start Phase 0 (Discover) → clone & analyze → auto-detect everything → suggest next phase

**"I have requirements, just estimate it"**
→ Start Phase 1 (Scope) briefly to validate → Phase 3 (Estimate)

**"We finished the sprint, let's retro"**
→ Start Phase 6 (Retro) → compare actuals vs estimates → calibrate

## Configuration

Default config lives in `config/pipeline-config.json` in this skill's directory. Read it to understand defaults for approval gates, estimation parameters, and output formats. Users can override any setting.

## Reference Files

This skill bundles several reference files — read them as needed, not upfront:

| File | When to read |
|---|---|
| `references/interview-guide.md` | Phase 0 — discovery questions by project type |
| `references/estimation-benchmarks.json` | Phase 3 — token/cost reference data |
| `references/doc-templates/project-charter.md` | Phase 4 — charter generation |
| `references/doc-templates/architecture-doc.md` | Phase 4 — architecture doc generation |
| `references/doc-templates/wbs.md` | Phase 4 — work breakdown structure |
| `references/doc-templates/risk-register.md` | Phase 4 — risk register |
| `references/pbi-template.md` | Phase 4 — PBI generation |
| `references/test-case-template.md` | Phase 4 — test case generation |
