# ARCHITECTURE — Tech terror

> **STATUS: WORK IN PROGRESS — ARCHITECTURE DESIGN IS NOT COMPLETE**
>
> This document records the architecture-related information currently present in `PROJECT_SPEC.md` and the supplied design materials. The owner is still working through the architecture in greater depth. This is an evolving design record, **not an approved implementation blueprint**.
>
> Do not invent or finalize module boundaries, class responsibilities, object ownership, interfaces, call sequences, lifecycle rules, or detailed data flow where the sources do not specify them. A concept or object name does not, by itself, establish a class or module boundary.

## 1. Purpose and authority

- `PROJECT_SPEC.md` is the source of truth for requirements, confirmed design information, assumptions, proposals, and unresolved questions.
- This file is an architecture index and working record derived from the specification and supplied design materials. It is not an independent design authority.
- Architecture decisions must be discussed with the owner and approved before being treated as settled or used as the basis for implementation.
- When information is missing or inconsistent, preserve the gap and refer to the relevant section of `PROJECT_SPEC.md`; do not silently resolve it.

### 1.1 Status labels

Use these labels when adding architecture information:

- **Confirmed:** explicitly approved by the owner or stated as confirmed in the source specification.
- **Proposed:** a candidate design that still needs owner approval.
- **Assumption:** a provisional interpretation, not a decision.
- **Unresolved:** information that has not been decided or contains a conflict.

Do not promote Proposed, Assumption, or Unresolved information to Confirmed without the owner's approval.

## 2. Application structure — recorded context

### 2.1 Technology and entry point

- Language: Haxe.
- Framework: HaxeFlixel.
- Target: Web.
- Entry point: `Main.hx`.
- Intended startup: `Main.hx` should start `LoadingState`.
- Local build command used by the owner: `lime test web`.
- The owner builds and verifies the project locally. Do not claim to have compiled or runtime-tested it.

### 2.2 Project directories

```text
source/             Haxe source code
assets/
├── data/           Saved data/config
├── songs/          Songs and levels
├── images/         Sprites
├── music/          State/menu music
└── sounds/         State SFX
```

`Config.hx` is not part of the intended design. The owner plans to delete it manually. Do not create or retain dependencies on it.

## 3. States and transitions — incomplete design record

### 3.1 State and sub-state concepts named in the materials

- `Loading`
- `Menu`
- `Play`
- `Editor` (`EditLevel`)
- `Result`
- `Setting/Pause` — intended to exist as a sub-state during Play

These names record the current design concepts. They do **not** establish the final class structure or mean that each concept must be a standalone `FlxState`.

### 3.2 Primary intended flow recorded in the specification

```text
Startup
   |
   v
Loading <------ Menu
   |              |
   v              v
  Menu --------> Play
                  |
                  v
                Result
                  |
                  v
                 Menu
```

Additional paths currently recorded:

- Menu → Editor (key `7`; selected song is passed).
- Play → Editor (key `7`).
- Play → Setting sub-state (the trigger key is unresolved).
- Play → Menu via Esc appears in the placeholder implementation, but is absent from the source transition list. This discrepancy remains unresolved.

### 3.3 Still to be designed or confirmed

- Exact state and sub-state class structure.
- Which transitions are approved, including the Play → Menu discrepancy.
- How data is passed between states.
- Which component initiates and owns each transition.
- Object and resource cleanup responsibilities during transitions.
- Any unresolved transition keys and input behavior.

Do not complete this design independently. Discuss alternatives with the owner and record only approved decisions.

## 4. Gameplay system concepts — not approved module boundaries

The specification names the following concepts:

- `GameSystem`
- `InputSystem`
- `NoteSystem` — spawning, hit, miss, timing, and rating.
- `PlayerStats` — Score and Health.
- `LevelEditor` / `LevelSystem`
- `ResultSystem`
- `PauseSystem`
- `SettingSystem`

These are conceptual names from the design materials. Their exact responsibilities, relationships, and implementation form have not been finalized. Do not assume whether a concept should become a class, group, service, state, sub-state, or part of another component. Do not decide ownership or communication mechanisms without discussion.

## 5. Menu object design — recorded concepts

### 5.1 `songData`

Fields currently recorded:

- name
- artist
- bpm
- preview start time
- difficulty → `scrollSpeed` map

The existing `Billie Jean_data.json` fields are listed in `PROJECT_SPEC.md` §5. The exact data model and parsing/validation design remain subject to the unresolved questions in that specification.

### 5.2 `songObject`

Represents the CD/album object. The source design says it holds:

- `songData`
- per-song results
- cover image object
- music

The design says `new(songData)` finds the music and cover in the song folder. This records the stated behavior; it does not settle resource ownership, loading timing, error handling, or the final class interface.

### 5.3 `songScrollLine`

A row/group of song objects at screen centre. The recorded behavior is:

- selected song is centred and enlarged;
- initially selects the first song;
- `add(songObject)`;
- `next()` for Right;
- `pre()` for Left;
- current song object and current song data are returned through two functions.

The exact API, collection structure, and object relationships remain to be designed.

### 5.4 `songResult`

Per-difficulty data currently recorded:

- score
- accuracy
- rank
- max combo
- status (clear/pass)

Menu display currently recorded:

- BM1: name, BPM, length, cover.
- BM2: song information and difficulty–score results.
- Tab changes the selected song object's difficulty.

The source does not define the final result schema or where/how it is persisted. See `PROJECT_SPEC.md` §5 and §8.

## 6. Play object design — recorded concepts

