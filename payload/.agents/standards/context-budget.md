# Context Budget Standard — Token-Aware Agent Operations

> Derived from [Harness Engineering Guide — Context Engineering](https://harness-guide.com/guide/context-engineering/).
> AI agents MUST follow these budgets to prevent context window exhaustion.

---

## 1. Why Token Budgets Matter

Context windows are finite. For a 128K-token model, the usable working space after system prompt, tool schemas, and reserved response capacity is approximately **80K tokens**. Without explicit budgeting, agents exhaust their window by turn 30–35, leading to compaction artifacts, hallucination, and session collapse.

**Core Principle**: Every token loaded into context must earn its place. If it's not needed for the current Phase, it must not be loaded.

---

## 2. Token Budget Architecture

```
Context Window Budget (128K model example)
┌──────────────────────────────────────────────────────────┐
│ Layer 0: Platform Overhead (Not controllable)  ~8,000    │
│   └─ Tool schemas, system boilerplate                    │
├──────────────────────────────────────────────────────────┤
│ Layer 1: Core Directives (Always loaded)       ~3,000    │
│   └─ copilot-instructions.md (core section only)        │
│   └─ Active Agent persona (.agent.md)                    │
├──────────────────────────────────────────────────────────┤
│ Layer 2: Phase Context (Loaded per-phase)       ~3,000   │
│   └─ Active SKILL.md for current phase                   │
│   └─ SSDLC_TRACKER.md (state checkpoint)                 │
│   └─ latest_state.json (structured handoff)              │
├──────────────────────────────────────────────────────────┤
│ Layer 3: Project Memory (Loaded if exists)      ~2,000   │
│   └─ .ai/memory/MEMORY.md (project-level lessons)        │
│   └─ latest_memo.md (prose context supplement)           │
├──────────────────────────────────────────────────────────┤
│ Layer 4: Working Memory (Conversation)         ~variable │
│   └─ User messages + AI responses                        │
│   └─ Tool call results (grep, file reads, etc.)          │
├──────────────────────────────────────────────────────────┤
│ Layer 5: Response Reserve (Always reserved)     ~4,096   │
│   └─ Guaranteed output capacity                          │
└──────────────────────────────────────────────────────────┘
```

**[AI DIRECTIVE]**: When assembling context, load layers in order 0→1→2→3→4. If Layer 4 (conversation) begins consuming more than 60% of the window, trigger the **Auto-Handoff Protocol** (see Section 5).

---

## 3. Loading Priority Rules

| Priority | What to Load | When | Est. Tokens |
|:---:|:---|:---|:---:|
| P0 | `copilot-instructions.md` core section | Always | ~2,500 |
| P0 | Active `.agent.md` persona | Always | ~500 |
| P1 | Current Phase `SKILL.md` | When entering a Phase | ~1,500 |
| P1 | `SSDLC_TRACKER.md` | When resuming / at Gate | ~800 |
| P1 | `latest_state.json` | When resuming (`$pm continue`) | ~500 |
| P2 | `latest_memo.md` | When resuming (`$pm continue`) | ~1,000 |
| P2 | `MEMORY.md` | When starting new feature | ~1,000 |
| P3 | Referenced standards (on-demand) | Only when needed | ~800 each |
| P3 | Source code files | Only when editing | ~variable |

**[AI DIRECTIVE]**: Standards files (`ssdlc-core-rules.md`, `agent-network.md`, `concurrency-policy.md`, etc.) MUST NOT be pre-loaded. Read them only when the current task requires their specific guidance.

---

## 4. Skill Loading Protocol (On-Demand)

Skills are expensive context. An average SKILL.md is ~1,500 tokens. Loading all 91 skills would consume **~136K tokens** — more than the entire context window.

### Rule: Menu → Select → Load → Execute → Unload

1. **Menu**: Agent reads only the Skill name + one-line description from `_SKILL_MENU.md` (~300 tokens total)
2. **Select**: Based on the current Phase/task, agent identifies the single skill needed
3. **Load**: Read the full SKILL.md into context
4. **Execute**: Follow the skill's workflow
5. **Unload**: After the skill's exit criteria are met, the skill is considered "unloaded" — do not reference it again

**[AI DIRECTIVE]**: You MUST NOT load more than **2 Skills** simultaneously. If a task spans multiple skills, execute them sequentially, completing one before loading the next.

---

## 5. Auto-Handoff Protocol (Context Exhaustion Prevention)

When the conversation becomes long, proactively manage context:

### Warning Threshold (~60% window consumed)
```
⚠️ Context Budget Warning: Approaching 60% capacity.
   Remaining effective working memory: ~30K tokens.
   Action: Will begin summarizing older tool outputs.
```

### Critical Threshold (~80% window consumed)
```
🛑 Context Budget Critical: 80% capacity reached.
   Initiating Handoff Protocol:
   1. Writing latest_state.json (structured state)
   2. Writing latest_memo.md (prose context)
   3. Updating SSDLC_TRACKER.md
   4. Recommending: Close this session, run `$pm continue`
```

### Hard Stop (~90% window consumed)
The agent MUST stop all implementation work and produce a handoff memo. Continuing past this point risks output quality degradation and hallucination.

---

## 6. Context Tracking in Handoffs

Every `AGENT_HANDOFF.md` and `latest_state.json` SHOULD include:

```yaml
context_metrics:
  estimated_turns_used: 18
  estimated_tokens_consumed: "~45K"
  context_health: "green"  # green | yellow | red
  handoff_reason: "gate_reached"  # gate_reached | context_exhaustion | task_complete | error
```

This allows the receiving agent to understand whether the handoff was planned (gate) or forced (exhaustion).

---

*Derived from: Harness Engineering Guide — Context Engineering, Memory & Context*
