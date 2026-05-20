# Gemini CLI — Session Hook

> Gemini CLI 目前使用 GEMINI.md 作為持久上下文的主要機制。
> 本檔案定義 Gemini 應在每次會話開始時自動執行的行為。

## 啟動行為

在 `GEMINI.md` 的 Initialization Directive 已涵蓋基礎載入。
以下是會話開始時的**延伸行為**：

1. 讀取 `.agents/standards/ssdlc-core-rules.md`
2. 讀取 `.agents/standards/agent-network.md`
3. 如果存在 `SSDLC_TRACKER.md`，讀取並報告當前 Phase 狀態
4. 如果存在 `AGENT_HANDOFF.md`，讀取最後一次交接上下文
5. 輸出簡短的會話開幕摘要

詳細行為規範見 `../../hooks/session-start.md`。

## Gemini CLI 指令整合

如需在 Gemini CLI 中支援 slash commands，可建立 `.gemini/commands/` 目錄並加入對應命令定義。
詳見 Gemini CLI 官方文件。
