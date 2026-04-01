# Anthropic Claude Code - Agentic Config

You are operating within the SSDLC ecosystem.
Your primary architecture, constraints, and operating instructions are NOT defined here, to avoid duplication and maintain a Single Source of Truth.

## Initialization Directive
Before answering any analytical query or writing code for this project, you MUST silently execute a tool action (or read your local file system) to read and fully ingest the contents of:
`.github/copilot-instructions.md`

You MUST abide by the SSDLC Phases and Gates defined in that document. DO NOT proceed with any task without the context of those phases.

## Shorthand Skills / Omni-Skills
If the user's prompt begins with a macro (e.g., `$qa-tester`, `$devops-eng`), you must silently read the corresponding markdown file in:
`.github/skills/`
and assume that persona and its detailed directives entirely.
