# PDFCombineStamp Product Roadmap

Last updated: 2026-02-11
Owner: Matthew Nuzum

## Purpose
This document tracks feature priorities for improving product value while balancing implementation effort and release risk.

## Prioritization Model
- Impact: user time saved, error reduction, willingness to pay
- Effort: engineering/design/testing complexity
- Risk: platform/sandbox/review constraints
- Priority score: High / Medium / Low (pragmatic weighted judgment)

## Tier 1: Quick Wins (1-2 weeks each)

### 1. Presets and Profiles
- Summary: Save reusable templates for prefix, starting number, output naming, and stamp settings.
- Why it matters: Removes repetitive setup on every job.
- Impact: High
- Effort: Medium
- Risk: Low
- Priority: High
- Notes: Include import/export JSON for team sharing.

### 2. Smarter Output Naming
- Summary: Support token-based output names (e.g., `{client}_{matter}_{date}_{bates_start}-{bates_end}`).
- Why it matters: Reduces filing mistakes and manual renaming.
- Impact: High
- Effort: Low
- Risk: Low
- Priority: High

### 3. Drag-and-Drop Reordering
- Summary: Let users reorder source files in-app before combining.
- Why it matters: Fixes the most common merge-order issue quickly.
- Impact: High
- Effort: Medium
- Risk: Low
- Priority: High

### 4. Manifest/Audit Export
- Summary: Emit CSV/JSON with input files, page counts, Bates range, output path, timestamp.
- Why it matters: Improves defensibility and repeatability for legal workflows.
- Impact: Medium
- Effort: Low
- Risk: Low
- Priority: High

## Tier 2: Premium Differentiators (Paid SKU candidates)

### 5. Bookmark/Table-of-Contents Generation
- Summary: Generate bookmarks from filenames and preserve PDF bookmarks where possible.
- Why it matters: Improves navigation in large productions.
- Impact: High
- Effort: Medium
- Risk: Medium
- Priority: High

### 6. Advanced Stamping
- Summary: Add footer/header modes, confidentiality labels, custom date/time, per-page position presets.
- Why it matters: Expands use beyond simple Bates numbering.
- Impact: High
- Effort: Medium
- Risk: Low
- Priority: High

### 7. OCR + Searchable Output
- Summary: OCR scanned pages before final merge/stamp.
- Why it matters: Large user-perceived value for scanned exhibits.
- Impact: High
- Effort: High
- Risk: Medium
- Priority: Medium
- Notes: Consider paid add-on due to cost/complexity.

### 8. Court-Ready Presets (PDF/A + Filing Profiles)
- Summary: One-click output profiles tuned for common filing constraints.
- Why it matters: Reduces submission rejection risk.
- Impact: High
- Effort: Medium
- Risk: Medium
- Priority: Medium

## Tier 3: Strategic / Later Investments

### 9. Batch Mode Across Matters
- Summary: Run many folder jobs using preset rules.
- Why it matters: Big time saver for power users.
- Impact: High
- Effort: High
- Risk: Medium
- Priority: Medium

### 10. Split + Recombine Workflow
- Summary: Split by ranges/bookmarks and recombine with a single pipeline.
- Why it matters: Useful for production assembly and corrections.
- Impact: Medium
- Effort: High
- Risk: Medium
- Priority: Low

### 11. Duplicate/Integrity Detection
- Summary: Flag duplicate pages/files and optional hash report.
- Why it matters: Prevents accidental duplicate production.
- Impact: Medium
- Effort: Medium
- Risk: Low
- Priority: Medium

### 12. Redaction Workflow
- Summary: Permanent text/image redaction prior to final output.
- Why it matters: High compliance value if done correctly.
- Impact: High
- Effort: High
- Risk: High
- Priority: Low
- Notes: Requires careful legal/compliance quality controls.

## Distribution Strategy Alignment

### Direct Free Version (website/GitHub)
- Core combine/stamp
- Presets (basic)
- Reordering
- Basic manifest export

### Paid Mac App Store Version
- Everything in free version plus:
- Advanced stamping
- Bookmark generation
- OCR/searchable output
- Filing-ready profiles
- Batch workflows (later)

## Suggested Next 3 Milestones

### Milestone A (v1.1)
- Presets/profiles
- Smart naming tokens
- Reordering UI
- Basic manifest export

### Milestone B (v1.2)
- Bookmark generation
- Advanced stamping options
- Improved progress/error states

### Milestone C (v1.3)
- OCR prototype
- Filing profile presets
- Monetization packaging for App Store tiering

## Backlog Intake Rules
- Add feature requests with: user problem, expected outcome, sample files, and success metric.
- Reject vague requests without a measurable outcome.
- Every accepted item must include a test plan and rollback note.

## Review Cadence
- Weekly: update status and priorities.
- Monthly: re-score based on usage feedback and support volume.
- Release retro: record what shipped, what slipped, and why.

## Status Tracker

| ID | Feature | Tier | Status | Target Version | Notes |
|---|---|---|---|---|---|
| F-01 | Presets and Profiles | 1 | Planned | v1.1 | |
| F-02 | Smarter Output Naming | 1 | Planned | v1.1 | |
| F-03 | Drag-and-Drop Reordering | 1 | Planned | v1.1 | |
| F-04 | Manifest/Audit Export | 1 | Planned | v1.1 | |
| F-05 | Bookmark/TOC Generation | 2 | Planned | v1.2 | |
| F-06 | Advanced Stamping | 2 | Planned | v1.2 | |
| F-07 | OCR Searchable Output | 2 | Backlog | v1.3+ | |
| F-08 | Filing Presets | 2 | Backlog | v1.3+ | |
| F-09 | Batch Mode | 3 | Backlog | v1.4+ | |
| F-10 | Split + Recombine | 3 | Backlog | v1.4+ | |
| F-11 | Duplicate Detection | 3 | Backlog | v1.4+ | |
| F-12 | Redaction Workflow | 3 | Backlog | v1.5+ | |
