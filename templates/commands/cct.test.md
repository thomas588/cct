# /cct.test

Testing phase — QA Lead ensures quality.

## Creates

- **Lead:** QA Lead
- **Output:** `.outputs/test-plan.md`, tests in repo

## Purpose

- Test planning
- Test case creation
- Quality validation
- Bug reporting

## Execute

```bash
mkdir -p leads/qa_lead && cd leads/qa_lead
mkdir -p .sessions .outputs workers

cp ../../templates/lead.md CLAUDE.md

cat >> CLAUDE.md << 'EOF'

## Phase: Testing

You ensure quality through testing.

## Your Task
1. Read ../../.outputs/spec.md for acceptance criteria
2. Create workers for test areas
3. Each worker writes tests for their area
4. Aggregate test results
5. Write test plan to ../../.outputs/test-plan.md
6. echo "DONE" > ../../.outputs/test-plan.status

## Suggested Workers
- test_analyst: test strategy, test cases
- automation_engineer: automated tests (unit, integration, e2e)
EOF
cd ../..

LEAD_ID=$(uuidgen)
echo "$LEAD_ID" > .sessions/qa_lead.id
cd leads/qa_lead
claude --dangerously-skip-permissions --session-id "$LEAD_ID" \
  -p "TASK: Create test plan. Create workers, write tests, aggregate to ../../.outputs/test-plan.md" &
cd ../..
```

## Next phase

After testing: `/cct.docs` or deployment
