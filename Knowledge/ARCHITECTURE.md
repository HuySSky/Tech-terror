# ARCHITECTURE — Tech terror
> **Status:** WIP. Read-only.

## 1. Stack & Constraints
- **Framework:** HaxeFlixel.
- **Entry:** `Main.hx` → `LoadingState`.
- **Target:** Windows.
- **Web:** testing only.
- **Editor I/O:** `chart_[difficulty].json` save/load Windows-only. No-op/trace on web.
- **RAM:** PlayState must clean up all objects on exit (`destroy()`).

## 2. State Flows & Data Passing

**App Flow:** `Loading` ↔ `Menu` → `Play`/`Editor` → `Result` → `Menu`.

**Data Passing (via Constructors, NO static vars):**
- `Menu → Play`: `songData:SongData`, `difficulty:String`
- `Menu → Editor`: `songData:SongData`, `difficulty:String`
- `Play → Result`: `songResult:SongResult`
- `Play → Editor`: `songData:SongData`, `difficulty:String`

*E.g.:* `FlxG.switchState(PlayState(songData, difficulty).new)`

**Play Flow:**
1. **Intro:** Load chart, init UI, 3s audio countdown.
2. **Gameplay:** Input active, `PlayerStats` updates.
3. **Outro** (end of song/death):
   - Create `SongResult`, call `fromPlayerStats()`.
   - Call `saveData(flxSave)` (checks if new high score).
   - Switch to `ResultState(songResult)`.

**Menu Flow:**
1. `songScrollLine` reads `songs.txt`.
2. For each: `new Song(name)`.
3. Adds to horizontal line. Selected scales ×1.2, centered.
4. Info Panel reads `SongResult.loadData()` for High Score display.

**Editor Flow:**
- **Architecture (3-Tier):** `EditorState` acts as orchestrator. UI is split by lifecycle:
  - `EditorPanel` (Top UI): Holds BPM, ScrollSpeed, Difficulty, Sub-beat. Emits signals on change. Does NOT hold note data.
  - `EditorGrid` (Layout): Draws rows, cols, separators, icons. Holds `currentBar`, `totalBars`, `beatsPerMeasure`, `subBeat`. Does NOT know notes exist.
  - `NoteLayer` (Data + Render): Holds `Array<NoteEntity>`. Renders notes onto the grid. Does NOT draw geometry.
- **Data Flow & Interaction:**
  - **Click Grid:** `EditorState` catches click → `grid.cellAt()` → `noteLayer.toggle()`. (Toggles note at `currentBar`, `line`, `col`).
  - **Change Sub-beat:** Panel emits signal → `EditorState` calls `grid.rebuild()` (redraws columns) → `noteLayer.refreshVisuals()`. Notes DO NOT move (pixel position derived from absolute beat).
  - **Change BeatsPerMeasure:** Panel emits signal → `grid.rebuild()` → `noteLayer.refreshVisuals()`. Note bar/step calculations update, but `absBeat` is immutable.
  - **Change Lines (Add/Remove):** Panel emits signal → `grid.rebuild()` + `noteLayer.clearLine()` for removed lines → `refreshVisuals()`.
  - **Navigate Bars:** `grid.currentBar` setter clamps → `noteLayer.refreshVisuals()` (hides/shows notes outside current bar).
- **Note Properties (`NoteEntity`):**
  - `absBeat:Float`: Source of truth. Never changes when grid layout changes.
  - `offsetMs:Float`: Timing offset in ms (for PlayState).
  - Length: Always fixed to 1/8 of a beat, regardless of current `subBeat`.
- **Save (M5.1):** `EditorState` reads `noteLayer.getAll()`. Converts `absBeat` to `time`, calculates `strength` via `TimeSignature`, exports `offsetMs` as `offset`. Writes to JSON.

## 3. Persistence

**`FlxSave`:**
- Save Name: `"Tech_terror_highscore"`
- Key: `songName + "_" + difficulty`
- Value: `SongResult` data.
- **Logic:** `PlayState` builds `currentResult`. Loads `oldResult`. If `currentResult.score > oldResult.score`, overwrites save. Passes `currentResult` to ResultState.

**JSON Files:**
- `[name]_data.json`: Metadata (BPM, offset, etc).
- `chart_[difficulty].json`: Note data (time, strength per line).

**Self-Instantiation:**
- `new SongData(name)` parses own `_data.json`.
- `new Song(name)` creates `SongData`, loads cover/audio.
- No external Loader classes.