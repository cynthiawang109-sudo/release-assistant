# Change process

1. **Propose** — open an issue describing the problem, not the solution.
   User-visible changes state who is affected and how.
2. **Design note** — for anything crossing a component boundary (see
   `taskflow-docs/system-overview.md`), a short note in the docs repo comes
   before code: what changes, what deliberately does not.
3. **Implement on a branch** — branches are named `<user>/<yyyy-mm-dd>/<slug>`.
   Never commit directly to the default branch.
4. **Review** — every change gets a code-reviewer pass (interactive or, from
   M3, on the PR). Findings cite standards; accepted risks are recorded, not
   argued twice.
5. **Release** — only through the release checklist gate.
6. **Write it down** — if the change alters a contract, invariant, or
   procedure, the same PR updates the owning documentation repo. Docs that
   lag code are treated as defects.
