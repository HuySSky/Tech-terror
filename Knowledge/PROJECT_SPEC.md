# PROJECT_SPEC — Tech terror

> **Source of truth for requirements and design.** Keep these categories strictly separate:
> - **Confirmed:** stated in the supplied design documents or explicitly decided by the owner.
> - **Unresolved:** not decided; do not guess.
> - **Assumptions:** provisional interpretations that need confirmation.
> - **Proposed:** suggestions not yet approved.
>
> Source documents represented in this specification:
> `Tech terror.pdf` (gameplay), `Tech terror low design.pdf` (system), `Thiết kế đối tượng.pdf` (object design), `Yêu cầu kỹ thuật.pdf` (technical requirements), `Tech terror.drawio.pdf` (diagram), and owner decisions in update prompts.
>
> **Status:** specification only. Do not infer that implementation is complete. Source-code observations are recorded separately in §9.

---

## 0. Development workflow

1. **Design** — continue discussing the architecture, module responsibilities, system behavior/interactions, and objects. Architecture design is still in progress.
2. **Review** — check the interpretation against the supplied design material and discuss technical choices with the owner.
3. **Record** — record only owner-approved decisions. Keep proposals, assumptions, and unresolved questions visibly separate.
4. **Plan implementation** — define the objective, scope, dependencies, completion criteria, and tests for a small task.
5. **Implement incrementally** — proceed only after the relevant design and task scope are approved (see §10 for the proposed pipeline).

Rules:
- Significant design or implementation tasks require owner review and approval before coding.
- Do not treat the proposed pipeline in §10 as an approved schedule.
- Small tasks can use brief planning, but must still respect confirmed requirements and unresolved dependencies.
- The owner performs local build/runtime verification. Do not claim compilation or runtime success unless the owner reports it.
- Conflicts between source documents, code, and this specification must be reported with the conflicting statements; do not silently resolve them.
- Do not fill gaps in the architecture by inferring class boundaries, ownership, interfaces, or data flow.

---

## 1. Project overview — Confirmed

- Name: **Tech terror**.
- Offline, single-player **drum** rhythm game (players hit drum notes, not melody), built for a faculty event.
- Stack: Haxe + HaxeFlixel.
- Target: Web.
- Build command used by the owner: `lime test web`.
- Entry point: `Main.hx`.
- Drum gameplay uses tighter timing windows than typical rhythm games.
- Priorities: processing speed and frame rate (minimal lag).
- RAM: no hard budget during a level, but **leaving `PlayState` must delete all objects created in it**.
- Out of scope: visual effects ("Hiệu ứng") and audio-latency calibration.
- Directory structure:
  - `source/` — code
  - `assets/data/` — saved data/config
  - `assets/songs/` — songs and levels
  - `assets/images/` — sprites
  - `assets/music/` — state/menu music
  - `assets/sounds/` — state SFX

---

## 2. Gameplay — Confirmed

### 2.1 Definitions

- **Note:** a key prompt that spawns and travels toward the hit line.
- **Hit line (vạch nhịp):** the vertical line notes approach.
- **Timing:** the time offset between the moment a note is hit and its exact target time.
- **Hit input:** the key used to hit a note.

### 2.2 Mechanics

- 3 difficulties: Easy, Medium, Hard. **Each difficulty has its own chart.**
- Each **lane** (horizontal row, "input line") has one key, **assigned by the level designer**.
- Lane count varies per song.
- Keys are shown to the player at the start of a level; players cannot remap them.
- **Simultaneous hits are supported** and are normal gameplay.
- A held key registers **only its initial press** (use HaxeFlixel `justPressed`).
- A health bar exists.
- Player results are saved.
- A result screen is shown at the end.
- Notes are authored by the level designer in the Editor; note times are stored in a file (JSON tentatively) and read back to spawn notes.

### 2.3 Hit evaluation

- Pressing a key compares press time with the note's target time.
- A note still far from the hit line is not a valid hit and stays on screen.
- A note that goes too far past the hit line is a **Miss**.
- Five ratings are available on a successful hit.

