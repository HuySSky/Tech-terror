# DECISIONS — Tech terror

> This file records decisions explicitly confirmed by the project owner.
> `PROJECT_SPEC.md` contains the fuller requirements, design notes, assumptions, and unresolved questions.
> Do not promote a proposal, assumption, placeholder, or convenient implementation choice into a confirmed decision.

## Confirmed decisions

| ID | Decision | Detail |
|---|---|---|
| D-001 | Project identity | The project name is **Tech terror**. |
| D-002 | Game type | Offline, single-player drum rhythm game for a faculty event; gameplay is not based on melody. |
| D-003 | Technology | Haxe + HaxeFlixel. |
| D-004 | Target/build | Web target; the owner builds locally with `lime test web`; entry point is `Main.hx`. |
| D-005 | Startup design | `Main.hx` is intended to start at `LoadingState`. |
| D-006 | Performance priority | Processing speed and frame rate are important priorities. |
| D-007 | PlayState cleanup requirement | Objects created for `PlayState` must be cleaned up when leaving it. The exact ownership and cleanup mechanism are not specified here. |
| D-008 | Out of scope | Visual effects and audio-latency calibration are out of scope for the current project scope. |
| D-009 | Difficulties | Easy, Medium, and Hard; each difficulty has its own chart. |
| D-010 | Lanes and keys | Lane count may vary by song; each lane has a level-designer-assigned key; player key remapping is not supported; show the keys at level start. |
| D-011 | Input | A held key registers only its initial press; use HaxeFlixel's `justPressed` behavior as specified in the design. |
| D-012 | Simultaneous hits | Simultaneous note hits are supported as normal gameplay. |
| D-013 | Editor purpose | The level designer authors notes in the Editor, and chart data is intended to be available to gameplay. The exact persistence and transfer mechanism remains unresolved. |
| D-014 | Setting/Pause placement | Setting/Pause is intended to exist as a sub-state during Play. |
| D-015 | Volume persistence | `FlxSave` is intended to persist volume settings. This decision does **not** confirm its use for chart/editor saves or player results. |
| D-016 | Song organization | `assets/songs/songs.txt` lists song names; each song has its own folder for its metadata, charts, audio, and images. Exact filenames and schemas remain unresolved. |
| D-017 | Config.hx | `Config.hx` is unnecessary; the owner plans to delete it manually. Do not create code dependencies on it. |
| D-018 | Judgement variable | Use `timing` consistently in the rating table rather than the remaining source label `distance`. |
| D-019 | Beat-strength patterns | The 4/4, 3/4, and 2/4 beat-strength patterns are recorded in `PROJECT_SPEC.md` §2.5. |

## Confirmed gameplay rules

| Item | Rule |
|---|---|
| Beat duration | `secPerBeat = 60 / bpm` |
| Perfect window | `±2% × secPerBeat` |
| Precise window | `±4% × secPerBeat` |
| Tight window | `±6% × secPerBeat` |
| Loose window | `±10% × secPerBeat` |
| Off window | `±14% × secPerBeat` |
| Rating multipliers | Perfect 120%; Precise 100%; Tight 75%; Loose 50%; Off 25%; Miss 0% |
| Heal multipliers | Perfect 120%; Precise 100%; Tight 75%; Loose 30%; Off 10%; Miss −75% |
| Beat multiplier | Strong 1.2; medium-strong 1.1; weak 1.0 |
| Multiplier application | `point *= heso`; `healPoint *= heso` |
| Health loss condition | `curHealth <= 0` |
| Maximum health relation | `maxHealth = bpm` |
| Note pre-spawn | Default 2 seconds |

## Provisional values — not owner-confirmed constants

The source design currently gives these initial values, but they are described as defaults to be tuned through playtesting. Do not treat them as final balancing decisions:

| Item | Provisional value | Status |
|---|---:|---|
| `point` | `100` | Initial default; final value unresolved |
| `healPoint` | `10` | Initial default; final value unresolved |

Do not silently hardcode these as immutable design constants. See `PROJECT_SPEC.md` and unresolved question U-008.

## Unresolved — do not guess

See `PROJECT_SPEC.md` §8 for the full wording and current context.

| ID | Question |
|---|---|
| U-001 | Exact chart JSON schema; chart filenames/formats; audio/image filenames/formats; number of audio tracks. |
| U-002 | Relationship between shipped JSON charts and Editor-created charts; persistence format, save location, and how saved charts are loaded into Play. |
| U-003 | Source of the song length displayed in Menu. |
| U-004 | Line importance coefficient; whether a Line has one or multiple `NoteGenerator` instances. |
| U-005 | Signed timing convention, inclusive/exclusive judgement boundaries, and Miss deadline. |
| U-006 | Accuracy, rank, max-combo, and clear/pass formulas. |
| U-007 | Initial `curHealth`, health cap/clamping, and whether the Miss penalty uses `heso`. |
| U-008 | Final `point`/`healPoint` values and where/how those values are configured. |
| U-009 | Beat strength for time signatures other than 2/4, 3/4, and 4/4. |
| U-010 | Penalty for a key press when no note is in range. |
| U-011 | Editor 0.25-subdivision column-count example. |
| U-012 | Meaning of “2 nhịp”, “bar”, and “one nhịp per move”. |
| U-013 | Play → Menu via Esc appears in a placeholder but is missing from the transition list. |
| U-014 | Key used to open Pause/Setting during Play. |
| U-015 | Result → Menu includes Space in one source but not another. |
| U-016 | Whether and how player results are persisted. |

## Assumptions — not decisions

- Horizontal note movement toward a vertical hit line.
- Tap notes only.
- `songResult` storage details and persistence mechanism.
- How Editor-created charts are persisted/exported in a Web build.
- Where the initial `point` and `healPoint` values are stored.

## Proposed implementation pipeline

The M0–M11 pipeline in `PROJECT_SPEC.md` §10 is proposed, not an owner-approved implementation schedule. Do not treat its order, dependencies, or completion status as approved without checking with the owner.

## Maintenance rules

- Add an entry to **Confirmed decisions** only after the owner explicitly approves it.
- Keep tentative values and implementation suggestions outside the confirmed-decision tables.
- When a decision changes, preserve its ID and update its status/detail; do not silently rewrite history.
- If this file conflicts with `PROJECT_SPEC.md` or the source design documents, report the exact conflict and ask the owner rather than choosing one silently.
- Do not use this index to fill gaps in the architecture. Architecture design is still in progress; see `ARCHITECTURE.md`.
