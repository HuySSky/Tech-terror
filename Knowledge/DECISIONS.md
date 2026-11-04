# DECISIONS — Tech terror

> This is a concise decision index. `PROJECT_SPEC.md` remains the detailed source of truth.
> Do not promote assumptions, proposals, placeholders, or unresolved questions to confirmed decisions.

## Confirmed

| ID | Decision | Detail |
|---|---|---|
| D-001 | Project identity | Name is **Tech terror**. |
| D-002 | Game type | Offline, single-player drum rhythm game for a faculty event; not melody gameplay. |
| D-003 | Technology | Haxe + HaxeFlixel. |
| D-004 | Target/build | Web target; owner uses `lime test web`; entry point `Main.hx`. |
| D-005 | Startup design | `Main.hx` should start at `LoadingState`. |
| D-006 | Performance priority | Processing speed and frame rate are important. |
| D-007 | PlayState cleanup | Leaving `PlayState` must delete all objects created in it. |
| D-008 | Out of scope | Visual effects and audio-latency calibration. |
| D-009 | Difficulties | Easy, Medium, Hard; each has its own chart. |
| D-010 | Lanes and keys | Variable lane count per song; one designer-assigned key per lane; no player remapping; show keys at level start. |
| D-011 | Input | Held key registers only its initial press; use HaxeFlixel `justPressed`. |
| D-012 | Simultaneous hits | Supported as normal gameplay. |
| D-013 | Editor | Level designer authors notes in Editor; chart data is stored and read back for gameplay. |
| D-014 | Setting/Pause | Exists only as a sub-state during Play. |
| D-015 | Persistence | `FlxSave` is used for persistent data, including volume, level/editor saves, and player results. |
| D-016 | Song organization | `assets/songs/songs.txt` lists song names; each song has its own folder and metadata JSON, charts, audio, and images. |
| D-017 | Config.hx | Unnecessary; owner deletes it manually. No code may depend on it. |
| D-018 | Judgement variable | Use `timing` consistently in the rating table, not the remaining source labels `distance`. |
| D-019 | Beat strength patterns | 4/4, 3/4, and 2/4 patterns are specified in `PROJECT_SPEC.md` §2.5. |

## Confirmed numerical rules (retain exact source meaning)

| Item | Rule |
|---|---|
| Beat duration | `secPerBeat = 60 / bpm` |
| Perfect | `±2% · secPerBeat` |
| Precise | `±4% · secPerBeat` |
| Tight | `±6% · secPerBeat` |
| Loose | `±10% · secPerBeat` |
| Off | `±14% · secPerBeat` |
| Initial point default | `point = 100` (hardcoded default; tune via playtests) |
| Initial heal default | `healPoint = 10` (hardcoded default; tune via playtests) |
| Rating multipliers | Perfect 120%; Precise 100%; Tight 75%; Loose 50%; Off 25%; Miss 0% |
| Heal multipliers | Perfect 120%; Precise 100%; Tight 75%; Loose 30%; Off 10%; Miss −75% |
| Beat multiplier | strong 1.2; medium-strong 1.1; weak 1.0 |
| Multiplier application | `point *= heso; healPoint *= heso` |
| Health loss | `curHealth <= 0` |
| Health maximum | `maxHealth = bpm` |
| Note pre-spawn | default 2 seconds |

## Unresolved — do not guess

See `PROJECT_SPEC.md` §8 for full wording.

| ID | Question |
|---|---|
| U-001 | Exact chart JSON schema, chart filenames/formats, audio/image filenames/formats, number of audio tracks. |
| U-002 | Relationship between shipped JSON charts and `FlxSave` editor saves; how saved charts reach Play. |
| U-003 | Source of song length displayed in Menu. |
| U-004 | Line importance coefficient; one versus multiple NoteGenerators per Line. |
| U-005 | Signed timing convention, inclusive/exclusive boundaries, Miss deadline. |
| U-006 | Accuracy, rank, max-combo, clear/pass formulas. |
| U-007 | Initial `curHealth`, health cap/clamping, whether Miss penalty uses `heso`. |
| U-008 | Final initial `point`/`healPoint` values and implementation location. |
| U-009 | Beat strength for time signatures other than 2/4, 3/4, 4/4. |
| U-010 | Penalty for key press when no note is in range. |
| U-011 | Editor 0.25 subdivision column count example. |
| U-012 | Meaning of "2 nhịp", "bar", and "one nhịp per move". |
| U-013 | Play → Menu via Esc appears in placeholder but is missing from transition list. |
| U-014 | Key to open Pause/Setting during Play. |
| U-015 | Result → Menu includes Space in one source but not another. |

## Assumptions — not decisions

- Horizontal note movement toward a vertical hit line.
- Tap notes only.
- `songResult` storage details in `FlxSave`.
- How Editor-saved charts are persisted/exported in a Web build.
- Where initial point/heal defaults are physically stored.

## Proposed implementation pipeline

The M0–M11 pipeline is proposed and needs owner approval. See `PROJECT_SPEC.md` §10. Do not treat its order or completion status as approved/current without checking with the owner.
