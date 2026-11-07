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

**Editor Flow** — see `PROJECT_SPEC.md §4`:
- **Architecture:** `EditorState` acts as orchestrator (Source of Truth). UI is modularized into `EditorPanel`, `EditorGrid`, and `EditorNavigation`.
- **EditorPanel:** Top UI panel. Displays BPM, Bar count, Beats. (Future: editable settings).
- **EditorGrid:** Extends `FlxTypedSpriteGroup`. Draws rows/cols, beat/bar separators. Holds `currentBar` and `totalBars`. Has `rebuild()` to redraw when params change.
- **EditorNavigation:** `<` and `>` arrows. Handles mouse clicks via `onNavigate` callback.
- **Interaction:** Mouse click toggles note at `(Row, Col)` (Pending M4.2).
- **Navigation:** `Left`/`Right` (keyboard or UI arrows) → prev/next bar.
- **Auto-save:** `Esc` writes `chart_[difficulty].json` (Windows only).

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