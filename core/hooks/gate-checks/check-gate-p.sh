#!/usr/bin/env bash
# Gate P 前置條件檢查 (T-SEC-002)
# 觸發：UserPromptSubmit，偵測到 $implementer 或 $ralph 時執行
# 輸出：stdout（讓 Claude Code 捕捉顯示）

INPUT="${CLAUDE_TOOL_INPUT:-}"  # Claude Code 注入的使用者輸入

# T-SEC-008: 精確詞邊界比對，防止 $implementer-hack 等繞過
if printf '%s' "$INPUT" | grep -qE '(^|\s)\$implementer(\s|$)' || \
   echo "$INPUT" | grep -qE '(^|\s)\$ralph(\s|$)'; then

    if [ -f "docs/threat-model.md" ]; then
        echo "[SSDLC] ✅ Gate P: OK — threat model found (docs/threat-model.md)"
    else
        echo "[SSDLC] ⛔ Gate P: BLOCKED"
        echo "[SSDLC]    docs/threat-model.md not found."
        echo "[SSDLC]    Run: \$threat-modeler  before implementing."
    fi
fi
exit 0
