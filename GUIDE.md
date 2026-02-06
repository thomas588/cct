# CCT — Руководство по использованию

## Что такое CCT?

**CCT (Claude Code Team)** — система оркестрации нескольких Claude CLI сессий как команды разработчиков. Вы даёте задачу одному Claude (Orchestrator), а он создаёт команду из Lead'ов и Worker'ов которые работают **параллельно**.

**Для кого:** разработчики которые хотят ускорить research, проектирование, разработку и тестирование за счёт параллельной работы нескольких AI-агентов.

**Требования:**
- Node.js 18+
- Claude CLI (`claude` в терминале)
- Claude Max/Pro подписка

---

## Установка

```bash
# Установить глобально
npm install -g claude-code-team

# Проверить версию
cct --version
```

---

## Быстрый старт — Flat Mode (5 минут)

Flat mode — Orchestrator запускает Workers напрямую. Для простых задач.

```
Orchestrator (вы) → Worker 1
                  → Worker 2
                  → Worker 3
```

### Шаг 1: Создать проект

```bash
cct init my-research
cd my-research
```

### Шаг 2: Запустить Claude

```bash
claude --dangerously-skip-permissions
```

### Шаг 3: Дать задачу

В Claude наберите:
```
/cct.flat

Исследуй рынок AI-ассистентов в 2025 году.
Создай 3 workers:
- market_analyst — размер рынка, тренды
- competitor_analyst — конкуренты, их продукты
- trend_analyst — прогнозы, новые технологии
```

### Шаг 4: Мониторинг

Orchestrator будет показывать статус workers. Когда все завершатся, результат будет в:
```
.outputs/market_analyst.md
.outputs/competitor_analyst.md
.outputs/trend_analyst.md
```

### Что произошло:

```
1. Orchestrator создал 3 папки в workers/
2. Написал CLAUDE.md для каждого worker
3. Запустил каждого через `claude -p` (отдельный процесс)
4. Workers работали параллельно
5. Каждый worker написал результат в .outputs/
6. Workers сигнализировали статус: echo "DONE" > .outputs/name.status
7. Hooks показали уведомления Orchestrator'у
```

---

## Быстрый старт — Hierarchical Mode (10 минут)

Hierarchical mode — Orchestrator создаёт Lead, Lead создаёт Workers. Для сложных задач.

```
Orchestrator (вы) → Lead (координатор)
                      → Worker 1
                      → Worker 2
                      → Worker 3
```

### Шаг 1: Создать проект

```bash
cct init my-project
cd my-project
```

### Шаг 2: Запустить Claude

```bash
claude --dangerously-skip-permissions
```

### Шаг 3: Дать задачу

```
/cct.full

Спроектируй архитектуру системы мониторинга для IoT устройств.
```

### Шаг 4: Что произойдёт

```
1. Orchestrator создаёт Lead (architecture_lead)
2. Orchestrator запускает Lead через: claude -p "You are LEAD..."
3. Lead читает свой CLAUDE.md
4. Lead создаёт Workers (system_arch, data_arch, api_designer...)
5. Lead запускает Workers через: launch_worker.sh (systemd-run)
6. Workers работают параллельно
7. Workers пишут результаты в .outputs/
8. Lead читает результаты, агрегирует
9. Lead пишет финальный отчёт в ../../.outputs/architecture_lead.md
10. Lead сигнализирует: echo "DONE" > ../../.outputs/architecture_lead.status
11. Hook показывает Orchestrator'у: "LEAD ЗАВЕРШИЛ РАБОТУ"
```

### Шаг 5: Результаты

```
.outputs/architecture_lead.md       ← Агрегированный результат от Lead
.outputs/architecture_lead.status   ← DONE
leads/architecture_lead/.outputs/   ← Детальные результаты workers
```

---

## Какие кейсы покрывает

| Задача | Команда | Что создаётся | Результат |
|--------|---------|---------------|-----------|
| Исследование рынка | `/cct.discover` | BA Lead + researchers | Аналитика рынка |
| UX/UI дизайн | `/cct.design` | Design Lead + designers | Wireframes, user flows |
| Техническое задание | `/cct.spec` | Spec Lead + analysts | Спецификация |
| Архитектура | `/cct.architect` | Arch Lead + architects | Архитектурный документ |
| Реализация | `/cct.implement` | Dev Lead + developers | Код |
| Тестирование | `/cct.test` | QA Lead + testers | Тесты, баг-репорты |
| Документация | `/cct.docs` | Docs Lead + writers | Документация |
| Ревью | `/cct.review` | Reviewers | Отчёт о качестве |
| Брейншторм | `/cct.brainstorm` | Thinkers | Идеи, концепции |
| Простая задача | `/cct.flat` | Workers напрямую | Зависит от задачи |
| Сложная задача | `/cct.full` | Lead + Workers | Зависит от задачи |

