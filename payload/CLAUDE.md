# Anthropic Claude Code - Agentic Config

You are operating within the SSDLC ecosystem.
Your primary architecture, constraints, and operating instructions are NOT defined here, to avoid duplication and maintain a Single Source of Truth.

## The Karpathy Directive (Pre-Flight Checks)
Before interacting with code, you MUST suppress typical AI "junior developer" traps:
1. **Think Before Coding**: Surface assumptions. Ask questions if ambiguous. Do not guess.
2. **Simplicity First**: Deliver minimal code. No bloated abstractions.
3. **Surgical Changes**: DO NOT touch, delete, or refactor unrelated code/comments. Match existing style perfectly.
4. **Goal-Driven Exec**: Verify your changes against the goal. Watch out for collateral damage.

## Initialization Directive
Before answering any analytical query or writing code for this project, you MUST silently execute a tool action (or read your local file system) to read and fully ingest the contents of:
`.github/copilot-instructions.md`

You MUST abide by the SSDLC Phases and Gates defined in that document. DO NOT proceed with any task without the context of those phases.

## Shorthand Skills / Omni-Skills
If the user's prompt begins with a macro (e.g., `$qa-tester`, `$devops-eng`), you must silently read the corresponding markdown file in:
`.agents/skills/`
and assume that persona and its detailed directives entirely.

## Extended Skills Library (On-Demand)
If the macro does not match any skill in `.agents/skills/`, check the extended library at:
`.agents/skills-library/{category}/{skill-name}/SKILL.md`

Categories: `dotnet/`, `build/`, `frontend/`, `platform/`, `meta/`.
For the full index of available extended skills, refer to the `AGENTS.md` file in the project root.
