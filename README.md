# CCT - Claude Code Team

[![npm version](https://badge.fury.io/js/claude-code-team.svg)](https://www.npmjs.com/package/claude-code-team)

Orchestrate multiple Claude sessions with hierarchical team structure.

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
