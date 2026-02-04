# /cct.docs

Documentation phase — Docs Lead creates documentation.

## Creates

- **Lead:** Docs Lead
- **Output:** `docs/` folder

## Purpose

- User documentation
- API documentation
- README
- Guides

## Execute

```bash
mkdir -p leads/docs_lead && cd leads/docs_lead
mkdir -p .sessions .outputs workers

cp ../../templates/lead.md CLAUDE.md

cat >> CLAUDE.md << 'EOF'

## Phase: Documentation

You create project documentation.

## Your Task
1. Read all ../../.outputs/*.md files
2. Create workers for doc sections
3. Each worker writes their section
4. Aggregate into docs/ folder
5. Ensure README, user guide, API docs
6. echo "DONE" > ../../.outputs/docs.status

## Suggested Workers
- technical_writer: README, user guide, tutorials
- api_documenter: API reference, examples
EOF
cd ../..

LEAD_ID=$(uuidgen)
echo "$LEAD_ID" > .sessions/docs_lead.id
cd leads/docs_lead
claude --dangerously-skip-permissions --session-id "$LEAD_ID" \
  -p "TASK: Write documentation. Create workers, aggregate to docs/ folder" &
cd ../..
```
