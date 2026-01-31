# CCT - Claude Code Team

[![npm version](https://badge.fury.io/js/claude-code-team.svg)](https://www.npmjs.com/package/claude-code-team)

Orchestrate multiple Claude sessions to work on complex tasks in parallel.

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
> Create a web service for generating startup ideas...
```

The orchestrator will:
1. Ask clarifying questions
2. Create worker sessions (specialists)
3. Delegate tasks to workers
4. Coordinate and aggregate results

## Project Structure

After `cct init`:
```
my-project/
├── CLAUDE.md           # Orchestrator (reads this automatically)
└── features/           # Agent & skill templates
```

After orchestrator runs:
```
my-project/
├── CLAUDE.md
├── features/
├── .sessions/          # Session IDs for Q&A
├── .outputs/           # Worker results
├── .context/
│   └── project.md      # Shared project context
├── workers/
│   └── backend_worker/
│       └── CLAUDE.md   # Worker identity
├── backend/            # Actual code (written by workers)
└── frontend/
```

## How It Works

1. **Orchestrator** reads CLAUDE.md and understands its role
2. **Orchestrator** creates workers (separate Claude sessions)
3. **Workers** execute tasks and write results to `.outputs/`
4. **Orchestrator** aggregates results and responds to user

## License

MIT
