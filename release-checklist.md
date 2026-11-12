# Release checklist (production gate)

Every item must be checked or explicitly waived with a reason before a
production promotion (see `taskflow-docs/deployment.md`).

- [ ] CI green on the exact commit being promoted (tests + lint + build)
- [ ] Change notes summarize user-visible changes in one paragraph
- [ ] Database migrations are expand-only in this release (no drops/renames)
- [ ] Rollback tag identified and noted in the release ticket
- [ ] Health contract verified on staging (`/health` per `taskflow-api-docs`)
- [ ] On-call for the release window is a named person, not a team alias
- [ ] Any accepted risk discovered during review is logged in
      `code-reviewer/projects/<app>.md`
