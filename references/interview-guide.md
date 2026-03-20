# Discovery Interview Guide

Adaptive question bank organized by project type. Ask 3-4 questions at a time, process answers, then ask follow-ups. This is a conversation, not a survey.

## Universal Questions (Always Start Here)

### The Core Six

1. **What problem does this solve?** Who has this problem? How painful is it?
2. **Why now?** What's the trigger — a deadline, an opportunity, frustration with the current state?
3. **Who are the users?** Just the builder, a team, or external users? How many?
4. **What's the minimum version that would be useful?** Strip away wishes — what's the core?
5. **Any hard constraints?** Timeline, budget, must-use technology, compliance, team size?
6. **What already exists?** Codebase, designs, documentation, similar products, relevant services?

### Follow-Up Probes

- "What does success look like 3 months after launch?"
- "What's the thing you're most worried about?"
- "Have you tried to build this before? What happened?"
- "Who else needs to be happy with this?"

## Project-Type Question Trees

### Web Applications

**Core:**
- "Is this a new app or adding to an existing one?"
- "What's the primary user flow? Walk me through the main thing a user does."
- "How do users sign in? Email/password, social auth, SSO, magic links?"
- "Is this a SPA, server-rendered, or hybrid?"

**Data & State:**
- "What data does the app store? What's the most important entity?"
- "Real-time features needed? (live updates, chat, notifications)"
- "File uploads? If so, what kinds, how large, how many?"
- "Search functionality? Simple text search or faceted/filtered?"

**Scale & Performance:**
- "Expected number of users at launch? In 6 months? In a year?"
- "Any pages that must load in under X seconds?"
- "Geographic distribution — single region or global?"

**Business:**
- "Monetization model? Free, freemium, subscription, one-time purchase?"
- "Payment processing needed?"
- "Admin dashboard needed? What actions can admins take?"

### Mobile Applications

**Core:**
- "iOS, Android, or both? Native or cross-platform?"
- "What does the app do that a mobile-optimized website can't?"
- "Offline functionality needed?"
- "Push notifications?"

**Device:**
- "Camera, GPS, or other device hardware needed?"
- "What's the minimum OS version to support?"
- "Tablet support or phone-only?"

**Distribution:**
- "App Store, Google Play, or enterprise distribution?"
- "In-app purchases?"
- "Analytics — what do you want to measure?"

### APIs & Backend Services

**Core:**
- "Who consumes this API? Internal services, partner companies, public developers?"
- "REST, GraphQL, gRPC, or websockets?"
- "Authentication model — API keys, OAuth, JWT?"
- "Rate limiting from day 1?"

**Data:**
- "What's the data source? Existing database, external APIs, user-generated?"
- "Read-heavy or write-heavy workload?"
- "Data consistency requirements — eventual OK or must be strong?"

**Operations:**
- "SLA requirements? (uptime, latency targets)"
- "Versioning strategy?"
- "Monitoring and alerting from day 1?"
- "Expected request volume — peak and average?"

### Data Pipelines

**Core:**
- "What data comes in and from where? (databases, APIs, files, streams)"
- "What comes out? (reports, transformed data, ML features, dashboards)"
- "Real-time or batch? If batch, how often?"
- "What triggers a pipeline run?"

**Scale:**
- "Data volume — per run and total?"
- "Acceptable processing time?"
- "Historical data to process or starting fresh?"

**Quality:**
- "Data quality expectations? Validation rules?"
- "What happens with bad/incomplete data — skip, quarantine, reject?"
- "Deduplication needed?"
- "Compliance/PII handling requirements?"

**Reliability:**
- "What happens if a step fails? Retry, skip, alert?"
- "Exactly-once semantics needed?"
- "Backfill strategy?"

### ML/AI Systems

**Core:**
- "What's the prediction/classification/generation task?"
- "What's the baseline to beat? (current approach, human performance, random)"
- "Training data — do you have it? How much? Labeled?"
- "Batch inference or real-time?"

**Model:**
- "Use existing models (APIs like Claude, OpenAI) or train custom?"
- "Latency requirements for inference?"
- "Model size constraints? (edge deployment, cost budget)"
- "How to measure model quality?"

**Operations:**
- "Retraining schedule?"
- "A/B testing or canary deployment for model versions?"
- "Feedback loop — how does user feedback improve the model?"
- "Explainability requirements?"

### Infrastructure & DevOps

**Core:**
- "What are we provisioning/managing? (compute, storage, networking, orchestration)"
- "Cloud provider preference? Multi-cloud?"
- "Existing infrastructure to integrate with?"
- "Team's ops experience level?"

**Requirements:**
- "Environments needed? (dev, staging, production)"
- "Deployment frequency target?"
- "Disaster recovery requirements?"
- "Cost budget?"

### Libraries & SDKs

**Core:**
- "What problem does the library solve for its users?"
- "Target language(s) and minimum version?"
- "Public package registry (npm, PyPI, etc.) or private?"
- "Who is the target developer audience?"

**Quality:**
- "Documentation — README, API docs, examples, tutorials?"
- "Test coverage expectations?"
- "Semantic versioning?"
- "Backwards compatibility policy?"

### CLI Tools

**Core:**
- "What does the tool do in one sentence?"
- "Interactive or scriptable (piping/automation)?"
- "Target OS — Linux, macOS, Windows, all?"
- "Installation method — package manager, download, cargo install, etc.?"

**UX:**
- "Config file or all flags?"
- "Verbose/quiet modes?"
- "Color output?"
- "Tab completion?"

## Adaptive Follow-Up Patterns

After initial answers, use these patterns to go deeper:

**The "Why" Chain:** Ask "why?" up to 3 times to get to root motivations.

**The "What If" Probe:** "What if [constraint X] didn't exist? What would you build differently?"

**The "Worst Case" Probe:** "What's the worst thing that could happen if this doesn't work?"

**The "Day in the Life" Probe:** "Walk me through a typical user's day. Where does this tool fit in?"

**The "Competitor" Probe:** "What are people using today instead? What's wrong with it?"
