# /cct.full

Hierarchical Orchestration — Orchestrator creates Leads, Leads create Workers.

## When to use

- Complex multi-domain tasks
- Research projects
- New features (backend + frontend + QA)
- Architecture decisions
- 4+ files to change
- 3+ steps required

## How it works

```
Orchestrator → Lead(s) → Worker(s) → Results
```

## Execute

This is the default behavior. Proceed with creating appropriate Lead(s):

1. Analyze task domains
2. Create Lead for each domain
3. Launch Leads with specific tasks
4. Wait for Leads to complete (hooks will notify)
5. Aggregate results

## See also

- `/cct.discover` — BA research phase
- `/cct.design` — UX/UI design phase
- `/cct.spec` — Specification phase
- `/cct.architect` — Architecture phase
- `/cct.implement` — Implementation phase
