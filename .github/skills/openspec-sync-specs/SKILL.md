---
name: openspec-sync-specs
description: Sync delta specs from a completed change into the main openspec/specs/ directory. Use this skill whenever the user wants to merge spec changes after implementation, update canonical specs after a change is done, sync or apply delta specs to main specs, or finalize specs after a feature is complete. Also invoked automatically by the openspec-archive-change skill when syncing is requested. Triggers on phrases like "sync specs", "update specs", "apply delta specs", "merge specs", "finalize specs for change", or when completing the archive workflow.
license: MIT
compatibility: Requires openspec CLI.
metadata:
  author: openspec
  version: "1.0"
---

Sync delta specs from a change into the canonical `openspec/specs/` directory.

## What this skill does

Each openspec change can include delta specs at `openspec/changes/<name>/specs/<capability>/spec.md`.
These express what changed in requirements using structured section headers:

- `## ADDED Requirements` — new requirements to append to the main spec
- `## MODIFIED Requirements` — existing requirements whose full content has changed (replace in place)
- `## REMOVED Requirements` — requirements to delete from the main spec
- `## RENAMED Requirements` — requirements whose header text is changing (name-only, no content change)

This skill reads those delta specs and applies each operation to `openspec/specs/<capability>/spec.md`,
producing accurate canonical specs that reflect what was actually shipped.

---

## Input

A change name. Infer from conversation context if mentioned. If ambiguous, run:
```bash
openspec list --json
```
and ask the user to select. Announce: "Syncing specs for change: **<name>**"

A **delta analysis** may also be passed in by the caller (e.g., from `openspec-archive-change`).
If provided, use it as context — but always re-read the actual delta spec files before writing.

---

## Steps

### 1. Discover delta specs

```
openspec/changes/<name>/specs/
```

List all subdirectories — each is a capability with a `spec.md` delta file.
If none exist, report "No delta specs found for `<name>`." and stop.

### 2. For each capability, plan the sync

Read the delta spec file. Read the corresponding main spec (if it exists) at
`openspec/specs/<capability>/spec.md`.

Classify each capability as one of:
- **New** — no main spec file exists yet → will **create** it
- **Update** — main spec exists → will **patch** it

Parse the delta spec into its operation sections and build a plan:

```
capability: payment-methods     → CREATE  (2 added requirements)
capability: session-management  → PATCH   (1 modified, 1 removed)
```

Show the plan to the user before writing anything.

### 3. Apply the sync

Work through each capability. For each operation type:

#### New capability (CREATE)
Create `openspec/specs/<capability>/` directory and `spec.md`.
The file should contain a title header and all ADDED requirements — without any delta section headers.

```markdown
# <Capability Title> Specification

### Requirement: <name>
<description>

#### Scenario: <name>
- **WHEN** <condition>
- **THEN** <outcome>
```

Strip `## ADDED Requirements` and any other delta markers. The output is a clean spec,
not a delta — no `## ADDED`, `## MODIFIED`, `## REMOVED` headers should appear in the written file.

#### Existing capability (PATCH)

Read the full main spec text. Apply each operation in order:

**ADDED** — Append each new requirement block at the end of the file.
Strip the `## ADDED Requirements` header itself; write only the `### Requirement:` blocks.

**MODIFIED** — Replace an existing requirement block with the updated version.
Locate the block by matching `### Requirement: <name>` (whitespace-insensitive).
A "block" is everything from that `### Requirement:` line up to (but not including)
the next `### Requirement:` line, or end of file. Replace the entire block with the
updated content from the delta. If the requirement isn't found, append it as a new requirement
and log a warning.

**REMOVED** — Delete the matching requirement block (same boundary logic as MODIFIED).
Also remove any blank lines that would create an awkward double-gap.

**RENAMED** — Parse `FROM: <old-name>` and `TO: <new-name>` from the block.
Find `### Requirement: <old-name>` in the main spec and replace the header line only
with `### Requirement: <new-name>`. Leave all scenario content unchanged.

Write the patched content back to the main spec file.

### 4. Report results

After all capabilities are processed, show a summary:

```
## Sync Complete

**Change:** <name>

| Capability | Action | Details |
|---|---|---|
| payment-methods | ✅ Created | 2 requirements added |
| session-management | ✅ Updated | 1 modified, 1 removed |
```

If any operations were skipped or produced warnings, list them clearly so the user
can decide whether to fix them manually.

---

## Guardrails

- **Always re-read the delta file** before writing — don't rely solely on a caller-provided summary.
- **Never write delta headers** (`## ADDED Requirements`, etc.) into the output spec files.
  Output specs must be clean requirement documents.
- **Preserve all untouched requirements** in existing specs — only touch the ones named in the delta.
- **Requirement block boundaries**: A block starts at `### Requirement:` and ends just before
  the next `### Requirement:` or at EOF. Use this consistently for MODIFIED and REMOVED.
- **Capability name = folder name**: The delta path `specs/session-management/spec.md` maps to
  main spec `openspec/specs/session-management/spec.md`. No name transformation needed.
- **If the caller passed a delta analysis** that differs from what you read in the file,
  trust the file. The file is the source of truth.
- If a MODIFIED or REMOVED requirement is not found in the main spec, warn and continue
  (don't abort the whole sync).

---

## Spec file conventions

Main spec files follow this structure (for reference when creating new ones):

```markdown
# <Human-Readable Capability Name> Specification

### Requirement: <Requirement Name>
The system SHALL/MUST <description of required behavior>.

#### Scenario: <Scenario Name>
- **WHEN** <precondition or trigger>
- **THEN** <expected system behavior>
```

- Use `SHALL` for normative requirements, `MUST` for critical ones.
- Each requirement needs at least one `#### Scenario:`.
- Capability title: title-case the kebab-case folder name
  (e.g., `payment-methods` → `Payment Methods`).
