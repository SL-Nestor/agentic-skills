# Error Handling Protocol (EHP) — Agent Resilience Standard

> Derived from [Harness Engineering Guide — Error Handling](https://harness-guide.com/guide/error-handling/).
> Prevents infinite loops, silent failures, and context waste from unrecoverable errors.

---

## 1. Turn Budget

Every agent session has a finite number of productive turns. A "turn" is one think→act→observe cycle.

| Context | Max Turns | Warning At | Action at Max |
|:---|:---:|:---:|:---|
| Skill execution (single task) | 25 | Turn 15 | Produce handoff memo, STOP |
| Full Phase execution | 40 | Turn 25 | Produce handoff memo, STOP |
| Light mode ($light) | 15 | Turn 10 | Produce summary, STOP |
| Tactical mode ($tactical) | 20 | Turn 12 | Produce TACTICAL_MEMO, STOP |

### Warning Output Format
```
⚠️ Turn Budget: [current]/[max] — Approaching limit.
   Prioritizing remaining work for clean handoff.
```

### Max Turn Output Format
```
🛑 Turn Budget Exhausted: [max]/[max]
   Producing handoff memo for session continuation.
   Incomplete work: [brief description of what remains]
```

**[AI DIRECTIVE]**: When the turn budget is exhausted, you MUST NOT continue implementation. You MUST produce a `latest_memo.md` and `latest_state.json` update, then advise the user to run `$pm continue`.

---

## 2. Loop Detection

An agent is "looping" when it repeats the same action without making progress. This wastes tokens and produces no value.

### Detection Rules

| Condition | Trigger | Action |
|:---|:---|:---|
| Same file edited 3× with same intent | Pattern match on edit descriptions | STOP + report |
| Same test failing after 3 fix attempts | Test output unchanged | STOP + escalate |
| Same tool called 3× with same arguments | Argument comparison | STOP + try alternative |
| Build error persists after 3 fix cycles | Error message unchanged | STOP + handoff |

### Loop Detection Output Format
```
🔄 Loop Detected: [action description] repeated [N] times without progress.
   Last attempt result: [brief result]
   
   Recommended next steps:
   1. [Alternative approach A]
   2. [Alternative approach B]
   3. Handoff to different agent/model for fresh perspective
```

**[AI DIRECTIVE]**: When a loop is detected, you MUST NOT attempt the same action a 4th time. Choose one of:
1. Try a fundamentally different approach
2. Produce a handoff memo and recommend model/agent switch
3. Ask the human developer for guidance

---

## 3. Tool Error Propagation

Tool failures must be visible to the agent, never silently swallowed.

### Rules
1. **Always surface errors**: When a tool call fails, report the full error message in your response
2. **No silent retries**: Do not retry a failed tool call without first analyzing the error
3. **2-strike rule**: If the same tool fails twice with the same error, do NOT retry. Seek an alternative tool or approach.

### Error Report Format
```
❌ Tool Error: [tool_name]
   Error: [error message]
   Attempt: [N]/2
   Next: [what you'll try instead]
```

---

## 4. Graceful Degradation Strategy

When an agent cannot complete its assigned task, it must fail gracefully rather than producing broken output.

### Degradation Hierarchy

```
Level 1: Retry with different approach
   └─ Same agent, different strategy
   
Level 2: Partial completion + handoff
   └─ Complete what you can, document remaining work
   
Level 3: Model switch recommendation
   └─ Recommend switching to a different AI model
   
Level 4: Human escalation
   └─ Clearly state what blocked you and ask the human
```

### Degradation Output Template
```
⚠️ Graceful Degradation — Level [N]

What was attempted:
- [attempt 1 and result]
- [attempt 2 and result]

What was completed:
- [completed item 1]
- [completed item 2]

What remains:
- [remaining item 1]
- [remaining item 2]

Recommended recovery:
- [specific recommendation]
```

---

## 5. Error Logging in Handoff Documents

Every `AGENT_HANDOFF.md` and `latest_state.json` MUST include an `error_log` section when errors occurred during the session.

### JSON Format (in `latest_state.json`)
```json
{
  "error_log": [
    {
      "turn": 8,
      "type": "tool_error",
      "tool": "run_command",
      "message": "dotnet build failed: CS1061 missing member",
      "resolution": "Added missing property to UserDto",
      "resolved": true
    },
    {
      "turn": 15,
      "type": "loop_detected",
      "action": "Fix EF migration error",
      "attempts": 3,
      "resolution": "Handed off — needs manual DB schema review",
      "resolved": false
    }
  ]
}
```

### Markdown Format (in `latest_memo.md` or `AGENT_HANDOFF.md`)
```markdown
## Errors Encountered This Session

| Turn | Type | Description | Resolved? |
|:---:|:---|:---|:---:|
| 8 | Tool Error | `dotnet build` CS1061 missing member | ✅ |
| 15 | Loop | EF migration error persisted after 3 attempts | ❌ |
```

---

## 6. The "Missing Capability" Principle

> From OpenAI's Harness Engineering philosophy: When a task fails, DO NOT just fix the immediate issue. ASK: "What capability did the agent lack that caused this failure?" FIX THE HARNESS to prevent the entire class of failure from recurring.

When an agent encounters a recurring failure pattern:
1. **Document the pattern** in the error log
2. **Propose a harness fix**: a new standard, a new skill, or a prompt update that would prevent this class of failure
3. **Tag the proposal**: `[HARNESS_FIX_PROPOSAL]` in the handoff memo

This shifts the team from "fixing bugs" to "fixing the system that produces bugs."

---

*Derived from: Harness Engineering Guide — Error Handling, Agentic Loop*
