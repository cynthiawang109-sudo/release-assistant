---
name: release-check
description: Evaluate a candidate release against this repo's release checklist gate and draft the release notes. Use when the user asks to prepare, check, or gate a release of one of the workspace's projects (e.g. "run a release check for demo-app v1.1.0").
---

# Run a release check

Produces a **draft** release assessment: the checklist from
`../../release-checklist.md` evaluated item by item against live evidence,
plus one-paragraph change notes drafted from the merged PRs in scope.
Follow the workspace's draft-first rule (root `AGENTS.md`): never post
the assessment or the notes anywhere — write them to a local draft file
and show them to the user.

## Inputs

- **app** — workspace project name under `projects/` (e.g. `demo-app`).
- **version** — the release label being prepared (e.g. `v1.1.0`).
- **since** — start of the change window (a date or a git tag); PRs merged
  after it are in scope.

## Procedure

1. **Read the gate first.** Load `release-checklist.md` and
   `change-process.md` from this repo. The checklist is the evaluation
   rubric; do not invent additional gate items.
2. **Collect the change set.** With the GitHub MCP server (or `gh`):
   list the app repo's PRs merged since `since`, with titles and bodies.
   These are the raw material for the change notes.
3. **Evaluate each checklist item against evidence, not vibes:**
   - *CI green on the exact commit* — the app repo's latest CI run must
     be on the current default-branch HEAD and concluded `success`.
     Name the commit SHA and the run.
   - *Migrations expand-only* — inspect the merged changes for schema
     drops/renames; if there are no migration files, say how schema
     changes are applied instead and judge from that.
   - *Rollback tag identified* — propose the rollback target (the
     previous release tag, or the pre-release HEAD SHA) and name it in
     the draft; it becomes real only when a human confirms it.
   - *Health contract verified* — cite the health tests in the app's
     suite and their latest CI status; if a real staging environment
     exists, verify there instead and say which you did.
   - *On-call named* — a person's name, never a team alias. If none is
     known, mark the item OPEN; never invent a name.
   - *Accepted risks logged* — read `../code-reviewer/projects/<app>.md`
     and confirm the risk list is current; quote open risks verbatim.
4. **Open tickets.** List the workspace tickets (`list_tickets` via the
   doc-search MCP server) and call out any that are open and relevant
   to this release; open tickets do not block by themselves, but the
   draft must not hide them.
5. **Draft the output** to `release-notes-<app>-<version>.draft.md` in
   this repo's root:
   - Heading: app, version, date, candidate commit SHA.
   - *Change notes* — one paragraph summarizing user-visible changes
     from the merged PRs, plain language, no internal ticket ids.
   - *Checklist* — every gate item with status (checked / waived with
     reason / open) and its evidence in one line each.
   - *Open items* — tickets and any unresolved gate items.
   - *Recommendation* — GO only when every item is checked or waived
     with a stated reason; otherwise NO-GO with the blockers listed.
6. **Report** the recommendation and the blockers (if any) in the
   conversation, with the draft file's path. Stop there.

## Guardrails

- Draft-first: the draft file is local. Posting release notes, creating
  a tag, or opening a release is a separate, human-approved action.
- Evidence or it didn't happen: every "checked" needs the SHA, run id,
  file, or test name behind it in the same line.
- A missing fact is an OPEN item, never a guess — especially the
  on-call name and the rollback target.
