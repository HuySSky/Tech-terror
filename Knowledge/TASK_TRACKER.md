# TASK_TRACKER — Tech terror

> **Purpose:** Track implementation progress and session handoffs. This file is not the source of game requirements or architecture decisions.
>
> - `PROJECT_SPEC.md` is the source of truth for requirements, assumptions, proposals, and unresolved questions.
> - `DECISIONS.md` records owner-confirmed decisions and unresolved-question IDs.
> - `ARCHITECTURE.md` records architecture progressively. **Architecture design is still in progress; this tracker does not imply that it is complete.**
> - Do not infer implementation progress from design documents, generated code, or a task plan.
> - The owner performs local build/runtime verification. Claude must not claim that a build or runtime test passed unless the owner reports that result.

## 1. Project context

- Project: **Tech terror**
- Language/framework: Haxe / HaxeFlixel
- Target: Web
- Owner's local build command: `lime test web`
- Build and runtime verification: performed locally by the owner
- Current implementation status: **Not assessed by this tracker.** Inspect the current source and obtain the owner's latest test results before reporting implementation status.
- Current design phase: **Architecture design in progress.** Do not treat the proposed M0–M11 pipeline as approved or ready to execute until the owner approves the relevant design and implementation plan.

## 2. Status definitions

Use only these meanings when updating the pipeline:

- **NOT ASSESSED** — no reliable implementation review has been recorded.
- **IN PROGRESS** — the owner-approved task is actively being implemented.
- **BLOCKED** — work cannot be completed responsibly until the listed design question or dependency is resolved.
- **DONE — STATIC REVIEW** — the stated scope has been reviewed in source, but no owner runtime verification is implied.
- **DONE — OWNER VERIFIED** — the owner has explicitly reported successful local build/runtime verification against the stated acceptance criteria.
- **DEFERRED** — the owner has explicitly postponed the stage.

A stage must not be marked **DONE** merely because a design document, code draft, or implementation plan exists. Record partial completion and remaining work when appropriate.

## 3. Proposed implementation pipeline — pending owner approval

The M0–M11 stages below reflect the proposed pipeline in `PROJECT_SPEC.md` §10. They are planning references, not an approved schedule, final architecture, or evidence that implementation has started. Stage order and dependencies may change after architecture discussion.

| ID | Stage | Objective | Known design dependencies / blockers | Current status |
|---|---|---|---|---|
| M0 | State skeleton | Establish startup and state transitions with placeholders | Architecture/state structure is not finalized. Resolve or explicitly accept the Play → Menu transition discrepancy (U-013); confirm the intended transition set before implementation. | NOT ASSESSED |
| M1 | Song data loading | Read the song list and song metadata/resources | Exact metadata and asset conventions need to be checked against U-001. Menu song-length source is unresolved (U-003). | NOT ASSESSED |
| M2 | Menu UI | Display and select songs; show difficulty and saved result information | Depends on M1. Song-length source is unresolved (U-003). Menu-to-Play/Editor data handoff should follow approved architecture. | NOT ASSESSED |
| M3 | Persistence | Persist volume and player results | Volume persistence is specified. Result persistence details must respect the unresolved result formulas/data in U-006. Do not assume chart/editor persistence belongs here; see U-002. | NOT ASSESSED |
| M4 | Chart model | Define and load chart data; validate it | BLOCKED by U-001 (exact chart schema/files) and U-002 (relationship between shipped charts, Editor saves, and Play loading). | BLOCKED |
| M5 | Play core | Move/spawn notes, synchronize to target time, recycle notes, and clean up on exit | Architecture and object ownership/lifecycle are still being designed. U-004 leaves the Line-to-NoteGenerator relationship unresolved. Audio synchronization and cleanup details need an approved design. | NOT ASSESSED |
| M6 | Input and rating | Handle key presses, simultaneous hits, rating windows, and Miss | BLOCKED by U-005 (timing convention/boundaries/Miss deadline) and U-010 (press with no eligible note). Depends on approved lane/input architecture. | BLOCKED |
| M7 | PlayerStats | Calculate score, health, beat multiplier, and lose condition | BLOCKED by U-007 (initial health/cap/clamping/Miss multiplier), U-008 (final point/healPoint defaults), and U-009 (beat strength for other time signatures). | BLOCKED |
| M8 | Pause/Setting | Implement Pause sub-state, Resume, Restart, and volume control | U-014 (key to open Pause/Setting) is unresolved. Depends on approved sub-state and restart/lifecycle design. Volume persistence is specified; avoid conflating it with unresolved chart persistence. | BLOCKED |
| M9 | Result | Display rating counts and score; store results per difficulty | BLOCKED by U-006 (accuracy/rank/max-combo/clear-pass formulas). Depends on the approved result data and persistence design. | BLOCKED |
| M10 | Editor | Place/edit notes and parameters; navigate; save/load charts | BLOCKED by U-001 and U-002 (chart format and save/load relationship), U-011 (0.25 subdivision example), and U-012 (meaning of “2 nhịp”, “bar”, and navigation step). | BLOCKED |
| M11 | Polish and verification | Tune performance, check cleanup, and playtest | Depends on the relevant gameplay/editor stages being implemented. Owner performs and reports local build/runtime and playtest verification. | NOT ASSESSED |

### 3.1 Cross-stage notes

- U-013 and U-014 are state/input questions; do not silently choose a transition or pause key.
- U-001 and U-002 affect both chart loading and Editor save/load. Resolve them before treating M4 or M10 as implementation-ready.
- U-004 may affect the Play object model. Do not choose one versus multiple `NoteGenerator` instances per `Line` without the owner's decision.
- U-005 and U-010 affect input judgement; do not implement guessed boundary or no-note-press behavior as if confirmed.
- U-006 through U-009 affect scoring, health, beat weighting, and result calculations. Keep provisional values and formulas visibly provisional until confirmed.
- A blocker can be cleared only when its question is answered by the owner or explicitly accepted as a documented assumption/proposal for a limited implementation scope.

## 4. Active task

Update this section only when a concrete task has been agreed.

- **Task:** None recorded.
- **Owner-approved scope:** None recorded.
- **Files being changed:** None recorded.
- **Acceptance criteria:** None recorded.
- **Related pipeline stage / unresolved IDs:** None recorded.

Do not fill this section with an inferred task. For architecture work, record the exact subsystem/topic being discussed and the decisions the owner has approved.

## 5. Owner verification log

Only record tests and outcomes explicitly reported by the owner. Claude may record static inspection separately in a session handoff, but must not convert it into runtime verification.

| Date | Build/runtime or playtest performed by owner | Result reported by owner | Scope / notes |
|---|---|---|---|
| — | No result recorded. | — | — |

## 6. Session handoff template

Copy this template for a meaningful implementation or design session. Delete unused placeholders rather than filling them with guesses.

### Session — YYYY-MM-DD

**Task / design topic**
- ...

**Owner-approved scope**
- ...

**Completed in this session**
- ...

**Modified files**
- ...

**Static review performed**
- ...

**Build/runtime verification**
- Claude did not build or run the project.
- Owner-reported result: ... / Not reported.

**Architecture decisions approved by owner**
- ...

**Other confirmed decisions**
- ...

**Unresolved questions / blockers**
- ...

**Pipeline status changes**
- Stage and previous → new status, with evidence: ...

**Next step**
- ...
