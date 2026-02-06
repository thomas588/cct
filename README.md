# CCT - Claude Code Team

[![npm version](https://badge.fury.io/js/claude-code-team.svg)](https://www.npmjs.com/package/claude-code-team)

Orchestrate multiple Claude sessions with hierarchical team structure.

**[Руководство на русском (GUIDE.md)](./GUIDE.md)** — установка, примеры, troubleshooting.

## Installation

```bash
npm install -g claude-code-team
```

## Usage

### Create new project

```bash
cct init my-project
cd my-project
claude --dangerously-skip-permissions
```

### Initialize in existing folder

```bash
cd existing-project
cct init .
claude --dangerously-skip-permissions
```

### Give orchestrator a task

```
> Analyze Smart Traffic market in Central Asia
```

## Hierarchy

```
Orchestrator (you talk to this)
    ↓ creates & manages
Leads (Team Leads - coordinate domains)
    ↓ create & manage
Workers (Specialists - do actual work)
```

| Level | Creates | Manages | Does Work |
|-------|---------|---------|-----------|
| Orchestrator | Leads | Leads | NO |
| Leads | Workers | Workers | NO |
| Workers | — | — | YES |

## Project Structure

After `cct init`:
```
my-project/
├── CLAUDE.md              # Orchestrator instructions
├── features/              # Capabilities catalog
│   ├── agents.md          # Available agent roles
│   ├── skills.md          # Available skills
│   ├── mcps.md            # Available MCP tools
│   └── commands.md        # Available commands
├── templates/
│   └── lead.md            # Lead template (for orchestrator)
├── leads/                 # Empty (leads created on demand)
├── .context/              # Shared project context
├── .outputs/              # Lead outputs
└── .sessions/             # Session IDs
```

After orchestrator runs:
```
my-project/
├── CLAUDE.md
├── features/
├── templates/
├── .context/
│   └── project.md         # Project context (written by orchestrator)
├── .sessions/
│   ├── orchestrator.id
│   └── ba_lead.id
├── .outputs/
│   ├── ba_analysis.md     # Lead output
│   └── ba_lead.status     # Completion signal
└── leads/
    └── ba_lead/
        ├── CLAUDE.md      # Lead instructions
        ├── .outputs/      # Worker outputs
        │   ├── market.md
        │   └── competitors.md
        └── workers/
            ├── market_analyst/
            │   └── CLAUDE.md
            └── competitive_analyst/
                └── CLAUDE.md
```

## How It Works

1. **User** gives task to Orchestrator
2. **Orchestrator** writes `.context/project.md` and creates Leads
3. **Leads** create Workers from `features/` catalog
4. **Workers** execute tasks, write to Lead's `.outputs/`
5. **Leads** aggregate worker results, write to root `.outputs/`
6. **Orchestrator** reads Lead outputs, responds to User

## Methodology

CCT organizes work through **phases**. Each phase creates a specialized Lead.

| Phase | Command | Lead | Output |
|-------|---------|------|--------|
| Discovery | `/cct.discover` | BA Lead | `.outputs/discovery.md` |
| Design | `/cct.design` | Design Lead | `.outputs/design.md` |
| Specification | `/cct.spec` | Spec Lead | `.outputs/spec.md` |
| Architecture | `/cct.architect` | Architect Lead | `.outputs/architecture.md` |
| Implementation | `/cct.implement` | Dev Lead | code in repo |
| Testing | `/cct.test` | QA Lead | `.outputs/test-plan.md` |
| Documentation | `/cct.docs` | Docs Lead | `docs/` folder |
| **Review** | `/cct.review` | Review Lead | `.outputs/review-<phase>.md` |
| **Brainstorm** | `/cct.brainstorm` | Brainstorm Lead | `.outputs/brainstorm.md` |

**Not all phases required.** User chooses what's needed:
- Bug fix: only `/cct.implement`
- New feature: `/cct.spec` → `/cct.architect` → `/cct.implement`
- New product: all phases

**Review command** — validates phase output before proceeding:
```bash
/cct.review                    # Auto-selects reviewers based on last phase
/cct.review --with=Security    # Add extra reviewer
```

**Brainstorm command** — parallel exploration with specified roles:
```bash
/cct.brainstorm "auth system" --roles=BA,Architect,Security
```

### Example Workflow

```bash
# 1. Start orchestrator
cd my-project
claude --dangerously-skip-permissions

# 2. Discovery phase
> /cct.discover "authentication system for web app"
# → BA Lead researches, outputs to .outputs/discovery.md

# 3. Specification
> /cct.spec
# → Spec Lead formalizes requirements to .outputs/spec.md

# 4. Review before architecture
> /cct.review
# → Architect + Dev review spec, output to .outputs/review-spec.md
> cat .outputs/review-spec.md
# If blockers found → fix and re-run /cct.spec

# 5. Architecture
> /cct.architect
# → Architect Lead designs system

# 6. Review before implementation
> /cct.review
# → Dev reviews architecture

# 7. Implementation
> /cct.implement
# → Dev Lead creates workers, writes code
```

**With brainstorm:**
```bash
# Explore options before committing to approach
> /cct.brainstorm "authentication" --roles=BA,Architect,Security
# → Parallel exploration, aggregated to .outputs/brainstorm.md
> cat .outputs/brainstorm.md
# Then proceed with /cct.spec
```

### Key Principles

1. **Delegation over doing** — Orchestrator and Leads delegate, only Workers produce output
2. **Isolation** — Each agent has own context, doesn't interfere with others
3. **Transparency** — All results in `.outputs/`, review between phases
4. **User control** — User decides which phases and when to proceed

## Session Types

| Type | How Created | By Whom |
|------|-------------|---------|
| User session | `claude` (interactive) | Human |
| CCT session | `claude --session-id $ID -p "TASK"` | Orchestrator/Lead |

- **Orchestrator** runs in user session (you talk to it)
- **Leads** and **Workers** run as CCT sessions (created programmatically)
- CCT sessions can be resumed with `-r $ID` for Q&A
- Only **Workers** do actual work

## License

MIT
