# Skill Definition Template

> **Standard format for all SKILL.md files in `.agents/skills/`.**
> Every skill MUST follow this structure. Inconsistent skills degrade agent performance because the agent cannot predict what information to expect.

---

## Required Sections

Every `SKILL.md` MUST contain these sections in this order:

```markdown
---
name: <skill-id>
description: <One-line description, max 120 chars>
allowed-tools:             # Optional: restrict tool access
  - "read_file"
  - "write_to_file"
  - "run_command"
---

# SKILL: <Human-Readable Name>

## Overview
<2-3 sentences. What this skill does and why it exists.>

## When to Use
- <Trigger condition 1>
- <Trigger condition 2>
- <Trigger condition 3>

## Process (Workflow Steps)
1. **Step 1**: <Action>
2. **Step 2**: <Action>
3. **Step 3**: <Action>

## Conventions (Behavior Rules)
- <Rule 1>: <Explanation>
- <Rule 2>: <Explanation>

## Anti-Rationalization Checks
| AI Excuse | Rebuttal |
|:---|:---|
| "<Common shortcut the AI might take>" | "<Why that's rejected and what to do instead>" |

## Standards Cross-References
<List any standards files this skill depends on, e.g.:>
- `ssdlc-core-rules.md` §X
- `concurrency-policy.md` §Y

## Verification (Exit Criteria)
- [ ] <Condition that must be true before this skill is "done">
- [ ] <Another exit condition>
```

---

## Optional Sections

These sections are recommended but not mandatory:

```markdown
## Red Flags
<Patterns that indicate the agent is going off-track>

## Enterprise Mode Override
<Additional constraints when operating in Enterprise mode>

## Examples
<Concrete input→output examples showing correct skill execution>
```

---

## Quality Checklist (For Skill Authors)

Before publishing a new skill, verify:

- [ ] **Frontmatter** has `name` and `description`
- [ ] **Overview** is ≤3 sentences
- [ ] **When to Use** has ≥2 trigger conditions
- [ ] **Process** has numbered steps (not paragraphs)
- [ ] **Anti-Rationalization** has ≥2 entries
- [ ] **Verification** has ≥2 exit criteria as checkboxes
- [ ] **Total size** is ≤ 2,000 tokens (~6KB). If larger, split into sub-skills
- [ ] **No duplicate coverage** — check `_SKILL_MENU.md` for overlapping skills

---

*Template version: 1.0 — Derived from Harness Engineering Guide Skill System*
