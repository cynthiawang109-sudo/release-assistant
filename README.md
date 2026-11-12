# release-assistant

The process side of ai-workspace-kit: release and change-process knowledge
kept as a small, referenceable repository instead of tribal knowledge in a
chat thread. Other projects link here; agent sessions read these files when
work touches releases or process gates.

Part of [ai-workspace-kit](https://github.com/cynthiawang109-sudo/ai-workspace-kit).
Generic process content for the fictional TaskFlow project.

## Contents

| File | What it covers |
|---|---|
| `release-checklist.md` | The gate a release must pass before production |
| `change-process.md` | How changes are proposed, reviewed, and rolled out |
| `skills/release-check/SKILL.md` | Agent skill: evaluate a candidate release against the checklist with live evidence (CI runs, merged PRs, review state, open tickets) and draft release notes |
| `scripts/release-check.ps1` / `.sh` | One-command runner for the skill via Codex (draft-first: writes a local draft file, posts nothing) |
