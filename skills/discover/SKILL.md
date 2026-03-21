---
name: project-discover
description: "Phase 0 of Project Builder. Researches and analyzes any project input — repo URL, web app, uploaded document, or free-text idea — to produce a comprehensive discovery report. Detects tech stack, file structure, dependencies, test coverage, and project type. Runs a guided interview to fill knowledge gaps."
---

# Phase 0: Project Discovery

Understand what exists before deciding what to build. This phase takes any input and produces a structured discovery report that feeds all subsequent phases.

## Input Detection

First, classify the input:

| Input Type | Detection | Action |
|---|---|---|
| **Repo URL** | Contains github.com, gitlab.com, bitbucket.org, or similar | Clone and analyze |
| **Web App URL** | Any other URL | Browse and explore using browser MCP tools |
| **Uploaded File** | File attachment (doc, pdf, md, txt, json, etc.) | Parse and extract |
| **Free Text** | No URL, no file — just description | Guided interview |
| **Mixed** | Combination of above | Process each, then merge |

## Analysis by Input Type

### Repo URL Analysis

Clone the repo and run this analysis sequence:

1. **Structure scan** — List top-level files and directories. Identify the project type (monorepo, library, app, CLI tool, etc.)

2. **Tech stack detection** — Check for:
   - Package managers: package.json, requirements.txt, Cargo.toml, go.mod, Gemfile, pom.xml, build.gradle, pubspec.yaml, Package.swift
   - Frameworks: look at dependencies (React, Django, Rails, Spring, etc.)
   - Infrastructure: Dockerfile, docker-compose.yml, k8s configs, terraform, serverless.yml
   - CI/CD: .github/workflows, .gitlab-ci.yml, Jenkinsfile, .circleci

3. **Code metrics** — Using bash tools:
   - File count by language (find + wc)
   - Test file count and test-to-code ratio
   - README quality (exists? length? sections?)
   - API surface (route definitions, endpoint count)
   - Database schema (migrations, models)

4. **Dependency health** — Check:
   - Total dependency count
   - Lock file presence (indicates reproducible builds)
   - Any obvious security concerns (very old dependencies)

5. **Documentation inventory** — What docs exist? README, API docs, architecture docs, ADRs, wiki links

6. **Current state assessment** — Is this a new project, active development, maintenance mode, or legacy?

### Web App Analysis

Use browser MCP tools (navigate, read_page, screenshot, find) to explore:

1. **Landing page** — What does the app do? Key features visible
2. **Navigation structure** — Main sections, depth
3. **Tech detection** — View source for framework hints, check meta tags, look at network requests for API patterns
4. **Auth model** — Login required? SSO? Public?
5. **Core workflows** — Identify 3-5 primary user flows
6. **Screenshots** — Capture key screens for reference

### Document Analysis

Read the uploaded file and extract:

1. **Document type** — Requirements doc, spec, proposal, meeting notes, email thread, etc.
2. **Key entities** — Systems, services, roles, processes mentioned
3. **Requirements** (explicit and implicit) — What needs to be built/changed
4. **Constraints** mentioned — Timeline, budget, tech choices, compliance
5. **Unknowns** — Gaps, ambiguities, assumptions
6. **Stakeholders** referenced

### Free Text / Idea Analysis

When input is just an idea or description, run a guided interview. Read `references/interview-guide.md` from the project-builder skill directory for the full question bank. The interview adapts based on project type:

**Core questions (always ask):**

1. **What** — "What problem does this solve? Who has this problem?"
2. **Why now** — "Why build this now? What's the trigger?"
3. **Who** — "Who are the users? Just you, a team, or external users?"
4. **Scope** — "What's the minimum version that would be useful?"
5. **Constraints** — "Any hard constraints? (timeline, budget, must-use tech, compliance)"
6. **Existing** — "Is there anything that already exists? (codebase, designs, docs, similar products)"

**Adapt follow-ups based on answers.** The interview-guide.md has domain-specific question trees for: web apps, mobile apps, APIs/backends, data pipelines, ML/AI systems, infrastructure/DevOps, libraries/SDKs, and CLI tools.

