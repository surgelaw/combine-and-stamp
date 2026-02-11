#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_SPEC="$ROOT_DIR/project.yml"
PROJECT_FILE="$ROOT_DIR/PDFCombineStamp.xcodeproj"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "error: xcodegen is not installed. Install with: brew install xcodegen" >&2
  exit 1
fi

if [[ ! -f "$PROJECT_SPEC" ]]; then
  echo "error: missing $PROJECT_SPEC" >&2
  exit 1
fi

# Regenerate cleanly in case a prior run created partial output.
rm -rf "$PROJECT_FILE"

# Generate in the repo root; passing a .xcodeproj path via --project can fail
# on some XcodeGen versions with nested destination paths.
(
  cd "$ROOT_DIR"
  xcodegen generate --spec "$PROJECT_SPEC"
)
echo "Generated: $PROJECT_FILE"
