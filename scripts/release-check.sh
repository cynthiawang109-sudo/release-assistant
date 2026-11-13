#!/usr/bin/env bash
# release-check.sh - run the release-check skill headlessly via Codex
# (bash twin of release-check.ps1). Codex gathers the evidence with its
# MCP servers and writes the draft assessment to a local file. Nothing
# is posted anywhere by this script.
#
# Usage:
#   ./scripts/release-check.sh --app demo-app --version v1.1.0 --since 2026-11-01 [--out FILE]

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

APP="" VERSION="" SINCE="" OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --app) APP="$2"; shift 2 ;;
    --version) VERSION="$2"; shift 2 ;;
    --since) SINCE="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done
[ -n "$APP" ] && [ -n "$VERSION" ] && [ -n "$SINCE" ] || {
  echo "usage: release-check.sh --app <app> --version <v> --since <date-or-tag> [--out FILE]" >&2
  exit 2
}
[ -n "$OUT" ] || OUT="$ROOT/release-notes-$APP-$VERSION.draft.md"

read -r -d '' PROMPT <<EOF || true
Use the release-check skill in skills/release-check/SKILL.md for app '$APP', version '$VERSION', change window since '$SINCE'.
Write the draft assessment to exactly this file: $OUT
Then reply with the recommendation (GO or NO-GO), the blockers if any, and the draft file path. Draft-first: do not post, tag, or create anything anywhere.
EOF

cd "$ROOT"
# SANDBOX override exists for machines where Codex's sandboxed shell
# runner is wedged ("Failed to create unified exec process: timed out
# ... connecting runner pipe-in"): SANDBOX=danger-full-access.
codex exec --sandbox "${SANDBOX:-workspace-write}" "$PROMPT" </dev/null
echo "Draft (if Codex completed): $OUT"
