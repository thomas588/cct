# /cct.implement

Implementation phase — Dev Lead coordinates coding.

## Creates

- **Lead:** Dev Lead
- **Output:** Code in repository

## Purpose

- Write code based on spec and architecture
- Backend implementation
- Frontend implementation
- Integration

## Execute

```bash
mkdir -p leads/dev_lead && cd leads/dev_lead
mkdir -p .sessions .outputs workers

cp ../../templates/lead.md CLAUDE.md

cat >> CLAUDE.md << 'EOF'

## Phase: Implementation

You coordinate code implementation for the project.

## Your Task
1. Read ../../.outputs/spec.md and ../../.outputs/architecture.md
2. Break down into implementable tasks
3. Create workers for each component
4. Each worker writes code, saves to repo
5. Coordinate integration
6. echo "DONE" > ../../.outputs/implementation.status

## Suggested Workers
- backend_dev: backend code, APIs, database
- frontend_dev: frontend code, UI components
- integration_dev: connecting components, testing integration
EOF
cd ../..

LEAD_ID=$(uuidgen)
echo "$LEAD_ID" > .sessions/dev_lead.id
cd leads/dev_lead
claude --dangerously-skip-permissions --session-id "$LEAD_ID" \
  -p "TASK: Implement system. Create workers for backend/frontend, coordinate, write code." &
cd ../..
```

## Next phase

After implementation: `/cct.test`
