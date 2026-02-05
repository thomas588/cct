#!/bin/bash
# CCT Worker Launcher - Uses systemd-run for reliable subprocess spawning
# This works even when called from a background Claude session (claude -p)
#
# Usage: ./launch_worker.sh <worker_name> <task_description> [working_dir]

set -e

WORKER_NAME="$1"
TASK="$2"
WORKING_DIR="${3:-.}"

if [ -z "$WORKER_NAME" ] || [ -z "$TASK" ]; then
    echo "Usage: $0 <worker_name> <task> [working_dir]"
    exit 1
fi

# Ensure directories exist
mkdir -p .sessions .outputs

# Generate session ID
WORKER_ID=$(uuidgen)
echo "$WORKER_ID" > ".sessions/${WORKER_NAME}.id"

# Signal IN_PROGRESS
echo "IN_PROGRESS" > ".outputs/${WORKER_NAME}.status"

# Get absolute paths (required for systemd)
ABS_WORKING_DIR=$(cd "$WORKING_DIR" && pwd)
ABS_LOG="$(pwd)/.outputs/${WORKER_NAME}.log"

# Launch worker using systemd-run (works from background Claude sessions!)
systemd-run --user --unit="cct-${WORKER_NAME}-$$" \
    bash -c "cd '$ABS_WORKING_DIR' && claude --dangerously-skip-permissions --session-id '$WORKER_ID' -p '$TASK. Read CLAUDE.md for full instructions.' > '$ABS_LOG' 2>&1"

echo "LAUNCHED"
echo "WORKER_NAME=$WORKER_NAME"
echo "WORKER_ID=$WORKER_ID"
echo "LOG=.outputs/${WORKER_NAME}.log"
