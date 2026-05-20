#!/usr/bin/env bash
# SSDLC Autopilot Installer v8.0.0
# Usage: ./install.sh [target-dir] [copilot|claude|gemini|codex|all]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 明確偵測空字串（${1:-.} 把空字串變成 .，需提前攔截）
if [ $# -ge 1 ] && [ -z "$1" ]; then
    echo "Error: Invalid target directory (empty string)" >&2
    exit 1
fi
TARGET_DIR="${1:-.}"
PLATFORM="${2:-all}"

CORE_DIR="$SCRIPT_DIR/core"
PLATFORMS_DIR="$SCRIPT_DIR/platforms"

# ── T-SEC-001: 路徑驗證 ─────────────────────────────────────────
validate_target_path() {
    local target="$1"

    # 拒絕空字串
    if [ -z "$target" ]; then
        echo "Error: Invalid target directory (empty string)" >&2
        exit 1
    fi

    # 拒絕含 .. 的路徑遍歷
    if [[ "$target" == *".."* ]]; then
        echo "Error: Invalid target directory (path traversal detected: '$target')" >&2
        exit 1
    fi

    # 解析絕對路徑並拒絕系統敏感目錄
    local resolved
    resolved="$(realpath -m "$target" 2>/dev/null || echo "$target")"
    local sensitive_prefixes=("/etc" "/usr" "/bin" "/sbin" "/lib" "/proc" "/sys" "/dev" "/boot")
    for prefix in "${sensitive_prefixes[@]}"; do
        if [[ "$resolved" == "$prefix" || "$resolved" == "$prefix/"* ]]; then
            echo "Error: Invalid target directory (sensitive system path: '$resolved')" >&2
            exit 1
        fi
    done
}

# ── T-SEC-004: Rollback 機制 ─────────────────────────────────────
ROLLBACK_DIRS=()
ROLLBACK_FILES=()

cleanup_on_failure() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "" >&2
        echo "[SSDLC] Installation failed (exit $exit_code). Rolling back..." >&2
        for f in "${ROLLBACK_FILES[@]:-}"; do
            [ -f "$f" ] && rm -f "$f" && echo "  Removed: $f" >&2
        done
        for d in "${ROLLBACK_DIRS[@]:-}"; do
            [ -d "$d" ] && rm -rf "$d" && echo "  Removed: $d" >&2
        done
        echo "[SSDLC] Rollback complete." >&2
    fi
}
trap cleanup_on_failure EXIT

# ── 來源目錄驗證 ─────────────────────────────────────────────────
validate_source_dirs() {
    if [ ! -d "$CORE_DIR" ]; then
        echo "Error: core/ directory not found at '$CORE_DIR'. Is this a complete clone?" >&2
        exit 1
    fi
    if [ ! -d "$PLATFORMS_DIR" ]; then
        echo "Error: platforms/ directory not found at '$PLATFORMS_DIR'." >&2
        exit 1
    fi
}

# ── 核心 assets 複製 ──────────────────────────────────────────────
copy_core_assets() {
    local target="$1"
    local agents_dir="$target/.agents"

    mkdir -p "$agents_dir/skills"
    ROLLBACK_DIRS+=("$agents_dir/skills")
    timeout 30 cp -Rf "$CORE_DIR/skills/." "$agents_dir/skills/"

    mkdir -p "$agents_dir/standards"
    ROLLBACK_DIRS+=("$agents_dir/standards")
    timeout 30 cp -Rf "$CORE_DIR/standards/." "$agents_dir/standards/"

    mkdir -p "$agents_dir/templates"
    ROLLBACK_DIRS+=("$agents_dir/templates")
    timeout 30 cp -Rf "$CORE_DIR/templates/." "$agents_dir/templates/"

    mkdir -p "$agents_dir/hooks"
    ROLLBACK_DIRS+=("$agents_dir/hooks")
    timeout 30 cp -Rf "$CORE_DIR/hooks/." "$agents_dir/hooks/"
}

