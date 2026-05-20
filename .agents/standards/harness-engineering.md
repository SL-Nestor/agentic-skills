# OpenAI Harness Engineering Standards (Agent-First Infrastructure)

Derived from OpenAI's "Harnessing Engineering" philosophy. This standard shifts the focus from "writing code" to "designing the environment (Harness)" for AI agents to build 10x faster.

## 1. The Harness Mindset
- **Engineer as Architect**: Your primary job is to design the Infrastructure, CI/CD, and Observability that allows AI agents to operate at scale.
- **Agent-First Design**: Tools and logs must be machine-readable. If an AI cannot "see" the error in a structured log, the harness is broken.

## 2. Missing Capability Principle (RCA for Agents)
When a task fails or a bug is introduced:
1. **DO NOT** just manually fix the code.
2. **ASK**: "What capability did the agent lack that caused this failure?"
3. **FIX THE HARNESS**: Add the missing tool, context, or validation rule to prevent the entire class of failure from recurring.

## 3. Machine-Readable Observability
- All system output (Logs, Metrics, Traces) must be structured (LogQL, PromQL) so that AI agents can reason about system health.
- **Application Readability**: UI components and backend traces must provide clear, semantic markers for automated validation.

## 4. Isolated Verification Environments
- Every task MUST execute in an isolated environment (e.g., dedicated worktrees, containers, or clean ephemeral DBs).
- The AI must autonomously spin up, validate, and tear down these environments to ensure zero cross-task contamination.

## 5. Depth-First Decomposition (Primitive Blocks)
Break every complex goal into primitive blocks:
- **Design Intent** (Spec)
- **Controlled Implementation** (Build)
- **Autonomous Peer Review** (The Ralph Loop)
- **High-Fidelity Validation** (Audit)

---
*Derived from: https://openai.com/index/harness-engineering/*
