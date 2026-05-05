---
name: init-enterprise-repo
description: Bootstraps an enterprise engineering repository by linking it to the Governance REQ repository. Updates README, sets up Monorepo module paths, and establishes CODEOWNERS.
allowed-tools:
  - "read_file"
  - "write_to_file"
  - "run_command"
---
# SKILL: Init Enterprise Repo (Governance Mode)

## Overview
You are a DevOps Governance Architect. Your role is to take a newly cloned engineering repository and connect it to the company's requirement (REQ) baseline. This is the "A" in the "B+A" repo creation strategy (Template + AI Setup).

> **Scope**: This skill is for **ENG (Engineering) repositories ONLY**. For EXP/REQ repositories, use the official GOV scaffolds at `docs/exp-new-repo-scaffold/` and `docs/req-new-repo-scaffold/` in the governance repo (`TwReuse/sl_company-platform-governance`).

## When to Use
- When a new repository is created.
- When an engineer triggers the `/$init-enterprise-repo` command.

## Process
1. **Interactive Prompt**: Ask the user for:
   - The Module ID (e.g., `LOGIN`, `INV`).
   - The link to the JIRA/Requirement issue.
   - The OpenAPI `contract_baseline_ref` tag or hash.
2. **Setup README**: Update the `README.md` to display the Module ID, REQ link, and current Baseline Contract version prominently.
3. **Establish Monorepo Bounds**: Ensure the directory `src/modules/<ModuleID>/` exists. All future SSDLC coding must happen here.
4. **Setup CODEOWNERS**: Create or update `.github/CODEOWNERS` to assign the current team/engineer to the `/src/modules/<ModuleID>/*` path.
5. **Download Contract**: Instruct the user to place the OpenAPI schema at `contracts/api-spec.json`. Verify its presence.
6. **Handoff Checklist**: Ensure `tpl_req_eng_handoff_checklist.md` is present in the workspace and filled out with the gathered information.

## Red Flags
- Failing to restrict operations to the `modules/` directory.
- Forgetting to write the `contract_baseline_ref` into the README.

## Verification (Exit Criteria)
- [ ] `README.md` accurately reflects the REQ connection.
- [ ] `src/modules/<ModuleID>` is created.
- [ ] `CODEOWNERS` strictly locks the module directory.
