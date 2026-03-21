---
name: project-builder
description: "AI-native project management that transforms any input (idea, repo URL, web app, document, free text) into professional project documentation and execution plans. Runs a 7-phase pipeline: discover → scope → architect → estimate → plan → execute → retro. Supports multiple AI providers, selectable execution modes (manual, hybrid, auto), and can run phase-by-phase or end-to-end. Use this skill whenever the user mentions 'project', 'build plan', 'project plan', 'estimate this project', 'architect this', 'sprint planning', 'project discovery', 'scope this', 'break this down', 'create PBIs', 'project retro', or wants to go from idea to execution on ANY kind of software project — web apps, APIs, mobile apps, data pipelines, ML systems, infrastructure, or anything else. Also triggers on: 'how long will this take', 'how much will this cost', 'plan the work', 'what should we build first', or any uploaded project document/spec. Even if the user doesn't say 'project' explicitly, trigger when they describe something that needs structured planning, estimation, or multi-phase execution."
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
  → Phase 3: /project-estimate   — Provider-aware cost & time estimation
  → Phase 4: /project-plan       — Generate all project documents
  → Phase 5: /project-execute    — Sprint orchestration & delivery
  → Phase 6: /project-retro      — Retrospective & estimation calibration
```

Each phase builds on the previous one. You can run the full pipeline or any individual phase.

## Spec-Driven Model

Project Builder operates across a **spec boundary** that separates two zones:

| Zone | Phases | How it works |
|---|---|---|
| **Spec Creation** | Discover → Scope → Architect | Agent collaborates with human to produce the spec. Human input is for content decisions — answering questions, making scope choices, confirming architecture — not gate approval. |
| **Spec Execution** | Estimate → Plan → Execute → Retro | Agent runs autonomously from the spec. No human intervention needed. The spec is the authority. |

The spec boundary is after Phase 2 (Architect). Once `state/architecture.json` is written with status DONE, everything after it auto-executes.

### Execution Mode Override

For Spec Creation phases, some users want more control. Three modes are available as a secondary option:

| Mode | What it means |
|---|---|
| `auto` | Default. Advance automatically when status is DONE. |
| `hybrid` | Pause at phase boundaries during spec creation for explicit confirmation. |
| `manual` | Pause at every major gate during spec creation. |

Post-spec-boundary, execution is always autonomous regardless of mode setting.

Read `config/pipeline-config.json` before starting and honor `execution.mode` plus provider settings.

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
│   ├── project-meta.json        # Created in Phase 0, updated throughout
│   ├── discovery-report.json    # Phase 0 output
│   ├── project-scope.json       # Phase 1 output
│   ├── architecture.json        # Phase 2 output
│   ├── estimate.json            # Phase 3 output
│   ├── release-plan.json        # Phase 4 machine-readable sprint plan
│   └── execution-log.json       # Phase 5 output with telemetry
├── docs/                        # Phase 4 outputs
│   ├── project-charter.md
│   ├── architecture-doc.md
│   ├── wbs.md
│   ├── risk-register.md
│   ├── pbis/
│   ├── test-cases/
│   └── release-plan.md
├── diagrams/                    # Phase 2 outputs
│   ├── component.mermaid
│   ├── data-model.mermaid
│   └── sequence-{flow-name}.mermaid
└── retro/                       # Phase 6 outputs
    ├── retro-report.json
    └── estimation-calibration.json
```

### State Management

State flows between phases via JSON files in `state/`. Each phase reads its predecessors' outputs and writes its own.

`project-meta.json` is the central manifest — created in Phase 0, enriched by each subsequent phase:

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
  "execution_mode": "hybrid",
  "provider_context": {
    "default_provider": "openai",
    "model_aliases": {
      "fast": "gpt-5.4-mini",
      "balanced": "gpt-5.4",
      "deep": "gpt-5.4"
    }
  },
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

**During Spec Creation (phases 0-2):** Present a summary when DONE, then advance. Only stop on BLOCKED or NEEDS_CONTEXT.

**After spec boundary (phases 3-6):** Auto-advance always. No "Ready to proceed?" prompts. The spec is the authority.

## Configuration

Default config lives in `config/pipeline-config.json` in this skill's directory. Read it to understand defaults for provider selection, approval gates, estimation parameters, execution modes, telemetry capture, and output formats. Users can override any setting. Note that `auto_advance` applies post-spec-boundary by default.

## Installation

Run `./install.sh` from the skill root to validate the packaged files and prepare local setup metadata.

## Reference Files

This skill bundles several reference files — read them as needed, not upfront:

| File | When to read |
|---|---|
| `references/interview-guide.md` | Phase 0 — discovery questions by project type |
| `references/estimation-benchmarks.json` | Phase 3 — provider-aware estimation benchmark data |
| `references/doc-templates/project-charter.md` | Phase 4 — charter generation |
| `references/doc-templates/architecture-doc.md` | Phase 4 — architecture doc generation |
| `references/doc-templates/wbs.md` | Phase 4 — work breakdown structure |
| `references/doc-templates/risk-register.md` | Phase 4 — risk register |
| `references/pbi-template.md` | Phase 4 — PBI generation |
| `references/test-case-template.md` | Phase 4 — test case generation |
