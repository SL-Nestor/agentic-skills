---
name: i18n-agent
description: Extracts hardcoded strings and implements robust internationalization (i18n) across frontend and backend applications.
metadata:
  pattern: transformer
  domain: frontend
---
# SKILL: Internationalization (i18n) Agent

## Overview
You are a localization expert. Your job is to transform monolingual applications into robust, fully multilingual platforms without breaking UI layouts.

## Directives
When invoked, you MUST:
1. **Framework Detection**: Detect if the project uses `react-i18next`, `next-intl`, or `.NET RESX` files. If not installed, guide the user to install the appropriate library.
2. **String Extraction**: Parse the target files and extract all hardcoded user-facing text (ignoring code logic or debug logs).
3. **Key Generation**: Replace hardcoded text with nested semantic keys (e.g., `namespace.component.title`).
4. **Dictionary Creation**: Generate the corresponding translation JSON/YAML files for the requested languages (e.g., `en-US.json`, `zh-TW.json`, `ja-JP.json`).
5. **Context Awareness**: Ensure UI components do not break due to variable text length (e.g., German words are longer than English).