### 6.1 `Note`

- Sprite.
- `timeToHit`.

### 6.2 `NoteGenerator`

- `Group<Note>`.
- Reads note `timeToHit` values from the chart.
- Recycles notes via the library.
- Computes spawn position from scroll velocity (`TimeScale`) and pre-spawn time (default 2 seconds).

### 6.3 `Line`

Fields currently recorded:

- name (maps to sprite)
- importance coefficient
- input key
- NoteGenerator

`PlayState` checks lines every frame to spawn notes.

**Unresolved discrepancy:** the object-design material describes one `NoteGenerator` per `Line`, while the technical requirements refer to `NoteGenerators` in plural. Do not choose one interpretation without the owner's decision. See `PROJECT_SPEC.md` §8.4.

### 6.4 Other Play responsibilities mentioned

- input handling;
- health and rating display;
- UI.

The sources do not yet define their class boundaries, ownership, update order, or detailed interactions. Do not invent those details.

## 7. Pause / Setting — incomplete design record

The current design records:

- Exists only as a sub-state during Play.
- Resume: Esc, or Enter while Resume is selected.
- Restart: Enter while Restart is selected; recreates PlayState from `songData`.
- Volume controls: Left/Right, Shift + Left/Right, and holding Left/Right.
- Selected item is highlighted.
- A parameter is displayed beside an item when applicable (BM3).
- Volume persists through `FlxSave` and applies across screens.

The key that opens this sub-state during Play is unresolved. The exact pause/resume mechanics, state ownership, and restart lifecycle are not specified here and must not be inferred.

## 8. Result — recorded behavior

The Result screen displays:

- song information;
- difficulty;
- score data.

The design flow is `songData` → `songObject` → find result, then return to Menu.

The formulas and persistence schema for result values remain unresolved where indicated in `PROJECT_SPEC.md` §8. Do not design a storage format or result calculation independently.

## 9. Editor — recorded behavior, details unresolved

The current design records:

- Rows represent drum lanes.
- Columns represent note on/off positions.
- Shows two "nhịp" at a time (the intended unit needs clarification).
- Edits scroll speed, BPM, time signature, and each line's input key.
- Navigates to the next "bar"/"nhịp" (the intended unit needs clarification).
- Saves and loads chart data.

The column-count example for 4/4 and note-length 0.25 is flagged as unresolved in `PROJECT_SPEC.md` §8.11. Do not silently correct or reinterpret it. The save/load format and how editor-created charts become available to gameplay are also unresolved.

## 10. Data and persistence — incomplete design record

### 10.1 Song and chart organization currently recorded

- `assets/songs/songs.txt` lists song names (currently: `Billie Jean`).
- Each song has a folder under `assets/songs/[song_name]/`.
- The folder contains `[song_name]_data.json`, charts (one per difficulty), audio, images, and other related files as needed.
- Existing metadata fields include `name`, `artist`, `bpm`, `timeSignature`, `previewStart`, and `scrollSpeed { easy, medium, hard }`.
- A chart has multiple lanes; each lane stores note timing values and has a key assigned by the level designer.

### 10.2 Unresolved persistence and schema details

Exact chart JSON schema, chart filenames/formats, audio/image filenames/formats, number of audio tracks, editor-save format, and the relationship between shipped JSON assets and `FlxSave` remain unresolved where noted in `PROJECT_SPEC.md` §8. Do not invent loaders, repositories, serializers, or save-system architecture.

The current `PROJECT_SPEC.md` contains a conflict between broad statements about `FlxSave` persistence and the unresolved chart/result persistence questions. Follow its latest explicit unresolved notes and raise the inconsistency rather than silently deciding a storage strategy.

## 11. Lifecycle and performance constraints

The design materials currently record:

- Processing speed and frame rate are priorities.
- There is no hard RAM budget during a level.
- Leaving `PlayState` must delete all objects created in it.
- Note recycling is part of the design.
- `NoteGenerator` pre-spawn time defaults to 2 seconds.

These are constraints/requirements, not a completed lifecycle architecture. The ownership tree, cleanup sequence, recycling implementation, and resource lifecycle have not been finalized. Verify HaxeFlixel APIs against the exact supplied library/version references before relying on them; do not guess API behavior.

## 12. Architecture topics for owner discussion

The following are discussion topics, not tasks for Claude to complete autonomously:

- state/sub-state structure and transitions;
- module responsibilities and boundaries;
- object ownership and lifecycle;
- communication between gameplay systems;
- song/chart data flow;
- input-to-judgement flow;
- score/health/result flow;
- Editor save/load flow;
- cleanup and note-recycling strategy.

For each topic:

1. Summarize what the source documents already say.
2. Identify the missing decisions and any conflicts.
3. Present technical options only when useful, with trade-offs and source/API support.
4. Ask the owner to choose or approve the design.
5. Update this file only after the decision is confirmed.

Do not create detailed module documents or implementation tasks merely to fill the directory or because a concept name exists. Create them after the relevant design has been discussed enough to make the document useful and the owner has approved its scope.

## 13. Related documents

- `PROJECT_SPEC.md` — requirements, current design notes, confirmed information, assumptions, proposals, and unresolved questions.
- `DECISIONS.md` — owner-confirmed decisions and decision history.
- `MODULE_DOCS/README.md` — guidance for focused module documents.
- `REFERENCES/README.md` — supplied technical references.

If this file and `PROJECT_SPEC.md` disagree, report the exact discrepancy and ask for clarification. Do not silently select one source or use this file to override the specification.
