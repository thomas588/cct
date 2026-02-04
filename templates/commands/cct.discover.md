# /cct.discover

Discovery phase — BA Lead conducts research.

## Creates

- **Lead:** BA Lead
- **Output:** `.outputs/discovery.md`

## Purpose

- Market research
- Competitive analysis
- Use cases gathering
- Requirements elicitation

## Execute

```bash
mkdir -p leads/ba_lead && cd leads/ba_lead
mkdir -p .sessions .outputs workers

# Copy base lead template
cp ../../templates/lead.md CLAUDE.md

# Append phase-specific instructions
cat >> CLAUDE.md << 'EOF'

## Phase: Discovery

You conduct discovery research for the project.

## Your Task
1. Read ../../.context/project.md
2. Create workers for research (researcher, analyst)
3. Each worker researches their area, writes to .outputs/
4. Aggregate worker results
5. Write final discovery to ../../.outputs/discovery.md
6. echo "DONE" > ../../.outputs/discovery.status

## Suggested Workers
- market_researcher: market size, trends, opportunities
- competitive_analyst: competitors, their strengths/weaknesses
- requirements_analyst: user needs, use cases, constraints
EOF
cd ../..

LEAD_ID=$(uuidgen)
echo "$LEAD_ID" > .sessions/ba_lead.id
cd leads/ba_lead
claude --dangerously-skip-permissions --session-id "$LEAD_ID" \
  -p "TASK: Conduct discovery research. Create workers, delegate, aggregate to ../../.outputs/discovery.md" &
cd ../..
```

## Next phase

After discovery: `/cct.design` or `/cct.spec`
