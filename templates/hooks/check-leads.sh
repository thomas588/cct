#!/bin/bash
# CCT Hook: Check lead status and questions
# Runs after every tool call via PostToolUse hook

# Find project root (where .outputs is)
if [ -d ".outputs" ]; then
  OUTPUTS_DIR=".outputs"
elif [ -d "../../.outputs" ]; then
  OUTPUTS_DIR="../../.outputs"
else
  exit 0
fi

# Check for completed leads
shopt -s nullglob
for status_file in "$OUTPUTS_DIR"/*.status; do
  [ -f "$status_file" ] || continue

  status=$(cat "$status_file")
  lead=$(basename "$status_file" .status)

  case "$status" in
    DONE)
      echo ""
      echo "══════════════════════════════════════════════════════════"
      echo "📬 LEAD '$lead' ЗАВЕРШИЛ РАБОТУ"
      echo "══════════════════════════════════════════════════════════"

      result_file="$OUTPUTS_DIR/${lead}.md"
      if [ -f "$result_file" ]; then
        echo ""
        echo "Результат: $result_file"
        echo "──────────────────────────────────────────────────────────"
        head -100 "$result_file"
        lines=$(wc -l < "$result_file")
        if [ "$lines" -gt 100 ]; then
          echo ""
          echo "[...показаны первые 100 из $lines строк]"
        fi
      fi
      echo "══════════════════════════════════════════════════════════"

      # Mark as processed
      mv "$status_file" "$status_file.processed"
      ;;

    ERROR)
      echo ""
      echo "══════════════════════════════════════════════════════════"
      echo "❌ LEAD '$lead' СООБЩАЕТ ОБ ОШИБКЕ"
      echo "══════════════════════════════════════════════════════════"

      error_file="$OUTPUTS_DIR/${lead}.error"
      if [ -f "$error_file" ]; then
        cat "$error_file"
      fi
      echo "══════════════════════════════════════════════════════════"

      mv "$status_file" "$status_file.processed"
      ;;

    WAITING)
      # Lead is waiting for something, don't process yet
      ;;

    IN_PROGRESS)
      echo ""
      echo "══════════════════════════════════════════════════════════"
      echo "🔄 LEAD/WORKER '$lead' НАЧАЛ РАБОТУ"
      echo "══════════════════════════════════════════════════════════"

      # Mark as acknowledged (don't process again)
      mv "$status_file" "$status_file.ack"
      ;;
  esac
done

# Show notifications from background watcher (if running)
NOTIFY_LOG="$OUTPUTS_DIR/_notifications.log"
if [ -f "$NOTIFY_LOG" ] && [ -s "$NOTIFY_LOG" ]; then
  echo ""
  echo "══════════════════════════════════════════════════════════"
  echo "📋 BACKGROUND NOTIFICATIONS"
  echo "══════════════════════════════════════════════════════════"
  cat "$NOTIFY_LOG"
  echo "══════════════════════════════════════════════════════════"
  # Clear after showing
  > "$NOTIFY_LOG"
fi

# Check for questions from leads
for question_file in "$OUTPUTS_DIR"/*.question; do
  [ -f "$question_file" ] || continue

  lead=$(basename "$question_file" .question)

  echo ""
  echo "══════════════════════════════════════════════════════════"
  echo "❓ ВОПРОС ОТ LEAD '$lead'"
  echo "══════════════════════════════════════════════════════════"
  echo ""
  cat "$question_file"
  echo ""
  echo "──────────────────────────────────────────────────────────"
  echo "Чтобы ответить, напишите ответ и я передам его лиду."
  echo "Файл вопроса: $question_file"
  echo "══════════════════════════════════════════════════════════"
done
