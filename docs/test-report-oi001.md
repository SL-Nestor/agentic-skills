# Test Report — OI-001 Pester Test Suite (v8.0.1)

> **Date**: 2026-05-20  
> **Agent**: $test-engineer (Claude, Cowork mode)  
> **Environment**: PowerShell 7.4.2 + Pester 5.7.1 on Linux (Ubuntu 22)  
> **Verdict**: PASS (with known Windows-only skips and sandbox caveat)

---

## Summary

| Category | Tests | Pass | Fail | Skip | Notes |
|----------|-------|------|------|------|-------|
| FR-PS-01 (AC-01) | 3 | 3 | 0 | 0 | Empty string rejection |
| FR-PS-02 (AC-02) | 2 | 2 | 0 | 0 | Path traversal detection |
| FR-PS-03 (AC-03) | 3 | 0 | 0 | 3 | Windows-only (C:\Windows paths) |
| FR-PS-04 (AC-04) | 1 | 1 | 0 | 0 | Source dir validation |
| FR-PS-05 (AC-05) | 2 | 2 | 0 | 0 | Rollback on failure |
| FR-PS-06 (AC-06) | 3 | 3 | 0 | 0 | SHA256 output |
| FR-01 (Platform isolation) | 6 | 6 | 0 | 0 | All platforms install correctly |
| FR-02 (Settings protection) | 3 | 3 | 0 | 0 | settings.json not overwritten |
| T-SEC-001 (Traversal/Empty) | 2 | 2 | 0 | 0 | exit 1 confirmed |
| Core integrity | 3 | 3 | 0 | 0 | agents/standards/hooks present |
| NFR-01 (Performance) | 1 | — | — | — | Sandbox CPU limit; verify on CI |
| **Total** | **29** | **25** | **0** | **3** | **+1 pending CI** |

---

## Bugs Found and Fixed During Phase 6

| ID | Bug | Fix |
|----|-----|-----|
| BUG-01 | install.ps1 Quick start switch used backtick-escaping (`\`"`) that terminated strings early | Replaced double-quoted strings with single-quoted strings in switch block |
| BUG-02 | install.ps1 had no `exit 0` at normal completion; $LASTEXITCODE retained previous value of 1 | Added `exit 0` before final blank Write-Host |
| BUG-03 | Pester BeforeEach/AfterEach at root level not supported in v5 | Wrapped entire suite in outer Describe block |
| BUG-04 | Tests used `2>&1` but Write-Host uses stream 6; output capture was empty | Changed to `*>&1` (redirect all streams) |

---

## Key Evidence

- SHA256 output confirmed: `E59ED7DB7A2AAFEC6C6DEE7E1AACD3E466F4FCF4038D66D6AB1E074F0580A85D`
- Rollback confirmed: `Rollback complete.` on missing platforms/ directory
- Security errors confirmed: `ERROR: path traversal detected` / `ERROR: TargetDir cannot be empty`

---

## Skipped Tests (Windows-only)

FR-PS-03 tests verify `C:\Windows`, `C:\Program Files` blocking.
These paths are non-existent on Linux; `$env:SystemRoot` is unset.
Run on Windows CI (pester-tests job in ci.yml) to fully validate.

---

## Recommendation

Proceed to Phase 7 ($security-gate). All Linux-verifiable tests pass.
Windows-specific AC-03 tests will be confirmed by CI pipeline on push to GitHub.
