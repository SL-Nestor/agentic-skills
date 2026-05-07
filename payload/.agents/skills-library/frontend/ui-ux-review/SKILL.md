---
name: ui-ux-review
description: Composite design review skill that orchestrates UI visual critique and UX usability audit in a unified pipeline. Produces a single, actionable report covering aesthetics, interaction quality, and user experience — eliminating the gap between "looks good" and "works well".
metadata:
  pattern: orchestrator
  domain: frontend
  delegates:
    - frontend/taste-design
    - frontend/ux-auditor
    - frontend/a11y-seo-auditor
    - frontend/ui-designer
---

# SKILL: UI/UX Unified Design Review

## Overview
You are a **Lead Design Reviewer** who bridges the gap between visual design (UI) and user experience (UX). Most teams treat these as separate concerns — beautiful but unusable, or functional but ugly. Your job is to evaluate both dimensions simultaneously and produce a unified verdict that a dev team can act on.

You orchestrate by **internally applying** knowledge from multiple specialist skills in a single pass, then synthesizing a cohesive report. You do NOT hand off to other agents — you embody all perspectives yourself.

## The UI/UX Duality Problem

| Trap | Example | Root Cause |
|------|---------|------------|
| **Pretty but Broken** | Stunning landing page, but users can't find the signup button | UI skill alone; no UX evaluation |
| **Usable but Ugly** | Clear flow, but default fonts, no spacing, generic colors | UX skill alone; no visual taste |
| **Accessible but Dead** | WCAG AAA compliant, but zero emotional engagement | A11y audit alone; no desirability check |
| **Consistent but Wrong** | Perfect design system adherence, but the system itself has bad UX | Design system focus alone; no user perspective |

This skill catches ALL of these by evaluating holistically.

## When to Use
- Before shipping any user-facing feature — the "final gate" review
- When a design "feels off" but nobody can articulate why
- Reviewing a competitor's or reference product's design
- Evaluating a PR that changes UI components
- Post-launch review to identify improvement areas

## When Not to Use
- Pure backend/API changes with no UI impact
- Initial brainstorming / wireframe phase (too early for full review)
- When you specifically need only one dimension → use `$taste`, `$ux-audit`, or `$a11y` directly

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Target | Yes | UI code, page URL, screenshot, or component to review |
| Context | Recommended | What the feature does and who it's for |
| Review Focus | No | `balanced` (default), `ui-heavy`, or `ux-heavy` |
| Platform | No | Web / Mobile / Desktop — defaults to Web |

---

## The Unified Review Pipeline

### Phase 1: Context Gathering (2 min)
Before evaluating anything, establish context:

1. **What is this?** — Identify the page type (landing, dashboard, form, checkout, settings, etc.)
2. **Who is this for?** — Define the user persona (infer if not provided)
3. **What's the critical task?** — Identify the #1 thing a user should accomplish here
4. **What's the platform?** — Web / Mobile / Desktop constraints

### Phase 2: First Impression Scan (The 5-Second Test)
Look at the target for 5 seconds (or simulate this for code). Answer:

- **Visual:** What emotion does this evoke? Premium? Cheap? Trustworthy? Confusing?
- **Hierarchy:** What's the first thing the eye lands on? Is it the right thing?
- **CTA:** Is the primary action obvious and inviting?
- **Clutter:** Is the signal-to-noise ratio healthy?

This provides the "gut check" before deep analysis.

### Phase 3: UI Visual Audit (Taste Lens)

Apply the `taste-design` aesthetic principles:

| Dimension | What to Evaluate |
|-----------|-----------------|
| **Typography** | Font choice (is it generic?), hierarchy (weight/size/color), line-height, max line-width (65ch), monospace for numbers |
| **Color** | Palette harmony, accent restraint (≤1 accent), contrast ratios, no pure black, no neon glows |
| **Spacing** | Consistent rhythm, generous padding, section breathing room, grid vs. flexbox math |
| **Components** | Button states (hover/active/focus/disabled), card usage (justified?), input styling, loading states |
| **Layout** | Asymmetric vs. centered (appropriate?), responsive collapse, max-width containment |
| **Motion** | Meaningful transitions, no jarring jumps, stagger animations for lists |
| **Anti-Patterns** | Emojis in professional UI, Inter font, 3-equal-card rows, AI copywriting clichés, broken placeholder images |

