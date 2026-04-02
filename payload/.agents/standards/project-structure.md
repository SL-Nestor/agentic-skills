---
title: Project Folder Structure & Backend Architecture
status: Active
scope: global
version: 1.1
---

# Project Structure & Backend Architecture Standard
> **Language Policy Compliance**: 
> - [English]: AI Core Directives & constraints for parsing precision. 
> - [正體中文]: Explanations and context for human developers.

---

## 1. Root Directory Structure (全域專案基礎目錄結構)

**[AI DIRECTIVE]** 
All new projects initialized via `SSDLC Autopilot` MUST strictly conform to the following directory structure. `/start-ssdlc` MUST automatically search for `docs/plan.md`, `docs/tasks.md`, and `docs/acceptance.md` if not explicitly provided.

**[給人類開發者的說明]**
這確保了專案在無論前後端，都能有一致的進入點與 AI 可以自動辨識的文件區塊。

```text
/Project_Root
 ├── .agents/                 # AI 的大腦、技能與架構標準規範 (不可更動)
 ├── docs/                    # 開發文件集中區 (強制約定)
 │   ├── specs/               # 需求規格書、PRD 等
 │   ├── plan.md              # [約定] 預設開發計畫
 │   ├── tasks.md             # [約定] 預設開發任務書
 │   └── acceptance.md        # [約定] 預設驗收標準
 ├── src/                     # 原始碼主目錄
 │   ├── Backend/             # (如有) 後端方案目錄 (Vertical Slice Architecture)
 │   └── Frontend/            # (如有) 前端專案目錄 (Vite 或 Next.js)
 ├── tests/                   # 自動化測試程式碼 (單元/整合/E2E)
 ├── 測試紀錄/                # QA 人工/自動化 查核報告與截圖匯出區 (由 $test-auditor 產出)
 ├── .gitignore
 ├── README.md                # 專案入口文件
 └── SSDLC_TRACKER.md         # AI 自動產生的開發狀態追蹤器
```

---

## 2. Backend Architecture: Vertical Slice Architecture (後端垂直切片架構)

**[AI DIRECTIVE]**
When writing backend code (C# / .NET), you MUST use **Vertical Slice Architecture (VSA)** mixed with Lite-DDD. 
You MUST group files by "Feature" (e.g., `src/Backend/Features/Orders/CreateOrder/`) instead of technical layers (e.g., `Controllers/`, `Services/`). Every feature folder MUST contain its own API Endpoint, Command/Query object, and Validator.

**[給人類開發者的說明]**
我們捨棄傳統的 N 層架構 (Controller/Service/Repo 分層)，改用垂直切片架構，將一個 API 功能 (如：修改密碼) 完全收攏在同一個資料夾。這帶來了零耦合、易於被 CQRS 封裝、以及防呆治百病的極大優勢。

---

## 3. Core Architectural Philosophy (開發設計最高指導原則)

**[AI DIRECTIVE]**
All code design, implementation, and refactoring MUST strictly adhere to these four pillars:
1. **Minimal Modularity**: Strict Single Responsibility Principle. Components must be small and focused. No God Classes (>300 lines).
2. **Module Decoupling**: Modules must communicate via interfaces, ports, or events (e.g., MediatR). Never depend on concrete implementations.
3. **Testability First**: All external dependencies (DB, API, FileSystem, Time) must be hidden behind Port/Adapter interfaces. Business logic must be 100% unit-testable via Mocks/Fakes. Code without tests is rejected code.
4. **High Maintainability**: Code is for humans. Meaningful variable names, auto-generated Swagger docs, and Standard Envelopes are required. An onboarding agent/human must understand the logic within 5 minutes.

**[給人類開發者的說明]**
這四大準則 (最小模組、模組解耦、易於測試、提高維護效率) 已寫死進 AI 的系統約束中。只要程式碼無法用 Mock 獨立跑單元測試，或是出現幾百行的麵條代碼，AI 審查機制就會拒絕該產出。

---

## 4. Database Strategy & Migrations (資料庫分層與轉移策略)

**[AI DIRECTIVE]**
Database connections and implementations MUST dynamically enforce the following constraints based on the environment:
1. **Local Development**: Allowed to use `SQLite` or `Local SQL Server (LocalDB/Docker)`.
2. **Test/Stage Environment**: Allowed to use `SQLite` (stateless testing) or `Azure SQL Database`.
3. **Production Environment**: STRICTLY limited to `Azure SQL Database`. If a deployment script or `appsettings.Production.json` references SQLite or local DBs, you MUST halt and correct it immediately.
4. **Migrations & Seeding Requirement**: You MUST output and maintain database schema modification scripts (e.g., EF Core Migrations or SQL DDL). If a feature requires default tables/lookup values, you MUST include a "Data Seeding" script. Manual database configuration by human developers is forbidden.

**[給人類開發者的說明]**
為了兼顧開發效率與絕對的安全穩定，AI 已被限制在正式環境中「絕對只能」使用 Azure SQL Database，徹底杜絕了把 SQLite 推上正式站台的低級失誤。同時，AI 也被強制要求在開發每一個功能時，必須產出相對應的 Migration 與預設值 Seeding 腳本，實現跨環境的一鍵無縫佈署。
