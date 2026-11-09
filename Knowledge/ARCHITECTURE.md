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
- **Architecture:** `EditorState` orchestrates. Editor UI split by size, not reusability.
- **EditorGrid:** Owns geometry + input. Each cell is a `Grid` sprite with `FlxMouseEvent`.
  - On click: compute `absBeat = currentBar * beatsPerMeasure + col * subBeat`.
  - Create `NoteEntity`, set `line/absBeat/x/y`, call `noteLayer.add(note)`.
  - Owns `currentBar` setter → pushes to `noteLayer.currentBar`.
  - Owns `beatsPerMeasure` setter → pushes to `noteLayer.beatsPerMeasure`.
  - Holds ref to `noteLayer` (one-way: Grid knows Layer, Layer does NOT know Grid).
- **NoteLayer:** Container + logic.
  - Holds notes in `members` (FlxTypedSpriteGroup).
  - `add()` override attaches `FlxMouseEvent` for hover/out/toggle.
  - `refreshVisuals()`: `note.visible = (note.getBar(beatsPerMeasure) == currentBar)`.
  - Does NOT read Grid. Receives `currentBar` and `beatsPerMeasure` via setters.
  - Hover events dispatched via callback (to be wired to Panel later).
- **NoteEntity:** `line`, `absBeat`, `offsetMs`. Methods `getBar(bpm)`, `getStepBeat(bpm)`.


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