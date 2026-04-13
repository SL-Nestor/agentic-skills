# 🛡️ SSDLC Autopilot v6.6：生產級 AI 代理人開發框架

## 1. 執行摘要 (Executive Summary)
SSDLC Autopilot v6.6 是一套基於「代理人優先 (Agent-First)」思維打造的自動化軟體開發生命週期框架。本體系整合了 OpenAI 的支架工程 (Harness Engineering)、Vercel 的效能標準以及專業測試心理學，旨在將 AI 從簡單的編碼助手轉型為具備自律性、可稽核性的**虛擬工程團隊**。

### 核心價值主張
- **高產量 (10x Output)**：透過大規模自動化驗證與支架化開發，減少人工手動編碼。
- **極低誤差 (Zero Context Drift)**：嚴格的「源頭意圖庫」確保交付物與規格 100% 一致。
- **專業級韌性 (Production-Grade)**：內建「專業懷疑者模式」，主動挖掘邊界場景與潛在 Bug。

---

## 2. 核心工程哲學
本系統不依賴 AI 的「運氣」，而是依賴三套頂尖工程理論：

1. **支架工程 (Harness Engineering - OpenAI)**
   - **理念**：工程師設計「環境與工具（支架）」，AI 負責在支架中開發。
   - **實踐**：強化的機讀監測 (Observability)，讓 AI 能自主讀取 Log 與指標進行自我修復。
2. **規格革命 (Spec Completeness - RCA Driven)**
   - **理念**：消除 AI 的「滿足偏誤 (Satisficing Bias)」。
   - **實踐**：1:1 負面路徑配對、N+1 狀態枚舉公式，確保無死角規格覆蓋。
3. **專業懷疑論 (Testing Psychology - Bolton & Bach)**
   - **理念**：對抗大腦本能的直覺偏誤。
   - **實踐**：區分「推論與假設」，在驗收階段切換視角，預設系統一定會失敗。

---

## 3. 模組化架構
系統採用**去中心化大腦 (Modular Router)** 設計，每個階段由獨立的專業技能模組驅動：

| 模組名稱 | 專業角色 | 核心任務 |
| :--- | :--- | :--- |
| **Lifecycle-Spec** | 規格架構師 | 原子化需求拆解、PRD 窮舉、負面場景模擬 |
| **Lifecycle-Plan** | 專案經理 | 垂直切片規劃、技術風險估量 |
| **Lifecycle-Build** | 資深開發者 | TDD 開發、Vercel 效能優化、Beyonce 原則實踐 |
| **Lifecycle-Debug** | 調度專家 | 停止生產線 (Stop-the-Line)、能力缺失根因分析 |
| **Lifecycle-Verify** | SDET 測試專家 | 5 維度審查、真實證據擷取 (API/截圖) |
| **Lifecycle-Ship** | 營運工程師 | 變更日誌生成、協議變更紀錄、發布準備 |

---

## 4. 標準化流程 (10-Phase Workflow)

### 第一階段：定義與防禦 (Phase 0~2)
1. **啟動 (Startup)**：強制確認開發模式 (Mode) 與技術棧。
2. **意圖提取 (Source Intent)**：建立非談判性項目庫，鎖定開發邊界。
3. **規格簽核 (Gate P)**：完成 PRD → Spec 追溯矩陣，由 PM (人類) 簽核。

### 第二階段：規劃與架構 (Phase 3~5)
4. **垂直切片 (Slicing)**：將開發任務拆解為獨立可測試的小區塊。
5. **任務分解 (Gate A/B)**：生成具備機器可讀性的任務細節。

### 第三階段：執行與自癒 (Phase 6~8)
6. **循環開發 (The Ralph Loop)**：AI 撰寫程式碼並進行代理人間的同儕評閱。
7. **系統檢驗 (Gate D/E)**：進行 5 維度審查（正確、可讀、架構、安全、效能）。
8. **證據收集 (Evidence Capture)**：擷取 API DayLog 與 Playwright 截圖作為證據。

### 第四階段：結案與優化 (Phase 9~10)
9. **用戶驗收 (Gate F)**：移交生產環境或模擬生產環境。
10. **協議沉澱**：若開發過程中改進了 Protocol，強制記錄於歷史圖書館。

---

## 5. 品質與安全閘口 (Governance Gates)

為了確保管理層透明度，系統設有 6 個硬性門檻：
- **Gate P (Purpose)**：規格是否 100% 穷举且包含所有負面場景？
- **Gate B (Buildability)**：任務清單是否包含所有依賴與環境變數？
- **Gate C (Correctness)**：是否通過了 TDD 紅燈/綠燈循環？
- **Gate D (System Test)**：是否有真實環境的運行截圖與 Payloads？
- **Gate E (Audit)**：代碼是否符合 Vercel 與 OpenAI 的高性能標準？
- **Gate F (Final Launch)**：所有變更是否已寫入 Change Log 並同步版本演進？

---

## 6. 版本治理與透明度
遵循 **v6.5 紀錄強制令**，所有系統的演進皆會永久記錄在專案內部的 `docs/ssdlc/history/`。

---
*報告生成日期：2024-04-13*
*系統當前版本：v6.6 (Harness Engineering Active)*
