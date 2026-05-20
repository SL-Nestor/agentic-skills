#!/usr/bin/env bash
# SSDLC Autopilot — Remote Installer
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/SL-Nestor/agentic-skills/main/install-remote.sh | bash -s -- [target-dir] [platform]
#
# Examples:
#   Install Claude platform into current directory:
#     curl -fsSL .../install-remote.sh | bash -s -- . claude
#
#   Install Codex platform into ./my-project:
#     curl -fsSL .../install-remote.sh | bash -s -- ./my-project codex
#
#   Install all platforms:
#     curl -fsSL .../install-remote.sh | bash -s -- . all
#
set -euo pipefail

REPO_OWNER="SL-Nestor"
REPO_NAME="agentic-skills"
BRANCH="main"
REPO_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/heads/${BRANCH}.tar.gz"

TARGET_DIR="${1:-.}"
PLATFORM="${2:-claude}"

# ── 路徑驗證（同 install.sh）────────────────────────────────────
if [ $# -ge 1 ] && [ -z "$1" ]; then
    echo "Error: Invalid target directory (empty string)" >&2
    exit 1
fi

if [[ "$TARGET_DIR" == *".."* ]]; then
    echo "Error: Invalid target directory (path traversal detected)" >&2
    exit 1
fi

# ── 依賴檢查 ────────────────────────────────────────────────────
check_deps() {
    local missing=()
    for cmd in curl tar bash; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Error: Missing required commands: ${missing[*]}" >&2
        exit 1
    fi
}

# ── 暫存目錄管理 ────────────────────────────────────────────────
TMPDIR_WORK=""
cleanup() {
    [ -n "$TMPDIR_WORK" ] && [ -d "$TMPDIR_WORK" ] && rm -rf "$TMPDIR_WORK"
}
trap cleanup EXIT

# ── Main ────────────────────────────────────────────────────────
echo ""
echo "SSDLC Autopilot — Remote Installer"
echo "   Repository : ${REPO_OWNER}/${REPO_NAME}@${BRANCH}"
echo "   Target     : ${TARGET_DIR}"
echo "   Platform   : ${PLATFORM}"
echo ""

check_deps

# 建立暫存目錄
TMPDIR_WORK="$(mktemp -d 2>/dev/null || mktemp -d -t ssdlc)"
echo "Downloading repository..."
curl -fsSL --retry 3 --retry-delay 2 "$REPO_URL" \
    | tar -xz --strip-components=1 -C "$TMPDIR_WORK"

echo "Running installer..."
bash "$TMPDIR_WORK/install.sh" "$TARGET_DIR" "$PLATFORM"

echo ""
echo "SSDLC Autopilot installed successfully!"
echo ""
echo "Next steps:"
case "$PLATFORM" in
    claude)
        echo "  1. Open ${TARGET_DIR} in Claude Code"
        echo "  2. Type: \$pm [your task]"
        ;;
    codex)
        echo "  1. Open ${TARGET_DIR} in OpenAI Codex CLI"
        echo "  2. Type: \$pm [your task]"
        ;;
    all)
        echo "  • Claude Code : open ${TARGET_DIR}, type \$pm [task]"
        echo "  • Codex CLI   : open ${TARGET_DIR}, type \$pm [task]"
        echo "  • Gemini CLI  : open ${TARGET_DIR}, type \$pm [task]"
        ;;
    *)
        echo "  Open ${TARGET_DIR} in your AI tool and type: \$pm [your task]"
        ;;
esac
echo ""