`secPerBeat = 60 / bpm`

| Rating | Condition on `timing` |
|---|---|
| Perfect (Hoàn hảo) | `-2% · secPerBeat ≤ timing ≤ 2% · secPerBeat` |
| Precise (Chuẩn xác) | `-4% · secPerBeat ≤ timing ≤ 4% · secPerBeat` |
| Tight (Chặt) | `-6% · secPerBeat ≤ timing ≤ 6% · secPerBeat` |
| Loose (Lỏng) | `-10% · secPerBeat ≤ timing ≤ 10% · secPerBeat` |
| Off (Lệch) | `-14% · secPerBeat ≤ timing ≤ 14% · secPerBeat` |

`timing` is used consistently; the source's remaining `distance` labels are replaced.

Windows are to be tuned with feedback from drummers and by comparison with other games (as noted in the source).

### 2.4 Scoring and health

Initial defaults recorded in the source design (provisional; tune via playtests):
- `point = 100`
- `healPoint = 10`

These are starting values, not owner-confirmed final constants. See §8.8. Do not silently treat them as immutable values.

| Rating | point | healPoint |
|---|---:|---:|
| Perfect | +120% | +120% |
| Precise | +100% | +100% |
| Tight | +75% | +75% |
| Loose | +50% | +30% |
| Off | +25% | +10% |
| Miss | +0% | −75% |

- Beat multiplier `heso`: strong = 1.2, medium-strong = 1.1, weak = 1.0.
- `point *= heso; healPoint *= heso`.
- Results are added to `total_point` and `curHealth`.
- Player loses when `curHealth <= 0`.
- `maxHealth = bpm`.

### 2.5 Beat strength

- Conventional-music rules are the intended direction.
- The Editor computes beat strength automatically.
- Defined patterns only:
  - **4/4:** strong, weak, medium-strong, weak.
  - **3/4:** strong, weak, weak.
  - **2/4:** strong, weak.
- Other time signatures are not yet specified; see §8.

### 2.6 Result screen content — Confirmed

- Count of each rating (Perfect, Precise, Tight, Loose, Off, …).
- Player's score.
- Stored per difficulty in `songResult`:
  - difficulty
  - score
  - accuracy
  - rank
  - max combo
  - status (clear/pass)

---

## 3. States and transitions — Confirmed, with noted conflicts

States: Loading, Menu, Play, Editor (`EditLevel`), Result. **Setting/Pause is a sub-state, only during Play.** Architecture details follow the approved design; not every state is required to be a standalone `FlxState`.

| From → To | Trigger / data |
|---|---|
| Startup → Loading | `Main.hx` starts at `LoadingState` |
| Loading → Menu | Enter or Space |
| Menu → Loading | Esc |
| Menu → Play | Enter; passes selected song's info (and difficulty) |
| Menu → Editor | key `7`; passes selected song |
| Play → Result | on finishing the level (placeholder: Enter) |
| Play → Editor | key `7` |
| Play → Setting (sub-state) | trigger key unspecified |
| Result → Menu | Enter, Esc, Space (technical-requirements doc lists only Enter, Esc; object-design doc adds Space) |
| Play → Menu | Esc — appears in the Play placeholder but **not in the source transition list**; see §8 |

Placeholders (current plan):
- Loading shows "Press enter to play".
- Play shows text with Esc → Menu, Enter → Result.
- Editor shows text with Esc → Menu.

### Menu song-selection data flow

Diagram reference (`Tech terror.drawio.pdf`, Loading/Menu song-selection flow):

1. Menu initializes the song group and song objects.
2. Read the song name list from `assets/songs/songs.txt`.
3. Receive the name list.
4. Use each name to access that song's data in `assets/songs/[song name]`.
5. Receive the data (JSON plus images/audio).
6. Create a song object from the data.
7. Add it to the song group.

Menu input:
- Left/Right: select song.
- Enter: Play.
- `7`: Editor.
- Esc: Loading.
- Result is shown from Play.