---

## Примеры реальных задач

### Пример 1: Исследование рынка (Flat)

```
❯ /cct.flat

Исследуй рынок SIEM/SOAR решений для Центральной Азии.
Создай 5 workers:
- market_sizing — TAM/SAM/SOM анализ
- competitive_intel — анализ конкурентов
- customer_research — целевая аудитория, pain points
- regulatory_analyst — регуляторные требования
- strategy_analyst — стратегия выхода на рынок
```

**Результат:** 5 параллельных отчётов (~25-50KB каждый) за 3-5 минут.

### Пример 2: Проектирование архитектуры (Hierarchical)

```
❯ /cct.architect

Спроектируй архитектуру гибридной SIEM/SOAR платформы.
Нужны: системная архитектура, модель данных, API дизайн,
AI/ML pipeline, инфраструктура и деплой.
```

**Результат:**
```
architect_lead.md (39 KB)
├── system_architect.md (1658 строк)
├── data_architect.md (2672 строк)
├── api_designer.md (2265 строк)
├── ai_architect.md (2850 строк)
└── infra_architect.md (1691 строк)
```

### Пример 3: Анализ фич продукта (Hierarchical)

```
❯ /cct.full

Проведи анализ фич для SIEM/SOAR продукта:
- Полный каталог фич по категориям
- Фичи с высоким спросом
- Фичи за которые платят
- Уникальные/инновационные фичи
```

**Результат:** Product Lead создал 4 workers, получил 329 фич в 7 категориях с анализом монетизации.

---

## Структура проекта

```
project/
│
├── CLAUDE.md                  # Инструкции для Orchestrator
│
├── .claude/
│   ├── settings.json          # Конфигурация hooks
│   └── commands/              # Slash-команды (11 штук)
│       ├── cct.flat.md
│       ├── cct.full.md
│       ├── cct.discover.md
│       └── ...
│
├── .cct/hooks/
│   ├── check-leads.sh         # Hook: проверяет статусы
│   └── launch_worker.sh       # Скрипт запуска workers (systemd-run)
│
├── templates/
│   ├── lead.md                # Шаблон для Lead
│   ├── worker.md              # Шаблон для Worker
│   └── roles.yaml             # Каталог ролей (44 роли)
│
├── .context/
│   └── project.md             # Контекст проекта (общий для всех)
│
├── .sessions/                 # Session IDs (UUID для claude -r)
│   ├── ba_lead.id
│   └── architect_lead.id
│
├── .outputs/                  # Результаты работы
│   ├── ba_lead.md             # Результат от BA Lead
│   ├── ba_lead.status         # DONE / IN_PROGRESS / ERROR
│   └── architect_lead.md
│
├── leads/                     # Lead'ы (Hierarchical mode)
│   └── ba_lead/
│       ├── CLAUDE.md          # Инструкции Lead'а
│       ├── .sessions/         # Session IDs workers
│       ├── .outputs/          # Результаты workers
│       └── workers/           # Папки workers
│           ├── market_analyst/
│           │   └── CLAUDE.md
│           └── competitor_analyst/
│               └── CLAUDE.md
│
└── workers/                   # Workers (Flat mode)
    ├── researcher_1/
    │   └── CLAUDE.md
    └── researcher_2/
        └── CLAUDE.md
```

### Что за что отвечает

| Папка/Файл | Назначение |
|------------|------------|
| `CLAUDE.md` | Инструкции Orchestrator'а — что он знает и как работает |
| `.claude/settings.json` | Hooks — автоматические проверки статусов |
| `.claude/commands/` | Slash-команды — `/cct.flat`, `/cct.full` и т.д. |
| `.cct/hooks/check-leads.sh` | Скрипт который проверяет `.outputs/*.status` |
| `.cct/hooks/launch_worker.sh` | Запускает worker через `systemd-run` |
| `templates/lead.md` | Шаблон — копируется когда создаётся новый Lead |
| `templates/worker.md` | Шаблон — копируется когда создаётся новый Worker |
| `templates/roles.yaml` | Каталог 44 ролей (frontend-dev, architect, QA...) |
| `.context/project.md` | Общий контекст — все агенты читают этот файл |
| `.sessions/` | UUID сессий для `claude -r` (resume/общение) |
| `.outputs/` | Все результаты работы + статусные файлы |

---

## Статусы и мониторинг

### Статусы

