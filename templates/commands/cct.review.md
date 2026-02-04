# /cct.review

Review phase — Review Lead validates previous phase.

## Creates

- **Lead:** Review Lead
- **Output:** `.outputs/review-<phase>.md`

## Purpose

- Review previous phase output
- Identify issues and risks
- Provide feedback before proceeding

## Auto-assigned reviewers

| Previous Phase | Reviewers |
|----------------|-----------|
| discovery | Architect |
| spec | Architect + Dev |
| architecture | Dev |
| implement | QA |

## Execute

```bash
# Determine last phase
LAST_PHASE=$(ls -t .outputs/*.md 2>/dev/null | head -1 | xargs basename 2>/dev/null | sed 's/.md//')

mkdir -p leads/review_lead && cd leads/review_lead
mkdir -p .sessions .outputs workers

cp ../../templates/lead.md CLAUDE.md

cat >> CLAUDE.md << EOF

## Phase: Review

You coordinate review of the $LAST_PHASE phase.

## Your Task
1. Read ../../.outputs/$LAST_PHASE.md
2. Create reviewer workers based on phase
3. Each reviewer writes feedback to .outputs/
4. Aggregate into ../../.outputs/review-$LAST_PHASE.md
5. echo "DONE" > ../../.outputs/review-$LAST_PHASE.status

## Review Format
For each issue found:
- BLOCKER: Must fix before proceeding
- WARNING: Should consider fixing
- SUGGESTION: Nice to have
EOF
cd ../..

LEAD_ID=$(uuidgen)
echo "$LEAD_ID" > .sessions/review_lead.id
cd leads/review_lead
claude --dangerously-skip-permissions --session-id "$LEAD_ID" \
  -p "TASK: Review $LAST_PHASE. Create reviewer workers, aggregate to ../../.outputs/review-$LAST_PHASE.md" &
cd ../..
```

## Usage

```
/cct.review                    # Auto-select reviewers
/cct.review --with=Security    # Add extra reviewer
```
