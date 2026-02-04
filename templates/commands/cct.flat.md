# /cct.flat

Flat Orchestration — Orchestrator creates Workers directly (no Leads).

## When to use

- Simple tasks
- Bug fixes
- Single-domain work
- 1-3 files to change
- Less than 3 steps

## How it works

```
Orchestrator → Worker(s) → Results
```

## Execute

```bash
# Setup
mkdir -p .sessions .outputs workers

# Create worker directly (no lead!)
mkdir -p workers/<worker_name>
cp templates/worker.md workers/<worker_name>/CLAUDE.md

# Customize worker
cat >> workers/<worker_name>/CLAUDE.md << 'EOF'

## Your Task
<task from user>

## Output
Save to ../../.outputs/<worker_name>.md
When done: echo "DONE" > ../../.outputs/<worker_name>.status
EOF

# Launch worker
WORKER_ID=$(uuidgen)
echo "$WORKER_ID" > .sessions/<worker_name>.id
cd workers/<worker_name>
claude --dangerously-skip-permissions --session-id "$WORKER_ID" \
  -p "TASK: <task>. Read CLAUDE.md. Save result to ../../.outputs/" &
cd ../..
```

## Communication

- Worker writes `.outputs/<name>.status` = DONE
- Hooks notify you automatically
- No leads involved

## Worker count

- Trivial: 1 worker
- Simple: 1-2 workers
- If 4+ needed → use `/cct.full` instead
