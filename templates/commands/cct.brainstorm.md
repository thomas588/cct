# /cct.brainstorm

Brainstorm phase — Multiple perspectives explore a topic.

## Creates

- **Lead:** Brainstorm Lead
- **Output:** `.outputs/brainstorm.md`

## Purpose

- Explore topic from multiple angles
- Parallel ideation
- Synthesize diverse viewpoints

## Usage

```
/cct.brainstorm "topic" --roles=Role1,Role2,Role3
```

**Example:**
```
/cct.brainstorm "authentication system" --roles=BA,Architect,Security
/cct.brainstorm "UI redesign" --roles=UX,Frontend,Product
```

## Execute

```bash
TOPIC="$1"
ROLES="$2"  # comma-separated: BA,Architect,Security

mkdir -p leads/brainstorm_lead && cd leads/brainstorm_lead
mkdir -p .sessions .outputs workers

cp ../../templates/lead.md CLAUDE.md

cat >> CLAUDE.md << EOF

## Phase: Brainstorm

You coordinate parallel brainstorming on: $TOPIC

## Your Task
1. Read ../../.context/project.md for context
2. Create workers for each role: $ROLES
3. Each worker explores topic from their perspective, writes to .outputs/
4. Aggregate all views into ../../.outputs/brainstorm.md
5. echo "DONE" > ../../.outputs/brainstorm.status

## Worker Output Format
Each worker writes to .outputs/<role>_view.md:
- Key considerations from their perspective
- Risks and opportunities they see
- Recommendations

## Aggregation Format
In ../../.outputs/brainstorm.md:
- Summary of each perspective
- Common themes across views
- Conflicts/tensions to resolve
- Recommended next steps
EOF
cd ../..

LEAD_ID=$(uuidgen)
echo "$LEAD_ID" > .sessions/brainstorm_lead.id
cd leads/brainstorm_lead
claude --dangerously-skip-permissions --session-id "$LEAD_ID" \
  -p "TASK: Brainstorm '$TOPIC' with roles: $ROLES. Create workers, aggregate to ../../.outputs/brainstorm.md" &
cd ../..
```