---

## 4. Module and object design — Confirmed concepts

Gameplay concepts:
- `GameSystem`
- `InputSystem`
- `NoteSystem` (spawning, hit, miss, timing, rating)
- `PlayerStats` (Score, Health)
- `LevelEditor` / `LevelSystem`
- `ResultSystem`
- `PauseSystem`
- `SettingSystem`

These are **design concepts/names**, not a requirement for one class per concept. Exact class layout is decided during implementation planning.

### 4.1 Loading

- Welcome visual (placeholder text).
- Enter/Space → Menu.
- No data flow.

### 4.2 Menu

#### `songData`

Contains:
- name
- artist
- bpm
- menu preview start time (hook segment)
- difficulty → `scrollSpeed` map

#### `songObject`

"CD/album" object. Holds:
- `songData`
- per-song results
- cover image object
- music

`new(songData)` finds music and cover in the song folder.

#### `songScrollLine`

Group of `songObject`s shown as one long row at screen centre:
- selected song is centred and enlarged
- defaults to the first song
- `add(songObject)`
- `next()` (→ key)
- `pre()` (← key)
- `getCurrentSong()` returning the object and the data (two functions)

#### `songResult`

Per-difficulty record:
- score
- accuracy
- rank
- max combo
- status (clear/pass)

#### Menu display and behavior

