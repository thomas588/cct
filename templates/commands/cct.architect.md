# /cct.architect

Architecture phase — Architect Lead designs system.

## Creates

- **Lead:** Architect Lead
- **Output:** `.outputs/architecture.md`

## Purpose

- System design
- Tech stack decisions
- API contracts
- Data models

## Execute

```bash
mkdir -p leads/architect_lead && cd leads/architect_lead
mkdir -p .sessions .outputs workers

cp ../../templates/lead.md CLAUDE.md

cat >> CLAUDE.md << 'EOF'

## Phase: Architecture

You design system architecture for the project.

## Your Task
1. Read ../../.context/project.md and ../../.outputs/spec.md
2. Create workers for architecture areas
3. Each worker designs their area, writes to .outputs/
4. Aggregate into cohesive architecture
5. Write final architecture to ../../.outputs/architecture.md
6. echo "DONE" > ../../.outputs/architecture.status

## Suggested Workers
- system_architect: high-level design, components, interactions
- data_architect: data model, storage, migrations
- api_designer: API contracts, endpoints, interfaces
EOF
cd ../..

LEAD_ID=$(uuidgen)
echo "$LEAD_ID" > .sessions/architect_lead.id
cd leads/architect_lead
claude --dangerously-skip-permissions --session-id "$LEAD_ID" \
  -p "TASK: Design architecture. Create workers, aggregate to ../../.outputs/architecture.md" &
cd ../..
```

## Next phase

After architecture: `/cct.implement`
