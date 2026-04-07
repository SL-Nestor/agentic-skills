# SSDLC Core Standards & Constraints

## 0.6 Production Target Enforcement
For `production-target`, you MUST enforce:
1. **No Test Doubles as Final Runtime**: Replaced before Gate D.
2. **Real Persistence**: Azure SQL Database required (SQLite for test only).
3. **Real Upstream Path**: Adapters for UBQ, PCM, LIC, BIL, NTF, IdP.
4. **Security Middleware**: Real auth/authz required.
5. **Operational Readiness**: Environment variables, telemetry, health probes.
6. **Workflow Shape ≠ Production**: UI mockups are not production ready.

## 0.6.1 Interpretation Drift Prevention
Preserve approved source intent across plan, implementation, and deployment. Do not silently generalize.

## 0.6.3 Controlled Status Vocabulary
Describe completeness using EXACTLY these terms:
`implemented-live` | `implemented-partially` | `simulated-only` | `validation-only` | `deferred-with-approval` | `blocked`

## 0.7 Development Mode Rules
- `backend`: Deliver HTTP API → App Service → Persistence seam. Use xUnit + Testcontainers.
- `frontend`: Deliver UI Component → API Call → Rendered Screen. Use Jest/Vitest + Playwright.
- `fullstack`: Both required. Requires Human UAT Gate.

## 1. Core Architectural Constraints
1. **Clean Architecture (SoC)**: API/UI must NEVER touch DbContext. Use Repositories.
2. **Strict Dependency Injection**: Inject via Constructor. No `new` for infrastructure.
3. **Small Modules & SRP**: No God classes. Over 3 dependencies -> split.
4. **Immutability First**: Use C# `record` for DTOs.
5. **Fail-Fast & Defensive**: `#nullable enable` and input validation.

## 2. Git Branching
- branches: `feature/{issue-number}-{short-desc}`
- commits: `feat:`, `fix:`, `test:`, `docs:` 
