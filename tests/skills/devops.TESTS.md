# devops Skill — BDD 驗收測試
> **Author**: $implementer (BDD phase)  
> **SSDLC Phase**: 對應 Phase

## Feature: $devops

```gherkin
Scenario: CI/CD 包含安全掃描步驟
  Given $devops 產出 GitHub Actions workflow
  When Pipeline 定義完成
  Then 包含 SAST 或依賴掃描步驟
  And 安全掃描在建構步驟之前

Scenario: Dockerfile 非 root 執行
  Given $devops 產出 Dockerfile
  When 容器設定完成
  Then Dockerfile 包含 USER 指令（非 root）
  And 使用 multi-stage build

Scenario: 不 hardcode secret
  Given $devops 設定 CI/CD 環境變數
  When Pipeline 定義完成
  Then 所有 secret 透過 GitHub Secrets 或 Key Vault 注入
  And 不在 YAML 中出現明文密碼或 token

Scenario: Gate D 之前不部署
  Given security-gate-report.md 標示 FAIL
  When $devops 收到部署指令
  Then 拒絕產出部署設定
  And 提示先完成 Security Gate
```

## Verification Checklist
- [ ] Happy Path 情境至少 1 個
- [ ] Edge Case 或資安負面情境至少 1 個
- [ ] 每個 Scenario 的 Then 條件可觀測/可驗證
- [ ] 情境覆蓋 Verification checklist 中的關鍵項目
