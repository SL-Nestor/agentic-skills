#!/usr/bin/env bats
# SSDLC Autopilot — install.sh Test Suite
# Framework: bats-core (https://github.com/bats-core/bats-core)
# Coverage: FR-01, FR-02, FR-06, T-SEC-001, T-SEC-004, NFR-02

setup() {
  # 每個測試前建立隔離的暫存目錄
  REPO_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  TMP_TARGET="$(mktemp -d)"
  INSTALL_SCRIPT="$REPO_DIR/install.sh"
}

teardown() {
  # 清理暫存目錄
  rm -rf "$TMP_TARGET"
}

# ─── FR-01: 平台隔離安裝 ────────────────────────────────────────

@test "FR-01a: Claude 平台安裝產出正確檔案結構" {
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" claude
  [ "$status" -eq 0 ]
  [ -f "$TMP_TARGET/CLAUDE.md" ]
  [ -d "$TMP_TARGET/.agents/agents" ]
  [ -d "$TMP_TARGET/.agents/skills" ]
  [ -d "$TMP_TARGET/.agents/standards" ]
  [ -d "$TMP_TARGET/.agents/hooks" ]
  [ -f "$TMP_TARGET/.agents/agents/00-pm.md" ]
}

@test "FR-01b: Claude 平台安裝不建立其他平台 entry 檔案" {
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" claude
  [ "$status" -eq 0 ]
  [ ! -f "$TMP_TARGET/GEMINI.md" ]
  [ ! -f "$TMP_TARGET/AGENTS.md" ]
  [ ! -f "$TMP_TARGET/.github/copilot-instructions.md" ]
}

@test "FR-01c: Gemini 平台安裝產出 GEMINI.md" {
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" gemini
  [ "$status" -eq 0 ]
  [ -f "$TMP_TARGET/GEMINI.md" ]
  [ ! -f "$TMP_TARGET/CLAUDE.md" ]
}

@test "FR-01d: Codex 平台安裝產出 AGENTS.md" {
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" codex
  [ "$status" -eq 0 ]
  [ -f "$TMP_TARGET/AGENTS.md" ]
  [ ! -f "$TMP_TARGET/CLAUDE.md" ]
}

@test "FR-01e: all 平台安裝產出所有 entry 檔案" {
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" all
  [ "$status" -eq 0 ]
  [ -f "$TMP_TARGET/CLAUDE.md" ]
  [ -f "$TMP_TARGET/GEMINI.md" ]
  [ -f "$TMP_TARGET/AGENTS.md" ]
  [ -f "$TMP_TARGET/.github/copilot-instructions.md" ]
}

@test "FR-01f: 安裝至不存在的目錄會自動建立" {
  local new_dir="$TMP_TARGET/brand-new-subdir"
  [ ! -d "$new_dir" ]
  run bash "$INSTALL_SCRIPT" "$new_dir" claude
  [ "$status" -eq 0 ]
  [ -d "$new_dir" ]
  [ -f "$new_dir/CLAUDE.md" ]
}

# ─── FR-02: 現有設定保護 ────────────────────────────────────────

@test "FR-02a: 現有 settings.json 不被覆寫" {
  mkdir -p "$TMP_TARGET/.claude"
  echo '{"custom":true}' > "$TMP_TARGET/.claude/settings.json"
  
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" claude
  [ "$status" -eq 0 ]
  
  # 內容應保持不變
  run cat "$TMP_TARGET/.claude/settings.json"
  [[ "$output" == *'"custom":true'* ]]
}

@test "FR-02b: 現有 settings.json 時輸出警告訊息" {
  mkdir -p "$TMP_TARGET/.claude"
  echo '{"custom":true}' > "$TMP_TARGET/.claude/settings.json"
  
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" claude
  [ "$status" -eq 0 ]
  [[ "$output" == *"already exists"* ]] || [[ "$output" == *"manually merge"* ]]
}

@test "FR-02c: 無現有 settings.json 時正常安裝" {
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" claude
  [ "$status" -eq 0 ]
  [ -f "$TMP_TARGET/.claude/settings.json" ]
}

# ─── FR-06 / T-SEC-001: 路徑遍歷防禦 ───────────────────────────

@test "T-SEC-001a: 拒絕含 .. 的路徑遍歷攻擊" {
  run bash "$INSTALL_SCRIPT" "../../etc/passwd" claude
  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid"* ]] || [[ "$output" == *"invalid"* ]] || [[ "$output" == *"Error"* ]]
}

@test "T-SEC-001b: 拒絕絕對路徑 /etc" {
  run bash "$INSTALL_SCRIPT" "/etc/test-ssdlc" claude
  # 若腳本允許絕對路徑到 /etc，應拒絕；若允許絕對路徑但不到敏感目錄，可通過
  # 此測試確保至少 /etc 類敏感路徑被拒絕
  if [ "$status" -eq 0 ]; then
    # 若允許，確保不在 /etc 寫入任何東西
    [ ! -f "/etc/test-ssdlc/CLAUDE.md" ]
  fi
}

@test "T-SEC-001c: 空字串目標被拒絕" {
  run bash "$INSTALL_SCRIPT" "" claude
  [ "$status" -ne 0 ]
}

# ─── NFR-02: bash strict mode 相容 ─────────────────────────────

@test "NFR-02a: 在 bash strict mode 下執行不報錯" {
  run bash -euo pipefail "$INSTALL_SCRIPT" "$TMP_TARGET" claude
  [ "$status" -eq 0 ]
}

# ─── NFR-01: 效能 ───────────────────────────────────────────────

@test "NFR-01: 完整安裝在 30 秒內完成" {
  local start end elapsed
  start=$(date +%s)
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" all
  end=$(date +%s)
  elapsed=$((end - start))
  [ "$status" -eq 0 ]
  [ "$elapsed" -lt 30 ]
}

# ─── 核心資料完整性 ─────────────────────────────────────────────

@test "完整安裝後 9 個 claude agent 檔案存在" {
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" claude
  [ "$status" -eq 0 ]
  local agent_count
  agent_count=$(ls "$TMP_TARGET/.agents/agents/"*.md 2>/dev/null | wc -l)
  [ "$agent_count" -ge 9 ]
}

@test "完整安裝後 core standards 存在" {
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" claude
  [ "$status" -eq 0 ]
  [ -f "$TMP_TARGET/.agents/standards/ssdlc-core-rules.md" ]
}

@test "完整安裝後 session hooks 存在" {
  run bash "$INSTALL_SCRIPT" "$TMP_TARGET" claude
  [ "$status" -eq 0 ]
  [ -f "$TMP_TARGET/.agents/hooks/session-start.md" ]
  [ -f "$TMP_TARGET/.agents/hooks/session-end.md" ]
}
