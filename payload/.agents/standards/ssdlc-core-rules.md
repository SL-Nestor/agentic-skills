# SSDLC Core Standards & Constraints

## 0.6 Production Target Enforcement
For `production-target`, you MUST enforce:
1. **No Test Doubles as Final Runtime**: Replaced before Gate D.
2. **Real Persistence**: A production-grade relational database as defined by the project's `tech-profile` or PRD (e.g., Azure SQL, PostgreSQL, MySQL). SQLite is acceptable ONLY for local test execution.
3. **Real Upstream Path**: Adapters for all named external dependencies listed in the Source Intent Inventory.
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
2. **Paved Road Principle (SDK-First)**: For Observability, Auth, or Database access, always prefer using the company's official shared SDKs or Middleware over implementing custom raw logic.
3. **Strict Dependency Injection**: Inject via Constructor. No `new` for infrastructure.
4. **Small Modules & SRP**: No God classes. Over 3 dependencies -> split.
5. **Immutability First**: Use C# `record` for DTOs.
6. **Fail-Fast & Defensive**: `#nullable enable` and input validation.

## 2. Git Branching & CI Boundaries
The AI MUST automatically create and checkout a new branch before writing any code (Phase 5). Commits to `main` are strictly forbidden.
- **Enterprise / Agile Models**: `feature/{module_id}-{short-desc}`
- **Hotfix / Legacy Models**: `fix/{module_id}-{issue-desc}`
- **Lightweight Models**: `chore/{short-desc}` or `script/{short-desc}`
- **Commits**: Must follow Conventional Commits (`feat:`, `fix:`, `test:`, `docs:`, `chore:`).
- **PR Draft**: In Phase 9-10 (Ship), you must push the branch to origin and generate a Markdown Pull Request description (including testing evidence) for the user to submit.

## 3. New Dependency Gate (Supply Chain Safety)
Before introducing ANY new third-party package (NuGet, NPM, etc.), you MUST:
1. **License Check**: Verify the license is compatible (MIT, Apache-2.0 are safe; GPL requires escalation).
2. **Maintenance Check**: Last publish date < 12 months, open issues are triaged, no known CVEs.
3. **Minimality Check**: Can the same outcome be achieved with existing dependencies or stdlib?
4. If any check fails, STOP and escalate to the PM before adding the dependency.

## 4. Destructive Migration Protocol (Data Safety)
When a database schema change involves **dropping columns, renaming tables, or changing data types** on entities with existing production data:
1. **Multi-Phase Migration**: Split into (a) Add new column → (b) Backfill data → (c) Switch code → (d) Drop old column. Never do (a) and (d) in the same migration.
2. **Backward Compatibility Window**: The old column/API must remain functional for at least one deployment cycle.
3. **Explicit PM Approval**: Destructive migrations require written PM sign-off in the Tracker before execution.
