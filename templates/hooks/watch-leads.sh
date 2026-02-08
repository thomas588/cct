#!/bin/bash
# CCT Background Watcher
# Polls .outputs/*.status every 30 seconds
# Writes notifications to .outputs/_notifications.log
# Solves the problem: hooks only fire on tool calls,
# so if Orchestrator is idle, status changes go unnoticed.
#
# Usage: systemd-run --user --unit="cct-watcher" bash .cct/hooks/watch-leads.sh

# Auto-detect project root
PROJECT_ROOT="$(pwd)"
OUTPUTS="$PROJECT_ROOT/.outputs"
NOTIFY_LOG="$OUTPUTS/_notifications.log"

mkdir -p "$OUTPUTS"

while true; do
  shopt -s nullglob

  for status_file in "$OUTPUTS"/*.status; do
    [ -f "$status_file" ] || continue

    raw=$(cat "$status_file")
    status=$(echo "$raw" | cut -d'|' -f1)
    name=$(basename "$status_file" .status)
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$status" in
      DONE*)
        result_file="$OUTPUTS/${name}.md"
        size=$(wc -c < "$result_file" 2>/dev/null || echo "0")
        echo "[$timestamp] DONE: $name (${size} bytes) → $result_file" >> "$NOTIFY_LOG"
        mv "$status_file" "$status_file.processed"
        ;;
      ERROR*)
        echo "[$timestamp] ERROR: $name — $raw" >> "$NOTIFY_LOG"
        mv "$status_file" "$status_file.processed"
        ;;
      IN_PROGRESS)
        echo "[$timestamp] STARTED: $name" >> "$NOTIFY_LOG"
        mv "$status_file" "$status_file.ack"
        ;;
    esac
  done

  # Also check leads/ subdirectories
  for lead_dir in "$PROJECT_ROOT"/leads/*/; do
    [ -d "$lead_dir/.outputs" ] || continue
    for status_file in "$lead_dir/.outputs/"*.status; do
      [ -f "$status_file" ] || continue

      raw=$(cat "$status_file")
      status=$(echo "$raw" | cut -d'|' -f1)
      name=$(basename "$status_file" .status)
      lead=$(basename "$(dirname "$(dirname "$status_file")")")
      timestamp=$(date '+%Y-%m-%d %H:%M:%S')

      case "$status" in
        DONE*)
          echo "[$timestamp] DONE: $lead/$name" >> "$NOTIFY_LOG"
          mv "$status_file" "$status_file.processed"
          ;;
        ERROR*)
          echo "[$timestamp] ERROR: $lead/$name — $raw" >> "$NOTIFY_LOG"
          mv "$status_file" "$status_file.processed"
          ;;
        IN_PROGRESS)
          echo "[$timestamp] STARTED: $lead/$name" >> "$NOTIFY_LOG"
          mv "$status_file" "$status_file.ack"
          ;;
      esac
    done
  done

  sleep 30
done
