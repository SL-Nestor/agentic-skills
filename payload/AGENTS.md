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

## Extended Skills Library (On-Demand Loading)

The following skills are NOT auto-loaded at startup to conserve your context budget.
When the user invokes a `$macro` that matches one of these, read the SKILL.md from the corresponding path in `.agents/skills-library/`.

### dotnet/ — .NET 開發與效能
| Macro | Path | Description |
|-------|------|-------------|
| `$dotnet-perf` | `dotnet/analyzing-dotnet-performance` | .NET 效能分析 |
| `$clr-debug` | `dotnet/clr-activation-debugging` | CLR 啟動問題診斷 |
| `$convert-cpm` | `dotnet/convert-to-cpm` | 轉換至 NuGet CPM |
| `$csharp-script` | `dotnet/csharp-scripts` | C# 腳本執行 |
| `$aot` | `dotnet/dotnet-aot-compat` | Native AOT 相容性 |
| `$maui-doctor` | `dotnet/dotnet-maui-doctor` | MAUI 環境診斷 |
| `$pinvoke` | `dotnet/dotnet-pinvoke` | P/Invoke 互操作 |
| `$dotnet-trace` | `dotnet/dotnet-trace-collect` | 效能追蹤採集 |
| `$dump` | `dotnet/dump-collect` | Crash dump 採集 |
| `$simd` | `dotnet/exp-simd-vectorization` | SIMD 向量化最佳化 |
| `$test-maintain` | `dotnet/exp-test-maintainability` | 測試可維護性評估 |
| `$test-tag` | `dotnet/exp-test-tagging` | 測試標記分類 |
| `$benchmark` | `dotnet/microbenchmarking` | 微基準測試 |
| `$migrate-8to9` | `dotnet/migrate-dotnet8-to-dotnet9` | .NET 8→9 遷移 |
| `$migrate-9to10` | `dotnet/migrate-dotnet9-to-dotnet10` | .NET 9→10 遷移 |
| `$migrate-10to11` | `dotnet/migrate-dotnet10-to-dotnet11` | .NET 10→11 遷移 |
| `$migrate-mstest-v3` | `dotnet/migrate-mstest-v1v2-to-v3` | MSTest v1/v2→v3 |
| `$migrate-mstest-v4` | `dotnet/migrate-mstest-v3-to-v4` | MSTest v3→v4 |
| `$nullable` | `dotnet/migrate-nullable-references` | Nullable 參考遷移 |
| `$migrate-mtp` | `dotnet/migrate-vstest-to-mtp` | VSTest→MTP 遷移 |
| `$ef-optimize` | `dotnet/optimizing-ef-core-queries` | EF Core 查詢最佳化 |
| `$run-tests` | `dotnet/run-tests` | 執行測試 |
| `$test-antipattern` | `dotnet/test-anti-patterns` | 測試反模式偵測 |
| `$test-audit` | `dotnet/test-auditor` | 測試審計 |
| `$mstest-write` | `dotnet/writing-mstest-tests` | 撰寫 MSTest 測試 |
| `$thread-abort` | `dotnet/thread-abort-migration` | Thread.Abort 遷移 |

### build/ — 建構與 MSBuild
| Macro | Path | Description |
|-------|------|-------------|
| `$binlog-fail` | `build/binlog-failure-analysis` | Binlog 失敗分析 |
| `$binlog-gen` | `build/binlog-generation` | Binlog 產生 |
| `$build-parallel` | `build/build-parallelism` | 建構平行化 |
| `$build-baseline` | `build/build-perf-baseline` | 建構效能基準 |
| `$build-diag` | `build/build-perf-diagnostics` | 建構效能診斷 |
| `$bin-clash` | `build/check-bin-obj-clash` | Bin/Obj 衝突檢查 |
| `$dir-build` | `build/directory-build-organization` | Directory.Build 組織 |
| `$eval-perf` | `build/eval-performance` | MSBuild 評估效能 |
| `$incr-build` | `build/incremental-build` | 增量建構 |
| `$msbuild-anti` | `build/msbuild-antipatterns` | MSBuild 反模式 |
| `$msbuild-modern` | `build/msbuild-modernization` | MSBuild 現代化 |
| `$msbuild-server` | `build/msbuild-server` | MSBuild Server |

### frontend/ — 前端開發與設計
| Macro | Path | Description |
|-------|------|-------------|
| `$a11y` | `frontend/a11y-seo-auditor` | 無障礙/SEO 審計 |
| `$copilotkit` | `frontend/copilotkit-dev` | CopilotKit 開發 |
| `$design-md` | `frontend/design-md` | Design System 文件 |
| `$enhance-prompt` | `frontend/enhance-prompt` | UI Prompt 增強 |
| `$react` | `frontend/react-components` | React 元件開發 |
| `$remotion` | `frontend/remotion` | Remotion 影片開發 |
| `$shadcn` | `frontend/shadcn-ui` | shadcn/ui 整合 |
| `$stitch-design` | `frontend/stitch-design` | Stitch 設計系統 |
| `$stitch-loop` | `frontend/stitch-loop` | Stitch 迭代迴圈 |
| `$taste` | `frontend/taste-design` | 設計品味評估 |
| `$ui-designer` | `frontend/ui-designer` | UI 設計師模式 |

### platform/ — 平台與整合
| Macro | Path | Description |
|-------|------|-------------|
| `$ai-int` | `platform/ai-integration` | AI 模型整合 |
| `$tombstone` | `platform/android-tombstone-symbolication` | Android Tombstone |
| `$cicd` | `platform/cicd-builder` | CI/CD Pipeline |
| `$gemini-dev` | `platform/gemini-api-dev` | Gemini API 開發 |
| `$i18n` | `platform/i18n-agent` | 國際化 |
| `$mcp-create` | `platform/mcp-csharp-create` | MCP Server 建立 |
| `$mcp-debug` | `platform/mcp-csharp-debug` | MCP Server 除錯 |
| `$mcp-publish` | `platform/mcp-csharp-publish` | MCP Server 發佈 |
| `$mcp-test` | `platform/mcp-csharp-test` | MCP Server 測試 |
| `$mcp-dev` | `platform/mcp-dev` | MCP 開發框架 |

### meta/ — 元技能與工具
| Macro | Path | Description |
|-------|------|-------------|
| `$api-doc` | `meta/api-documenter` | API 文件產生 |
| `$create-agent` | `meta/create-custom-agent` | 建立自訂 Agent |
| `$create-skill` | `meta/create-skill` | 建立新技能 |
| `$create-test` | `meta/create-skill-test` | 建立技能測試 |
| `$crap` | `meta/crap-score` | CRAP 分數計算 |
| `$init-enterprise` | `meta/init-enterprise-repo` | 初始化企業 Repo |
| `$meta` | `meta/meta-skill` | 元技能管理 |
| `$nuget-publish` | `meta/nuget-trusted-publishing` | NuGet 受信發佈 |
| `$resolve-ref` | `meta/resolve-project-references` | 專案參照解析 |
| `$threat-model` | `meta/ssdlc-threat-modeling` | SSDLC 威脅建模 |
| `$stack-advisor` | `meta/stack-advisor` | 技術棧建議 |
| `$tech-select` | `meta/technology-selection` | 技術選型 |
| `$tpl-author` | `meta/template-authoring` | 範本撰寫 |
| `$tpl-discover` | `meta/template-discovery` | 範本探索 |
| `$tpl-init` | `meta/template-instantiation` | 範本實例化 |
| `$gen-files` | `meta/including-generated-files` | 產生檔案管理 |
| `$hot-reload` | `meta/mtp-hot-reload` | MTP Hot Reload |
