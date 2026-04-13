# 需求至工程部交接檢核表 (Handoff Checklist: REQ -> ENG)

此文件為公司治理標準下，需求端 (REQ) 要將開發任務交付給工程端 (ENG) 的「唯一合法點收清單」。請確保以下資源已準備妥當且互相連結。

## 1. 交付基本資訊 (Delivery Metadata)
- **模組名稱 (Module ID)**: `[例如: modules/LOGIN]`
- **需求票號 / 專案連結**: `[Jira / REQ Issue URL]`
- **交接日期**: `YYYY-MM-DD`
- **負責人 (PM/PO)**: `@name`

## 2. 邊界與前置配置 (Boundary & Baseline)
- [ ] **交付包庫位 (Delivery Package Path)**: `[REQ 倉內交付物資料夾路徑]`
- [ ] **契約基準版本 (Contract Baseline Ref)**: `[OpenAPI tag 或 commit hash，絕對唯一真相 SSOT]`
- [ ] **模組邊界 (Boundary Spec)**: 已定義不主責範圍與外部系統交界 (對應 `tpl_boundary_spec`)。

## 3. 開工必備文件 (Execution Triangle)
為了防堵「解釋漂移 (Interpretive Drift)」，工程端 (ENG) 或代理人 (AI) 在開工前必須確認已收到以下三份文件，並以此作為「開發三角」：
- [ ] 1. **正式規格書 (Formal PRD)**: 業務情境、規則、約束與視覺流程。
- [ ] 2. **單一合約 (OpenAPI/Schema)**: 與 Baseline 相符的機器可讀資料結構 (SSOT)。
- [ ] 3. **驗收標準 (Acceptance Spec)**: 包含 BDD 情境與負面防禦側測。

## 4. 階段特殊要求 (Phase specific)
- [ ] **Phase 1 (若適用)**: 已確認 P1 Admin 驗證 UI Spec (`tpl_req_p1_admin_verification_ui_spec.md`)，並與 `CAP-REQ-002` 條款一致。
- [ ] **Phase 2 (開發與重構)**: 已確認對前一交付包的追溯 (`traces_to_prior_pack`)，無矛盾。

## 5. 工程師與 AI 代理人回寫守則 (Writeback Discipline / GOV-004)
- **嚴重警告**: 工程師與 SSDLC 代理人 **嚴禁**在沒有修改 OpenAPI (Contract) 的情況下，私自在程式碼中新增外部 API 欄位或變更 Enum 狀態。
- **回寫機制 (Writeback)**: 若實作與規格不一致，請立即暫停開發，發起針對 `Contract Baseline` 的修訂 PR 並等待簽核。
