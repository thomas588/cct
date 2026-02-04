# /cct.design

Design phase — Design Lead creates UX/UI.

## Creates

- **Lead:** Design Lead
- **Output:** `.outputs/design.md`

## Purpose

- UX research
- User flows
- Wireframes
- UI components

## Execute

```bash
mkdir -p leads/design_lead && cd leads/design_lead
mkdir -p .sessions .outputs workers

cp ../../templates/lead.md CLAUDE.md

cat >> CLAUDE.md << 'EOF'

## Phase: Design

You create UX/UI design for the project.

## Your Task
1. Read ../../.context/project.md and ../../.outputs/discovery.md
2. Create workers for design tasks
3. Each worker handles their area, writes to .outputs/
4. Aggregate worker results
5. Write final design to ../../.outputs/design.md
6. echo "DONE" > ../../.outputs/design.status

## Suggested Workers
- ux_researcher: user research, personas, journeys
- ui_designer: wireframes, components, interactions
EOF
cd ../..

LEAD_ID=$(uuidgen)
echo "$LEAD_ID" > .sessions/design_lead.id
cd leads/design_lead
claude --dangerously-skip-permissions --session-id "$LEAD_ID" \
  -p "TASK: Create UX design. Create workers, delegate, aggregate to ../../.outputs/design.md" &
cd ../..
```

## Next phase

After design: `/cct.spec`
