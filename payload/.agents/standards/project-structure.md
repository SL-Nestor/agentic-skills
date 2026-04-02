---
title: Project Folder Structure & Backend Architecture
status: Active
scope: global
version: 1.0
---

# 專案目錄結構與後端分層架構標準 (Project Structure & Backend Architecture)

為了讓 AI 與工程團隊在多種開發模式下有一致且明確的依歸，所有由 `SSDLC Autopilot` 初啟動的專案，都應嚴格遵守以下的目錄結構與架構約定。

## 1. 全域專案基礎目錄結構 (Root Structure)

不管是前端、後端還是全端專案，根目錄應保持以下標準的結構：

```text
/Project_Root
 ├── .agents/                 # AI 的大腦、技能與架構標準規範 (不可更動)
 ├── docs/                    # 開發文件集中區 (強制約定)
 │   ├── specs/               # 需求規格書、PRD 等
 │   ├── plan.md              # [約定] 預設開發計畫
 │   ├── tasks.md             # [約定] 預設開發任務書
 │   └── acceptance.md        # [約定] 預設驗收標準
 ├── src/                     # 原始碼主目錄
 │   ├── Backend/             # (如有) 後端方案目錄 (見第2章)
 │   └── Frontend/            # (如有) 前端專案目錄 (Vite 或 Next.js)
 ├── tests/                   # 自動化測試程式碼 (單元/整合/E2E)
 ├── 測試紀錄/                # QA 人工/自動化 查核報告與截圖匯出區 (由 $test-auditor 產出)
 ├── .gitignore
 ├── README.md                # 專案入口文件
 └── SSDLC_TRACKER.md         # AI 自動產生的開發狀態追蹤器
```

> **重點**：`/start-ssdlc` 預設會在 `docs/` 底下尋找沒有明確指定的計畫與驗收標準檔案；若不存在，AI 將負責自動在該目錄生成。

---

## 2. 後端分層架構建議：垂直切片架構 (Vertical Slice Architecture)

傳統的「N 層架構 (分 Controller、Service、Repo 層)」容易造成為了改一個小功能，必須穿越 4 個不同目錄去改檔案的「過度跳躍問題」。
針對 .NET 專案，我們強烈建議改採 **垂直切片架構 (VSA) 混合精簡的領域驅動設計 (Lite-DDD)**。

### 核心概念：以「功能 (Feature)」為單位，而非以「技術分層」為單位

一個 API 功能 (如：修改密碼) 的所有 Request/Response 類別、驗證邏輯、業務邏輯與資料庫操作，應該全部收攏在同一個切片資料夾下。我們稱之為 **Feature 資料夾**。

### 後端 `/src/Backend` 目錄結構範例

```text
src/Backend/
 ├── ApiHost/                      # 啟動專案 (Program.cs, Middleware, appsettings)
 ├── Core/                         # 跨切片共用的核心基底
 │   ├── Exceptions/               # 系統共用自訂例外 (e.g. NotFoundException)
 │   ├── Interfaces/               # 共用外部服務介面 (IMailService)
 │   └── Domain/                   # (可選) 跨切片強關聯的貧血或充血模型實體
 ├── Infrastructure/               # 外部服務或 DB 的具體實作
 │   ├── Database/                 # DbContext, Migrations
 │   └── Providers/                # 第三方 API 實作 (Stripe provider, AWS S3)
 │
 └── Features/                     # 【最重要】依據業務情境切割的垂直切片區
     ├── Orders/
     │   ├── CreateOrder/          # 建立訂單功能 (包含 API Endpoint + Command + Validator)
     │   │   ├── CreateOrderEndpoint.cs
     │   │   ├── CreateOrderCommand.cs
     │   │   └── CreateOrderValidator.cs
     │   └── GetOrderById/         # 查詢單筆訂單
     └── Users/
         ├── RegisterUser/
         └── UpdateProfile/
```

