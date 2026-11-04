# ARCHITECTURE — Tech terror

> This file is an architecture index derived from `PROJECT_SPEC.md`, not an independent design authority.
> It must not invent class boundaries, APIs, or data flow beyond the specification. If detail is missing, link back to the relevant unresolved question.

## 1. Application structure

### Confirmed technology and entry

- Language: Haxe.
- Framework: HaxeFlixel.
- Target: Web.
- Entry point: `Main.hx`.
- Intended startup: `Main.hx` starts `LoadingState`.
- Local build command: `lime test web`.

### Project directories

```text
source/             Haxe source code
assets/
├── data/           Saved data/config
├── songs/          Songs and levels
├── images/         Sprites
├── music/          State/menu music
└── sounds/         State SFX
```

`Config.hx` is not part of the intended architecture. The owner plans to delete it manually; no module may depend on it.

## 2. States and transitions

States/concepts recorded in the specification:

- `Loading`
- `Menu`
- `Play`
- `Editor` (`EditLevel`)
- `Result`
- `Setting/Pause` — sub-state only during Play

Primary intended flow:

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

Additional paths:
- Menu → Editor (key `7`, selected song passed).
- Play → Editor (key `7`).
- Play → Setting sub-state (trigger key unresolved).
- Play → Menu via Esc appears in the placeholder implementation, but is absent from the source transition list. This conflict remains unresolved.

Do not turn this diagram into a claim that each concept must be a separate `FlxState`. The specification explicitly says not every state is required to be standalone.

## 3. Gameplay design concepts

The specification names these concepts:

- `GameSystem`
- `InputSystem`
- `NoteSystem` — spawning, hit, miss, timing, rating
- `PlayerStats` — Score, Health
- `LevelEditor` / `LevelSystem`
- `ResultSystem`
- `PauseSystem`
- `SettingSystem`

These are conceptual names. The exact class layout must be decided during implementation planning.

## 4. Menu object design

### `songData`

Fields:
- name
- artist
- bpm
- preview start time
- difficulty → `scrollSpeed` map

The existing `Billie Jean_data.json` fields are recorded in `PROJECT_SPEC.md` §5.

### `songObject`

Represents the CD/album object. Holds:
- `songData`
- per-song results
- cover image object
- music

The design says `new(songData)` finds the music and cover in the song folder.

### `songScrollLine`

A row/group of song objects at screen centre:
- selected song is centred and enlarged
- initially selects the first song
- `add(songObject)`
- `next()` for Right
- `pre()` for Left
- current song object and current song data are returned through two functions

### `songResult`

Per-difficulty:
- score
- accuracy
- rank
- max combo
- status (clear/pass)

Menu displays:
- BM1: name, BPM, length, cover
- BM2: song info and difficulty–score results

Tab changes the selected song object's difficulty.

## 5. Play object design

### `Note`
- Sprite
- `timeToHit`

### `NoteGenerator`
- `Group<Note>`
- Reads note `timeToHit` values from the chart.
- Recycles notes via the library.
- Calculates spawn position from scroll velocity (`TimeScale`) and pre-spawn time (default 2 seconds).

### `Line`
- name (maps to sprite)
- importance coefficient
- input key
- NoteGenerator

`PlayState` checks lines every frame to spawn notes.

The specification contains an unresolved discrepancy: one `NoteGenerator` per Line in object design versus plural NoteGenerators in technical requirements. See `PROJECT_SPEC.md` §8.4.

Other Play responsibilities mentioned:
- input handling
- health and rating display
- UI

Do not invent more detailed ownership or call relationships without reviewing source/design references and confirming the design.

## 6. Pause / Setting

- Exists only as a sub-state during Play.
- Resume: Esc, or Enter while Resume is selected.
- Restart: Enter while Restart is selected; recreates PlayState from `songData`.
- Volume: Left/Right, Shift + Left/Right, and holding Left/Right.
- Selected item is highlighted.
- A parameter is displayed beside an item when applicable.
- Volume persists through `FlxSave` and applies across screens.

The key that opens this sub-state during Play is unresolved.

## 7. Result

Displays:
- song information
- difficulty
- score data

The design flow is `songData` → `songObject` → find result, then return to Menu.

## 8. Editor

- Rows represent drum lanes.
- Columns represent note on/off positions.
- Shows two "nhịp" at a time (unit requires clarification).
- Edits scroll speed, BPM, time signature, and each line's input key.
- Navigates to the next "bar"/"nhịp" (unit requires clarification).
- Saves and loads chart data.

The column-count example for 4/4 and note-length 0.25 is flagged as unresolved in `PROJECT_SPEC.md` §8.11. Do not silently change it.

## 9. Data flow recorded in the design

### Menu loading flow

```text
assets/songs/songs.txt
        |
        v
Read song names
        |
        v
assets/songs/[song_name]/
        |
        v
[song_name]_data.json + related image/audio
        |
        v
Create songObject
        |
        v
Add to songScrollLine
```

### Chart-to-gameplay concept

The design states that chart note times are read to spawn notes, and each chart has multiple lanes with per-lane timing values and a designer-assigned key. Exact JSON structure and detailed runtime flow remain unresolved.

## 10. Lifecycle and performance constraints

Confirmed:
- Processing speed and frame rate are priorities.
- No hard RAM budget during a level.
- Leaving `PlayState` must delete all objects created in it.
- Note recycling is part of the design.
- `NoteGenerator` pre-spawn time defaults to 2 seconds.

Implementation details must be checked against the actual HaxeFlixel version and approved design.