- Menu shows (BM1): name, BPM, length, cover.
- Menu shows results (BM2): song info and difficulty–score.
- Tab changes difficulty (acts on the `songObject`'s difficulty).

#### Menu data flow

`songs.txt` → traverse song folders → read `[song_name]_data.json` → related image/audio → `songObject` → add to `songScrollLine`.

### 4.3 Play

#### `Note`

- Sprite.
- `timeToHit`.

#### `NoteGenerator`

- `Group<Note>`.
- Reads `timeToHit` from the chart.
- Recycles notes via the library.
- Computes spawn position from scroll velocity (`TimeScale`) and pre-spawn time (default **2 s**).

#### `Line`

- name (maps to sprite)
- importance coefficient
- input key
- NoteGenerator

`PlayState` checks lines every frame to spawn notes.

Also included in Play design:
- input handling (hit notes)
- health and rating display (domain)
- UI

### 4.4 Pause / Setting — sub-state, Play only

- Resume: Esc, or Enter while Resume is selected.
- Restart: Enter while Restart is selected; recreates `PlayState` from `songData`.
- Volume:
  - Left/Right
  - Shift + Left/Right
  - holding Left/Right
- Items are highlighted when selected.
- Parameter is shown next to an item if any (BM3).
- Volume is persisted via `FlxSave` and applies across screens.

### 4.5 Result

- Shows song info, difficulty, and score data.
- Uses `songData` → `songObject` → find result.
- Returns to Menu.

### 4.6 Editor

- Rows are drum lanes.
- Columns are on/off note positions.
- Functions:
  - place notes (shows 2 "nhịp" at a time)
  - edit scroll speed, BPM, time signature, and each line's input key
  - navigate to the next "bar"/"nhịp"
  - save
  - load
- Visual effects are out of scope.

Column rule as written in the source:
- `columns = beats × note-length ("trường độ")`
- Examples: 4/4 with 1 → 4 columns; with 0.5 → 8 columns; with 0.25 → "12" (flagged in §8; do not silently correct).

---

## 5. Data and persistence

### 5.1 Recorded data requirements and conventions

The following file/data conventions are recorded in the supplied design material:

- `assets/songs/songs.txt` lists song names (currently: `Billie Jean`).
- Each song folder is `assets/songs/[song_name]/`.
- Each song folder is intended to contain:
  - `[song_name]_data.json`
  - charts (one per difficulty)
  - audio
  - images
  - other related files as needed
- The existing `Billie Jean_data.json` contains these fields:
  - `name`
  - `artist`
  - `bpm`
  - `timeSignature`
  - `previewStart`
  - `scrollSpeed { easy, medium, hard }`
- A chart has multiple lanes.
- Each lane stores timing values for its notes.
- Each lane has a key assigned by the designer.
- Volume settings are intended to persist via HaxeFlixel `FlxSave`.
- Player results are required to be saved, but their persistence mechanism is not confirmed here.
- Editor/level chart persistence and the relationship between shipped JSON charts and saved charts remain unresolved; see §8.1–2 and §8.16.
- `Config.hx` is unnecessary; the owner plans to delete it manually. Nothing may depend on it.

### 5.2 Unresolved

Exact chart schemas, filenames, formats, audio/image conventions, Editor-save behavior, and persistence mechanisms remain unresolved where listed in §8. In particular, do not infer that `FlxSave` is confirmed for chart/editor saves or player results merely because it is used for volume.

---

## 6. Confirmed technical decisions — summary

1. `Main.hx` is intended to start at `LoadingState`.
2. No `Config.hx` dependency; the owner plans to delete it manually.
3. Volume settings are intended to persist via `FlxSave`. This does not confirm `FlxSave` for chart/editor saves or player results.
4. No audio-latency calibration.
5. One chart per difficulty; per-song folder layout as described in §5.1. Exact chart schema and filenames remain unresolved.
6. Variable lane count; per-lane designer-assigned key; simultaneous hits; a held key registers only its initial press (`justPressed`).
7. Editor is reachable from both Menu and Play; Setting/Pause is a Play-only sub-state. The Pause trigger key remains unspecified.
8. Use `timing` consistently in the rating table.
9. Objects created for `PlayState` must be deleted/cleaned up when leaving it; note recycling is part of the design. Exact ownership and cleanup implementation remain open.

---

## 7. Assumptions — not confirmed

- Notes scroll horizontally toward a vertical hit line (inferred from "horizontal lanes" and "vertical line").
- Tap notes only (no hold notes); a key press with no note in range is not a hit (penalty undefined).
- "Bar" in the Editor means a measure; "phách" means a beat (see §8 on intended unit).
- `songResult` is stored in `FlxSave` (web: browser storage).
- Editor-saved charts must be reachable by the game; since a web build cannot write into `assets/`, saved data likely lives in `FlxSave` or is exported/downloaded — needs decision.
- Initial `point`/`healPoint` live in a code constant or small data file ("hardcoded in a file").

---

## 8. Unresolved questions — do not guess

### Data and files

1. Exact chart JSON schema, chart filenames/formats, audio/image filenames/formats, and number of audio tracks per song.
2. Relationship between `FlxSave` and the tentative JSON chart format: is JSON authored/shipped in `assets/` while `FlxSave` holds Editor saves? How does a saved chart reach Play?
3. `songData` lacks song **length**, yet the Menu (BM1) shows it — source of length undefined.

### Gameplay

4. Meaning/formula of the `Line` **importance coefficient**. Discrepancy: object design says each `Line` holds **one** `NoteGenerator`; technical requirements say **NoteGenerators** (plural).
5. Exact signed convention for `timing` (early vs late), boundary handling at thresholds (`≤` vs `<`), and the **deadline for Miss**.
6. Accuracy, rank, max-combo, and clear/pass formulas.
7. Initial `curHealth`, health cap behavior (clamp at `maxHealth`?), and whether the Miss penalty is also multiplied by `heso`.
8. Exact values and implementation location for initial `point`/`healPoint` (defaults 100 / 10 are tentative).
9. Beat-strength rules for time signatures other than 2/4, 3/4, and 4/4.
10. Penalty (if any) for pressing a key when no note is in range.

### Editor

11. The 0.25 subdivision example states 12 columns for 4 beats at 2⁻²-beat spacing — flagged for confirmation; do not correct silently.
12. Terms `2 nhịp`, next `bar`, and "one nhịp per move": intended unit (beat or bar)?

### States and input

13. State-transition list omits **Play → Menu**, although the Play placeholder uses Esc to return to Menu.
14. The key that opens Pause/Setting during Play is unspecified.
15. Result → Menu keys differ between documents (Space).

---

## 9. Code vs specification discrepancies — report only

Observed in the supplied files at the time this specification was written; re-check current source before relying on these observations. Do not change code or spec silently.

- `Main.hx` currently starts at `PlayState` (spec: `LoadingState`).
- `Config.hx` is in `assets/data/` (not on the classpath, and slated for deletion by the owner).
- `PlayState`, `MenuState`, `EditorState`, `ResultState`, and `LoadingState` exist as placeholders.
- `PlayState` and `MenuState` map key `7` → Editor and Esc as described in the source observations.
- `AssetPaths.hx` is present.
- Menu design says Esc → Loading; current `MenuState` matches.
- `MenuState` placeholder text and transitions are consistent with the Menu rows.
- Play → Menu via Esc is implemented in the placeholder but unlisted in the source transition list; see §8.13.

---

## 10. Implementation pipeline — Proposed, needs owner approval

Each module is implemented only after its plan is approved. Build/runtime verification is performed locally by the owner using `lime test web`; report only results actually observed.

| # | Module | Objective | Scope | Completion criteria | Tests |
|---|---|---|---|---|---|
| M0 | State skeleton | Correct app flow with placeholders | `Main.hx` → Loading; transitions per §3; Setting sub-state stub | Every confirmed transition works; unlisted ones noted | Compile; manually walk through transitions |
| M1 | Song data loading | Load song list and data | `songs.txt` reader, `songData`, `songObject` (resource lookup) | Billie Jean loads; missing files handled gracefully | Compile; trace parsed data; missing-file case |
| M2 | Menu UI | Song selection | `songScrollLine`, centred enlarged selection, Tab difficulty, BM1/BM2 display | Scroll, select, difficulty change, pass song to Play/Editor | Manual interaction; edge cases: one song, many songs |
| M3 | Persistence | Save/load data | `FlxSave` wrapper for volume and `songResult` (schema per §8.2) | Values survive a page reload | Manual browser reload test |
| M4 | Chart model | Define chart data | Requires §8.1–2 decisions; loader/validator | Chart for each difficulty loads into memory | Parse checks with sample charts; malformed input |
| M5 | Play core | Notes travel to hit line | `Line`, `Note`, `NoteGenerator` (recycling, 2 s pre-spawn), audio sync | Notes arrive at `timeToHit`; cleanup on exit | Visual check; timing log vs audio; memory/cleanup check |
| M6 | Input and rating | Hit notes and rate them | `justPressed`, simultaneous hits, rating windows, Miss | Ratings match §2.3 (pending §8.5) | Boundary checks; manual test |
| M7 | PlayerStats | Score/health | Point/heal formulas, `heso`, lose condition | Matches §2.4 | Calculation checks; lose at `curHealth <= 0` |
| M8 | Pause/Setting | Pause sub-state | Resume, Restart, volume (persisted) | All three work; volume persists | Manual test; restart leaves no leaked objects |
| M9 | Result | Show results and save | Rating counts, score, `songResult` save | Data shown and stored per difficulty (pending §8.6) | Manual test; reload check |
| M10 | Editor | Author charts | Grid, place note, parameters, key assignment, navigation, save/load (pending §8.2, §8.11–12) | Round-trip: edit → save → load → play | Round-trip test; invalid input |
| M11 | Polish and verification | Stability | Performance, RAM cleanup on leaving Play, playtest tuning | No leaks or lag in playtest | Full manual play of each difficulty |

---

## 11. Change log

- Initial version: merged the five design documents with the owner's confirmed decisions; unresolved items recorded without guessing.
- Revised version: reorganized for direct implementation use while preserving the recorded gameplay rules, assumptions, discrepancies, and open questions.
- Current revision: clarified that architecture design is still in progress; separated the confirmed volume-persistence choice from unresolved chart/editor and result persistence; marked the initial `point`/`healPoint` values as provisional; and clarified that the implementation pipeline is proposed rather than approved. No unresolved design item is promoted to confirmed.