Don't ask all questions at once. Ask 3-4, process the answers, then ask follow-ups. The goal is a conversation, not a survey.

## Premise Challenge

After gathering initial information, challenge the premise before proceeding. This is the most valuable part of discovery — it prevents building the wrong thing.

Ask (adapt to context):

1. **"Is this actually the right problem to solve?"** — Sometimes the stated problem is a symptom. Look for the root cause.
2. **"Does this already exist?"** — Search for existing solutions. If something close exists, why not use/extend it?
3. **"What's the simplest version?"** — Push toward the smallest possible scope that delivers value.
4. **"What happens if we don't build this?"** — Understanding the cost of inaction clarifies priority.
5. **"Who else should be involved in this decision?"** — Surface missing stakeholders early.

Present challenges respectfully — you're not blocking the project, you're stress-testing the idea so the user can proceed with confidence.

## Discovery Report

Compile everything into `state/discovery-report.json`:

```json
{
  "phase": "discover",
  "status": "DONE",
  "timestamp": "2026-03-20T10:00:00Z",
  "input": {
    "type": "repo_url | web_app | document | free_text | mixed",
    "source": "the URL, filename, or 'conversation'",
    "summary": "2-3 sentence summary of what was analyzed"
  },
  "project": {
    "name": "Human-readable project name",
    "slug": "kebab-case-slug",
    "type": "web_app | mobile_app | api | data_pipeline | ml_system | infrastructure | library | cli_tool | other",
    "description": "Clear, complete description of what the project does/should do",
    "problem_statement": "The problem this solves",
    "target_users": ["user type 1", "user type 2"],
    "current_state": "new | early_development | active | maintenance | legacy"
  },
  "technical": {
    "tech_stack": {
      "languages": ["TypeScript", "Python"],
      "frameworks": ["Next.js", "FastAPI"],
      "databases": ["PostgreSQL"],
      "infrastructure": ["Docker", "AWS"],
      "ci_cd": ["GitHub Actions"]
    },
    "architecture_style": "monolith | microservices | serverless | hybrid | unknown",
    "codebase_metrics": {
      "total_files": 0,
      "files_by_language": {},
      "test_coverage_estimate": "high | medium | low | none | unknown",
      "documentation_quality": "comprehensive | adequate | minimal | none"
    },
    "dependencies": {
      "count": 0,
      "notable": ["list key dependencies"],
      "concerns": ["any dependency issues"]
    }
  },
  "requirements_raw": [
    {
      "id": "DR-001",
      "title": "Short title",
      "description": "What was discovered/stated",
      "source": "repo_analysis | user_interview | document | web_exploration",
      "confidence": "high | medium | low"
    }
  ],
  "constraints": {
    "timeline": "any stated timeline",
    "budget": "any stated budget",
    "technical": ["must-use constraints"],
    "compliance": ["regulatory requirements"],
    "team": "team size and composition"
  },
  "risks_identified": [
    {
      "id": "RISK-D-001",
      "description": "Risk description",
      "severity": "high | medium | low",
      "source": "Where this risk was identified"
    }
  ],
  "unknowns": [
    "List of things we still don't know"
  ],
  "premise_challenge": {
    "challenges_raised": ["what was questioned"],
    "user_responses": ["how user responded"],
    "resolved": true
  },
  "recommendation": "What to do next — which phase and why"
}
```

## Also Update project-meta.json

Create (or update) `state/project-meta.json` with the discovered information. See the main SKILL.md for the schema.

## Phase Completion

Present a summary:

```
DISCOVERY COMPLETE — {project_name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Type: {project_type}
Stack: {tech stack summary}
State: {current_state}
Scope: {brief scope}

Key Findings:
  • {finding 1}
  • {finding 2}
  • {finding 3}

Risks: {count} identified
Unknowns: {count} remaining

Status: {DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT}

Recommendation: {what to do next}
```

If status is DONE, advance to Phase 1 (Scope). If NEEDS_CONTEXT or BLOCKED, resolve before advancing.