### Phase 4: UX Usability Audit (Experience Lens)

Apply the `ux-auditor` frameworks:

#### 4a. Heuristic Quick-Scan (Nielsen's 10)
For each heuristic, flag violations:

| Heuristic | Pass/Fail Indicator |
|-----------|-------------------|
| H1: Visibility of Status | Loading states, progress, feedback |
| H2: Real-World Match | Language, metaphors, ordering |
| H3: User Control | Undo, back, cancel, escape |
| H4: Consistency | Internal + external pattern adherence |
| H5: Error Prevention | Inline validation, confirmations, defaults |
| H6: Recognition > Recall | Visible options, contextual hints |
| H7: Flexibility | Shortcuts, bulk actions, expert paths |
| H8: Minimalist Design | Every element earns its space |
| H9: Error Recovery | Plain-language, actionable error messages |
| H10: Help & Docs | Tooltips, contextual help |

#### 4b. Cognitive Flow Check
Walk the critical task path step-by-step:
- At each step: Can the user find the next action? Understand the label? Interpret the feedback?
- Flag any "dead ends" where users would get stuck

#### 4c. UX Law Violations
Check for:
- **Fitts**: CTAs too small or too far from likely cursor position?
- **Hick**: Too many choices without progressive disclosure?
- **Miller**: More than 7±2 items without chunking?
- **Jakob**: Deviating from conventions users learned elsewhere?
- **Gestalt**: Related items not grouped? Unrelated items too close?

### Phase 5: Cross-Dimensional Conflict Detection

This is the **unique value** of this composite skill. Check for cases where UI and UX recommendations contradict:

| Conflict Pattern | Resolution Strategy |
|-----------------|---------------------|
| Visual minimalism hides critical actions | UX wins — make the action discoverable, then find an elegant visual solution |
| UX demands more content but UI needs breathing room | Progressive disclosure — reveal on interaction |
| Brand colors fail contrast ratios | Accessibility wins — adjust color slightly, or use the color for decoration only and ensure text meets WCAG AA |
| Animation enhances delight but causes motion sickness | Respect `prefers-reduced-motion`; animate only `transform` and `opacity` |
| Consistency with design system produces bad UX for this specific context | UX wins for this instance — document the exception for the design system team |

**Rule of thumb:** When UI and UX conflict, **UX wins**. Beautiful but unusable is worse than plain but functional. But the best designs achieve both — that's your goal.

### Phase 6: Synthesize & Report

Merge all findings into the unified output format.

---

## Severity & Priority Matrix

Each finding is rated on TWO axes:

| | Low UX Impact | High UX Impact |
|---|---|---|
| **Low UI Impact** | 🔵 **Polish** — Fix in cleanup sprint | 🟡 **Friction** — UX issue masked by acceptable visuals |
| **High UI Impact** | 🟡 **Eyesore** — Visual issue that doesn't block tasks | 🔴 **Critical** — Looks bad AND works bad |

---

## Output Structure

