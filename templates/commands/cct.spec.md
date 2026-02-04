# /cct.spec

Specification phase — Spec Lead writes formal requirements.

## Creates

- **Lead:** Spec Lead
- **Output:** `.outputs/spec.md`

## Purpose

- Formal requirements (FR, NFR)
- Acceptance criteria
- Constraints documentation

## Execute

```bash
mkdir -p leads/spec_lead && cd leads/spec_lead
mkdir -p .sessions .outputs workers

cp ../../templates/lead.md CLAUDE.md

cat >> CLAUDE.md << 'EOF'

## Phase: Specification

You write formal specifications for the project.

## Your Task
1. Read ../../.context/project.md and previous outputs
2. Create workers for spec sections
3. Each worker writes their section to .outputs/
4. Aggregate into formal spec
5. Write final spec to ../../.outputs/spec.md
6. echo "DONE" > ../../.outputs/spec.status

## Suggested Workers
- requirements_analyst: functional and non-functional requirements
- acceptance_writer: acceptance criteria for each requirement
EOF
cd ../..

LEAD_ID=$(uuidgen)
echo "$LEAD_ID" > .sessions/spec_lead.id
cd leads/spec_lead
claude --dangerously-skip-permissions --session-id "$LEAD_ID" \
  -p "TASK: Write specification. Create workers, aggregate to ../../.outputs/spec.md" &
cd ../..
```

## Next phase

After spec: `/cct.architect`