### 為什麼這是一個好建議？
1. **開發極度收斂**：工程師或 AI 接到「修改『建立訂單』邏輯」的任務時，只需要打開 `Features/Orders/CreateOrder/` 資料夾，不需要跳轉到 `Controllers`、`Services` 和 `Repositories` 資料夾中迷失。
2. **與 CQRS 完美結合**：可以搭配 MediatR 實作 Command 與 Query 的職責分離。每一個資料夾就是一個獨立的 Use Case (使用案例)。
3. **低耦合防禦**：這保證了「修改 A 功能，絕對不會牽連並弄壞 B 功能」，因為每個 Feature 都是互相獨立的程式區塊。

> **AI 行為約束**：未來當 AI 負責撰寫後端 API 時，將優先參考本結構檔，建立特徵導向 (Feature-driven) 的 N-Tier 變體架構。

---

## 3. 開發設計的最高指導原則 (Core Architectural Philosophy)

無論是在進行模組切割、新功能建置或是重構，所有程式碼設計**必須且無條件**遵守以下四項最高準則：

1. **最小模組 (Minimal Modularity)**：
   單一類別或方法應保持極簡，嚴格遵從單一職責原則 (SRP)。每個元件只負責做一件事情並把它做好，拒絕出現超過 300 行的「神之類別 (God Class)」。
   
2. **模組解耦 (Module Decoupling)**：
   模組間禁止直接互相依賴具體實作，必須透過介面 (Interface) 或發佈-訂閱 (Pub/Sub、EventBus、MediatR) 進行溝通。這確保了可以單獨抽換或重構某個模組而不引發骨牌效應 (Ripple Effect)。

3. **易於測試 (Testability First)**：
   所有與外部環境 (DB、API、File System、時間) 接觸的節點，都必須隱藏在 Port/Adapter 介面之後。確保領域邏輯與業務邏輯可以在完全不需要外部依賴的情況下，只需 Mock/Fake 即可進行毫秒級的單元測試。不能寫單元測試的程式碼，視同未完成的程式碼。

4. **提高維護效率 (High Maintainability Efficiency)**：
   程式碼是用來給「人」讀的。強制要求有意義的變數命名、自動生成的 Swagger API 文件、以及清晰的回傳統一格式 (Standard Envelope)。當新進工程師 (或另外一個 AI Agent) 接手這個段落時，必須要在 5 分鐘內看懂其運作邏輯。

---

## 4. 資料庫部署與環境分層策略 (Database Strategy)

為了兼顧開發效率與生產環境的絕對穩定性，資料庫的連線與 provider 設定必須嚴格依據執行環境切換，不得偷吃步：

- **開發環境 (Local Development)**：
  允許使用 **SQLite** 或是 **Local SQL Server (LocalDB/Docker)**。由工程師根據該微服務的特性自行決定，以最快能在本機進行 Migration 與跑通測試為核心。
- **測試環境 (Test Environment / Stage)**：
  可以依據驗收需求，繼續使用 **SQLite** 進行無狀態快速測試，或者預先串接 **Azure SQL Database (測試執行個體)** 以執行更接近生產環境的整合性測試。
- **正式生產環境 (Production Environment)**：
  **嚴格限制僅能連線至 `Azure SQL Database`**。
  AI 在產出正式區部署腳本 (Deployment Guide) 或檢視 `appsettings.Production.json` 時，若發現使用 SQLite 或其他非 Azure SQL 的連線字串，必須立即提出警告並更正。嚴禁在 Production 中依賴檔案型資料庫。

- **資料庫轉移與部署腳本規範 (Migrations & Seeding)**：
  為了確保工程師可以隨時隨地從 SQLite 無縫切換至 Local SQL Server 抑或是 Azure SQL 進行測試，開發過程中 **必須持續產出與維護資料庫結構異動腳本 (如 EF Core Migrations 或純 SQL DDL/DML)**。
  若該功能有依賴預設的對照表資料 (Lookup Tables) 或系統初始值，**必須一併將「新增/修改的資料填充腳本 (Data Seeding)」包含其中**。絕對不允許要求開發者「自己去資料庫手動建表或手寫預設資料」。