| Статус | Значение | Файл |
|--------|----------|------|
| `IN_PROGRESS` | Агент начал работу | `.outputs/name.status` |
| `DONE` | Агент завершил работу | `.outputs/name.status` |
| `ERROR` | Произошла ошибка | `.outputs/name.status` + `.outputs/name.error` |
| `WAITING` | Агент ждёт ответа | `.outputs/name.status` |

### Как hooks работают

1. После **каждого tool call** Orchestrator'а запускается `check-leads.sh`
2. Скрипт проверяет `.outputs/*.status`
3. Если находит `DONE` — показывает уведомление и результат
4. Если находит `ERROR` — показывает ошибку
5. Если находит `IN_PROGRESS` — показывает что агент начал работу

### Ручная проверка

```bash
# Статусы всех агентов
for f in .outputs/*.status; do echo "$(basename $f .status): $(cat $f)"; done

# Активные Claude процессы
ps aux | grep "claude.*session-id" | grep -v grep

# Логи worker'а
cat .outputs/worker_name.log

# Логи через systemd
journalctl --user -u "cct-*" --since "10 minutes ago"
```

---

## Все команды

| Команда | Режим | Описание |
|---------|-------|----------|
| `/cct.flat` | Flat | Простые задачи: Orchestrator → Workers |
| `/cct.full` | Hierarchical | Сложные задачи: Orchestrator → Leads → Workers |
| `/cct.discover` | Авто | Фаза исследования и анализа |
| `/cct.design` | Авто | Фаза UX/UI дизайна |
| `/cct.spec` | Авто | Фаза спецификации |
| `/cct.architect` | Авто | Фаза архитектуры |
| `/cct.implement` | Авто | Фаза реализации |
| `/cct.test` | Авто | Фаза тестирования |
| `/cct.docs` | Авто | Фаза документации |
| `/cct.review` | Авто | Ревью предыдущей фазы |
| `/cct.brainstorm` | Авто | Параллельный брейншторм |

### CLI команды

```bash
cct init <name>    # Создать проект
cct init .         # Инициализировать в текущей папке
cct --version      # Показать версию
cct --help         # Показать справку
```

---

## Архитектура коммуникации

```
┌─────────────────────────────────────────────────────────────┐
│                     ORCHESTRATOR                             │
│                   (интерактивный)                            │
│                                                              │
│  • Получает задачи от пользователя                          │
│  • Запускает Leads/Workers через claude -p                  │
│  • Получает уведомления через hooks                         │
│  • Читает результаты из .outputs/                           │
└────────────────────────┬────────────────────────────────────┘
                         │
            ┌────────────┼────────────┐
            │ claude -p  │ claude -p  │
            ▼            ▼            ▼
     ┌───────────┐ ┌───────────┐ ┌───────────┐
     │   LEAD 1  │ │   LEAD 2  │ │  WORKER   │
     │ (фоновый) │ │ (фоновый) │ │ (Flat)    │
     └─────┬─────┘ └───────────┘ └───────────┘
           │
    ┌──────┼──────┐       systemd-run + claude -p
    ▼      ▼      ▼
┌───────┐┌───────┐┌───────┐
│WORKER ││WORKER ││WORKER │
│  1    ││  2    ││  3    │
└───────┘└───────┘└───────┘
```

### Потоки данных

| От | К | Механизм | Пример |
|----|---|----------|--------|
| User | Orchestrator | stdin (ввод в терминале) | `/cct.architect` |
| Orchestrator | Lead | `claude -p "task..."` | Запуск сессии |
| Lead | Worker | `launch_worker.sh` (systemd-run) | Запуск worker |
| Worker | Lead | `.status` файлы | `echo "DONE" > .status` |
| Lead | Orchestrator | `.status` файлы | `echo "DONE" > .status` |
| Hooks | Orchestrator | stdout (вывод в терминал) | "Lead ЗАВЕРШИЛ РАБОТУ" |

---

## FAQ

**Q: Сколько workers можно создать?**
A: Нет жёсткого ограничения. Рекомендуется 3-10 на Lead. Каждый worker — отдельный Claude процесс.

**Q: Работает ли на macOS?**
A: Flat mode — да. Hierarchical mode требует `systemd` (только Linux). На macOS можно использовать только Flat mode.

**Q: Сколько стоит?**
A: CCT бесплатный. Но каждый Worker/Lead — отдельная Claude сессия которая потребляет токены.

**Q: Можно ли использовать с существующим проектом?**
A: Да, `cct init .` инициализирует CCT в текущей папке.

**Q: Как остановить всех workers?**
A: `pkill -f "claude.*session-id"` — убьёт все фоновые Claude сессии.

**Q: Что если worker завис?**
A: Проверьте через `ps aux | grep claude`. Убейте зависший процесс через `kill <PID>`.
