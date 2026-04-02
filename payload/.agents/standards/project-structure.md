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
