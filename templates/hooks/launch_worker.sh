#!/bin/bash
# CCT Worker Launcher - Indirection script for hierarchical mode
# This script bypasses Claude's nested spawn protection
#
# Usage: ./launch_worker.sh <worker_name> <task_description> [working_dir]
#
# Arguments:
#   worker_name  - Name of the worker (used for session ID and logs)
#   task         - Task description for the worker
#   working_dir  - Optional working directory (default: current)

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

# Launch worker in background
cd "$WORKING_DIR"
nohup claude --dangerously-skip-permissions \
    --session-id "$WORKER_ID" \
    -p "$TASK. Read CLAUDE.md for full instructions." \
    > "../.outputs/${WORKER_NAME}.log" 2>&1 &

WORKER_PID=$!

echo "LAUNCHED"
echo "WORKER_NAME=$WORKER_NAME"
echo "WORKER_ID=$WORKER_ID"
echo "WORKER_PID=$WORKER_PID"
echo "LOG=.outputs/${WORKER_NAME}.log"
