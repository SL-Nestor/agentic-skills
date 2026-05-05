#!/bin/bash
set -e

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/payload"
TARGET_DIR="${1:-.}"

echo "Installing skills and instructions to $TARGET_DIR..."

if [ -d "$SOURCE_DIR/.github" ]; then
    mkdir -p "$TARGET_DIR/.github"
    cp -Rf "$SOURCE_DIR/.github/"* "$TARGET_DIR/.github/"
fi

if [ -d "$SOURCE_DIR/.agents" ]; then
    mkdir -p "$TARGET_DIR/.agents"
    cp -Rf "$SOURCE_DIR/.agents/"* "$TARGET_DIR/.agents/"
fi

# Copy IDE root config files
for file in ".cursorrules" ".geminirules" "CLAUDE.md" "AGENTS.md"; do
    if [ -f "$SOURCE_DIR/$file" ]; then
        cp -f "$SOURCE_DIR/$file" "$TARGET_DIR/"
    fi
done

echo "Installation complete!"