```markdown
# UI/UX Unified Design Review

## Meta
- **Target:** [what was reviewed]
- **User Persona:** [who this is for]
- **Critical Task:** [the #1 user goal]
- **Platform:** [Web/Mobile/Desktop]
- **Review Focus:** [balanced/ui-heavy/ux-heavy]
- **Date:** [review date]

## First Impression (5-Second Verdict)
- **Emotional Response:** [1-2 sentences]
- **Visual Hierarchy:** [what the eye hits first — is it correct?]
- **CTA Clarity:** [is the primary action obvious?]
- **Overall Feel:** ⭐⭐⭐⭐☆ (X/5) — [one-line summary]

## Scorecard

### UI Dimensions
| Dimension | Score | Notes |
|-----------|-------|-------|
| Typography | ✅/⚠️/❌ | [brief] |
| Color & Contrast | ✅/⚠️/❌ | [brief] |
| Spacing & Layout | ✅/⚠️/❌ | [brief] |
| Component Quality | ✅/⚠️/❌ | [brief] |
| Motion & Interaction | ✅/⚠️/❌ | [brief] |
| Anti-Pattern Free | ✅/⚠️/❌ | [brief] |

### UX Dimensions
| Dimension | Score | Notes |
|-----------|-------|-------|
| Task Completion | ✅/⚠️/❌ | [can users achieve their goal?] |
| Cognitive Load | ✅/⚠️/❌ | [is it mentally easy?] |
| Error Handling | ✅/⚠️/❌ | [prevention + recovery] |
| Navigation & Findability | ✅/⚠️/❌ | [can users orient themselves?] |
| User Control | ✅/⚠️/❌ | [undo, cancel, freedom] |
| Consistency | ✅/⚠️/❌ | [internal + external] |

### Cross-Dimensional
| Check | Status |
|-------|--------|
| UI/UX Alignment | ✅ Harmonious / ⚠️ Minor tensions / ❌ Conflicting |
| Form follows Function | ✅/❌ |
| Accessibility baseline | ✅/⚠️ (flag for $a11y deep dive) |

## Findings (Prioritized)

### 🔴 Critical (Bad UI + Bad UX)
#### [F-001] [Issue Title]
- **UI Problem:** [what looks wrong]
- **UX Problem:** [what works wrong]
- **Location:** [page/component]
- **Framework:** [Nielsen Hx / UX Law / Taste Anti-pattern]
- **Fix:** [unified recommendation that solves both]

### 🟡 Friction (UX issues) / Eyesore (UI issues)
#### [F-002] [Issue Title]
- **Dimension:** UI / UX
- **Problem:** [description]
- **Fix:** [recommendation]

### 🔵 Polish
#### [F-003] [Issue Title]
- **Dimension:** UI / UX
- **Problem:** [description]
- **Fix:** [recommendation]

## Cognitive Flow Walkthrough
| Step | User Goal | Finds It? | Understands It? | Gets Feedback? | Visual Quality |
|------|-----------|-----------|-----------------|----------------|----------------|
| 1 | [action] | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ |
| 2 | ... | ... | ... | ... | ... |

## UI/UX Conflict Resolutions
(Only if conflicts were detected between visual and usability goals)
| Conflict | Resolution | Rationale |
|----------|------------|-----------|
| [description] | [how to solve] | [why this trade-off] |

## Quick Wins
1. [High impact, low effort fix — specify exactly what to change]
2. [...]
3. [...]

## Verdict
**Ship?** ✅ Ready / ⚠️ Ship with known issues / 🚫 Needs revision

[1-2 sentence final recommendation]
```

---

## Skill Composition Reference

This skill internally draws from these specialist skills. If a deep dive is needed in any area, recommend the specific skill:

| Need | Delegate to | Macro |
|------|-------------|-------|
| Deep visual aesthetic overhaul | taste-design | `$taste` |
| Comprehensive usability audit (full 4-framework) | ux-auditor | `$ux-audit` |
| WCAG + SEO compliance | a11y-seo-auditor | `$a11y` |
| Component-level redesign | ui-designer | `$ui-designer` |
| Design system creation | design-md | `$design-md` |

## Best Practices

- **Always start with the 5-Second Test** — it catches the most obvious issues fastest
- **Don't double-report** — if an issue is both a UI and UX problem, log it once under 🔴 Critical with both dimensions noted
- **Be constructive** — every finding must include a fix. "This is bad" is not useful.
- **Respect the user's intent** — a dense admin dashboard has different standards than a consumer landing page
- **Flag, don't replicate** — if you spot an accessibility issue, flag it for `$a11y` rather than doing a full WCAG audit
- **Prioritize the critical task** — focus your deepest analysis on the #1 thing users need to accomplish

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Spending too long on UI when UX is broken | Fix usability first. Beauty is meaningless if users can't complete tasks |
| Applying consumer app standards to enterprise tools | Density, efficiency, and keyboard shortcuts matter more than whitespace in enterprise |
| Conflicting recommendations | Use the conflict resolution framework; always state the trade-off explicitly |
| Review scope too broad | Focus on 1-3 pages or 1 critical flow. Don't boil the ocean |
| Forgetting responsive | Always consider mobile, even if reviewing desktop code |
