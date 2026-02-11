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

### 1. Drag-and-Drop Interface
- Summary: Support dragging PDFs to the application window rather than right clicking them in Finder. Once the files are added, an action button will prompt for the information that was requested when using the quick action.
- Why it matters: Reduces filing mistakes and manual renaming.
- Impact: High
- Effort: Medium
- Risk: Low
- Priority: High

### 2. Drag-and-Drop Reordering
- Summary: Let users reorder source files in-app before combining.
- Why it matters: Fixes the most common merge-order issue quickly.
- Impact: High
- Effort: Medium
- Risk: Low
- Priority: High

### 3. Presets and Profiles
- Summary: Save reusable templates for prefix, starting number, output naming, and stamp settings.
- Why it matters: Removes repetitive setup on every job.
- Impact: High
- Effort: Medium
- Risk: Low
- Priority: High
- Notes: Include import/export JSON for team sharing.

## Tier 2: Premium Differentiators (Paid SKU candidates)

### 4. Flatten PDF Output (Remove Interactive Elements)
- Summary: Add an optional "Flatten output" mode to remove clickable links/forms and reduce interactive PDF behavior.
- Why it matters: Some courts reject filings containing active links or interactive elements.
- Impact: High
- Effort: Medium
- Risk: Medium
- Priority: High
- Notes: Implement natively with PDFKit/CoreGraphics by rasterizing each page at configurable DPI and rebuilding a new PDF. This avoids external dependencies and is compatible with both direct and App Store distribution.

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

### 7. Court-Ready Presets (PDF/A + Filing Profiles)
- Summary: One-click output profiles tuned for common filing constraints.
- Why it matters: Reduces submission rejection risk.
- Impact: High
- Effort: Medium
- Risk: Medium
- Priority: Medium

### 8. Improve Large File Support
- Summary: Large files and large batches can be time and memory intensive. Test with larger files (greater than 1GB) to ensure the application performs suitably.
- Why it matters: Provides predictability and trust by the user
- Impact: Medium
- Effort: High
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
- Optional flatten mode

### Paid Mac App Store Version
- Everything in free version plus:
- Advanced stamping
- Bookmark generation
- Native flatten mode
- OCR/searchable output
- Filing-ready profiles
- Batch workflows (later)

## Suggested Next 3 Milestones

### Milestone A (v1.1)
- Drag-and-drop interface
- Reordering UI
- Presets/profiles
- Core UX polish and error handling

### Milestone B (v1.2)
- Flatten output option
- Bookmark generation
- Advanced stamping options
- Court-ready preset baseline

### Milestone C (v1.3)
- Improve large-file support (performance and memory hardening)
- Filing profile expansion
- Batch-mode design/prototype

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
| F-01 | Drag-and-Drop Interface | 1 | Planned | v1.1 | Replace Finder-first workflow with in-app drop zone flow |
| F-02 | Drag-and-Drop Reordering | 1 | Planned | v1.1 | Preserve explicit file/page ordering |
| F-03 | Presets and Profiles | 1 | Planned | v1.1 | Include import/export JSON for team sharing |
| F-04 | Flatten PDF Output | 2 | Planned | v1.2 | Native rasterize/rebuild flow (PDFKit/CoreGraphics) |
| F-05 | Bookmark/TOC Generation | 2 | Planned | v1.2 | Preserve existing bookmarks where possible |
| F-06 | Advanced Stamping | 2 | Planned | v1.2 | Header/footer/confidentiality/date presets |
| F-07 | Court-Ready Presets | 2 | Planned | v1.2-v1.3 | Filing profile baseline then expand |
| F-08 | Improve Large File Support | 2 | Planned | v1.3 | Performance + memory hardening for >1GB workflows |
| F-09 | Batch Mode | 3 | Backlog | v1.4+ | |
| F-10 | Split + Recombine | 3 | Backlog | v1.4+ | |
| F-11 | Duplicate Detection | 3 | Backlog | v1.4+ | |
| F-12 | Redaction Workflow | 3 | Backlog | v1.5+ | |
