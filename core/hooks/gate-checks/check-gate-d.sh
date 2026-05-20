#!/usr/bin/env bash
# Gate D 前置條件檢查 (T-SEC-003)
# 觸發：UserPromptSubmit，偵測到 $devops 時執行

INPUT="${CLAUDE_TOOL_INPUT:-}"

# T-SEC-008: 精確詞邊界比對
if printf '%s' "$INPUT" | grep -qE '(^|\s)\$devops(\s|$)'; then

    if [ -f "docs/security-gate-report.md" ]; then
        if grep -q "PASS" "docs/security-gate-report.md" 2>/dev/null; then
            echo "[SSDLC] ✅ Gate D: OK — security gate passed"
        else
            echo "[SSDLC] ⛔ Gate D: BLOCKED"
            echo "[SSDLC]    docs/security-gate-report.md exists but no PASS verdict found."
            echo "[SSDLC]    Run: \$security-gate  to get a verdict first."
        fi
    else
        echo "[SSDLC] ⛔ Gate D: BLOCKED"
        echo "[SSDLC]    docs/security-gate-report.md not found."
        echo "[SSDLC]    Run: \$security-gate  before deploying."
    fi
fi
exit 0