# ── Platform Installers ───────────────────────────────────────────
install_copilot() {
    local target="$1"
    echo "  [Copilot] Installing GitHub Copilot platform..."
    local platform_dir="$PLATFORMS_DIR/copilot"

    mkdir -p "$target/.github/workflows"
    timeout 30 cp -f "$platform_dir/entry/"* "$target/.github/"
    timeout 30 cp -f "$platform_dir/workflows/"* "$target/.github/workflows/"

    mkdir -p "$target/.agents/agents"
    timeout 30 cp -Rf "$platform_dir/agents/." "$target/.agents/agents/"

    copy_core_assets "$target"
    echo "  [Copilot] Done. Entry: .github/copilot-instructions.md"
}

install_claude() {
    local target="$1"
    echo "  [Claude] Installing Claude platform..."
    local platform_dir="$PLATFORMS_DIR/claude"

    cp -f "$platform_dir/entry/CLAUDE.md" "$target/CLAUDE.md"
    ROLLBACK_FILES+=("$target/CLAUDE.md")

    mkdir -p "$target/.agents/agents"
    timeout 30 cp -Rf "$platform_dir/agents/." "$target/.agents/agents/"

    mkdir -p "$target/.claude"
    if [ -f "$target/.claude/settings.json" ]; then
        echo "    [Claude] NOTE: .claude/settings.json already exists. Manually merge hooks from platforms/claude/hooks/settings.json"
    else
        cp -f "$platform_dir/hooks/settings.json" "$target/.claude/settings.json"
        ROLLBACK_FILES+=("$target/.claude/settings.json")
        echo "    [Claude] Installed: .claude/settings.json (session hooks)"
    fi

    copy_core_assets "$target"

    # T-SEC-007: 輸出關鍵檔案 checksum
    if command -v sha256sum &>/dev/null; then
        local checksum
        checksum=$(sha256sum "$target/.agents/standards/ssdlc-core-rules.md" 2>/dev/null | cut -d' ' -f1)
        echo "    [Claude] ssdlc-core-rules.md sha256: ${checksum:-N/A}"
    fi

    echo "  [Claude] Done. Entry: CLAUDE.md + .claude/settings.json"
}

install_gemini() {
    local target="$1"
    echo "  [Gemini] Installing Gemini CLI platform..."
    local platform_dir="$PLATFORMS_DIR/gemini"

    cp -f "$platform_dir/entry/GEMINI.md" "$target/GEMINI.md"
    ROLLBACK_FILES+=("$target/GEMINI.md")

    mkdir -p "$target/.agents/agents"
    timeout 30 cp -Rf "$platform_dir/agents/." "$target/.agents/agents/"

    copy_core_assets "$target"
    echo "  [Gemini] Done. Entry: GEMINI.md"
}

install_codex() {
    local target="$1"
    echo "  [Codex] Installing OpenAI Codex CLI platform..."
    local platform_dir="$PLATFORMS_DIR/codex"

    cp -f "$platform_dir/entry/AGENTS.md" "$target/AGENTS.md"
    ROLLBACK_FILES+=("$target/AGENTS.md")

    mkdir -p "$target/.agents/agents"
    timeout 30 cp -Rf "$platform_dir/agents/." "$target/.agents/agents/"

    copy_core_assets "$target"
    echo "  [Codex] Done. Entry: AGENTS.md"
}

# ── Main ──────────────────────────────────────────────────────────
echo ""
echo "SSDLC Autopilot Installer v8.0.0"
echo "   Target  : $TARGET_DIR"
echo "   Platform: $PLATFORM"
echo ""

validate_target_path "$TARGET_DIR"
validate_source_dirs
mkdir -p "$TARGET_DIR"

case "$PLATFORM" in
    copilot) install_copilot "$TARGET_DIR" ;;
    claude)  install_claude  "$TARGET_DIR" ;;
    gemini)  install_gemini  "$TARGET_DIR" ;;
    codex)   install_codex   "$TARGET_DIR" ;;
    all)
        install_copilot "$TARGET_DIR"
        install_claude  "$TARGET_DIR"
        install_gemini  "$TARGET_DIR"
        install_codex   "$TARGET_DIR"
        ;;
    *)
        echo "Error: Unknown platform: '$PLATFORM'" >&2
        echo "Usage: ./install.sh [target-dir] [copilot|claude|gemini|codex|all]" >&2
        exit 1
        ;;
esac

echo ""
echo "Installation complete!"
echo ""
