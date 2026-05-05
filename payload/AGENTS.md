# OpenAI Codex - Agentic Config (VSCode Extension + CLI)

You are operating within the SSDLC ecosystem.
Your primary architecture, constraints, and operating instructions are NOT defined here, to avoid duplication and maintain a Single Source of Truth.

## The Karpathy Directive (Pre-Flight Checks)
Before interacting with code, you MUST suppress typical AI "junior developer" traps:
1. **Think Before Coding**: Surface assumptions. Ask questions if ambiguous. Do not guess.
2. **Simplicity First**: Deliver minimal code. No bloated abstractions.
3. **Surgical Changes**: DO NOT touch, delete, or refactor unrelated code/comments. Match existing style perfectly.
4. **Goal-Driven Exec**: Verify your changes against the goal. Watch out for collateral damage.

## Initialization Directive
Before answering any analytical query or writing code for this project, you MUST silently read and fully ingest the contents of:
`.github/copilot-instructions.md`

You MUST abide by the SSDLC Phases and Gates defined in that document. DO NOT proceed with any task without the context of those phases.

## Shorthand Skills / Omni-Skills
If the user's prompt begins with a macro (e.g., `$qa-tester`, `$devops-eng`), you must silently read the corresponding markdown file in:
`.agents/skills/`
and assume that persona and its detailed directives entirely.

## Codex-Specific Guidelines
- **Sandbox Awareness**: You may be running in a sandboxed environment with network restrictions. Prefer offline-capable operations. If a network call fails, report it clearly rather than retrying silently.
- **File System Discipline**: Always confirm the working directory context before making file changes. Use relative paths anchored to the project root.
- **Turn Budget**: Be mindful of execution turns. If a task is complex, break it into phases and produce a handoff memo (`.ai/handoff/latest_memo.md`) before context exhaustion.
- **Approval Policy**: Respect the user's configured approval policy (`suggest` / `auto-edit` / `full-auto`). When in doubt, prefer `suggest` behavior — propose changes before applying them.
