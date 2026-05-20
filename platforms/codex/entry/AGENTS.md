# 🧬 SSDLC Autopilot — OpenAI Codex Platform (v8.0.0)

You are operating within the **SSDLC Autopilot** multi-agent ecosystem, Codex edition.
This file is automatically read by OpenAI Codex CLI as the project's agent configuration.

---

## ⚙️ Initialization Directive

Before answering any analytical query or writing any code in this project, you MUST silently read and fully ingest:

1. `.agents/standards/ssdlc-core-rules.md` — Core development rules and SSDLC phases
2. `.agents/standards/agent-network.md` — Multi-agent collaboration architecture

**Do NOT write any code or provide architecture advice without reading these files first.**

---

## 🤖 Agent Network — Role Definitions

This project uses an **18-agent pipeline** for secure software development. Each agent is invoked via a `$macro` command.

When the user invokes a macro (e.g., `$pm`, `$implementer`), you MUST:
1. Silently read the corresponding `.md` file from `.agents/agents/`
2. Fully adopt that agent's role, rules, and workflow
3. Ignore the `<!-- CODEX PLATFORM -->` metadata comment; execute the markdown body directly

### Agent Registry — Core Pipeline

| # | Macro | File | Role | Recommended Model |
|---|-------|------|------|-------------------|
| 0 | `$pm` | `00-pm.md` | 🎯 Team Coordinator — entry point, routes tasks | o3 |
| 0a | `$ux-analyst` | `09-ux-analyst.md` | 🎨 UX Researcher — Persona + User Journey | o3 |
| 1 | `$req-analyst` | `01-requirement-analyst.md` | 📋 Requirement Analyst — fuzzy input → structured spec | o3 |
| 2 | `$spec-architect` | `02-spec-architect.md` | 🏗️ Spec Architect — spec → architecture + task list | o3 |
| 2a | `$data-modeler` | `10-data-modeler.md` | 🗄️ Data Modeler — ERD + Schema + Migration | ⭐ o4-mini |
| 2b | `$api-designer` | `11-api-designer.md` | 🔌 API Designer — OpenAPI contract + versioning | o3 |
| 3 | `$threat-modeler` | `03-threat-modeler.md` | 🛡️ Threat Modeler — STRIDE security assessment | o3 |
| 3a | `$dependency-auditor` | `12-dependency-auditor.md` | 📦 Dependency Auditor — CVE scan + license check | ⭐ o4-mini |
| 4 | `$implementer` | `04-implementer.md` | 💻 Implementer — TDD-driven code implementation | ⭐ o4-mini / o3 |
| 5 | `$code-reviewer` | `05-code-reviewer.md` | 🔍 Code Reviewer — cross-model code review | o3 |
| 6 | `$test-engineer` | `06-test-engineer.md` | 🧪 Test Engineer — E2E + security negative tests | o4-mini / o3 |
| 6a | `$performance-engineer` | `13-performance-engineer.md` | ⚡ Performance Engineer — load test + bottleneck | o3 |
| 7 | `$security-gate` | `07-security-gate.md` | 🔒 Security Gate — final deployment gate | o3 |
| 7a | `$compliance-checker` | `14-compliance-checker.md` | ⚖️ Compliance Checker — GDPR / HIPAA / SOC2 | o3 |
| 8 | `$devops` | `08-devops.md` | 🚀 DevOps Engineer — CI/CD pipeline generation | ⭐ o4-mini / o3 |
| 9 | `$tech-writer` | `15-tech-writer.md` | 📝 Tech Writer — README + API Guide + Changelog | o3 |
| 10 | `$retrospective` | `16-retrospective.md` | 🔄 Retrospective — close feedback loop | o3 |

### On-demand Agent

| Macro | File | Trigger |
|-------|------|---------|
| `$incident-responder` | `omni-incident-responder.md` | 🚨 Production incidents — RCA + Post-mortem |

### Omni-Skills (tools, invoke anytime)

| Macro | Purpose |
|-------|---------|
| `$deep-interview` | 5-question requirement elicitation |
| `$ccg` | Three extreme architects debate a decision |
| `$ralph` | Silent TDD: red → green, no commentary |
| `$stack-advisor` | Tech stack selection with trade-off table |

---

## 🔁 Pipeline Flow

```
Entry Point: $pm [your task / spec path]

$enterprise mode (full 100% team):
  $ux-analyst → $req-analyst → $spec-architect → $data-modeler → $api-designer
  → $threat-modeler → $dependency-auditor → [Gate P]
  → $implementer → $code-reviewer → $test-engineer → $performance-engineer
  → $security-gate → $compliance-checker → [Gate D]
  → $devops → $tech-writer → $retrospective → $pm (next sprint)

$agile mode (streamlined):
  $req-analyst → $spec-architect → $threat-modeler → [Gate P]
  → $implementer → $code-reviewer → $test-engineer
  → $security-gate → [Gate D] → $devops → $retrospective

$light mode:
  $pm → $implementer (simplified, no full SSDLC tracker)

$tactical mode:
  $pm → $implementer (hotfix mode, load tactical-protocol)
```

### Human Gates (Mandatory Stops)

- **Gate P**: After `$spec-architect` completes — human must approve before `$implementer` starts
- **Gate D**: After `$security-gate` passes — human must approve before `$devops` starts

---

## ⚠️ Cross-Validation Strategy (Codex Platform)

Codex's strongest role is **implementation** (`$implementer`). For optimal cross-validation:

| Step | Best Platform | Why |
|------|--------------|-----|
| `$threat-modeler` | Gemini CLI | Independent security model perspective |
| `$code-reviewer` | Gemini CLI | Reviews code it didn't write |
| `$security-gate` | Claude | Cautious, audit-grade final review |
| `$implementer` | **Codex (this)** | o3/o4-mini excel at code generation |
| `$devops` | **Codex (this)** | Strong YAML/pipeline generation |

---

## 📁 File Reference Convention

All skill paths are relative to the project root:
- Skills: `.agents/skills/{skill-name}/SKILL.md`
- Standards: `.agents/standards/{file}.md`
- Templates: `.agents/templates/{file}.md`

---

## 🚀 Quick Start

```bash
# In your AI-assisted terminal, start with:
$pm [describe your task or paste spec path]

# Or invoke a specific skill directly:
$implementer TSK-001
$threat-modeler
$security-gate
```
