# ARCHITECTURE — Tech terror
> **Status:** WIP. Read-only.

## 1. Stack & Constraints
- **Framework:** HaxeFlixel.
- **Entry:** `Main.hx` → `LoadingState`.
- **Dirs:** `source/`, `assets/`.
- **Target:** Windows.
- **Web:** testing only.
- **Editor I/O:** `chart_[difficulty].json` save/load Windows-only. No-op/trace on web.

## 2. Core Flows

**App:** `Loading` ↔ `Menu` → `Play`/`Editor` → `Result` → `Menu`.

**State Data Passing** — via constructor params, NOT static vars:
- `Menu → Play`: `songData:SongData`, `difficulty:String`
- `Menu → Editor`: `songData:SongData`, `difficulty:String`
- `Play → Result`: `songResult:SongResult`
- `Play → Editor`: `songData:SongData`, `difficulty:String`

E.g.: `FlxG.switchState(new PlayState(songData, difficulty))`

**Play Flow:**
1. Load `chart_[difficulty].json`.
2. Init UI.
3. Start audio.
4. 3s countdown.
5. Gameplay loop (input active).

- Notes spawn when `hitTime - currentTime <= 2.0`; recycle after hit/miss.
- `Pause` = in-`PlayState` overlay, not separate FlxState. See `PROJECT_SPEC.md §5`.

**Menu Flow** — see `PROJECT_SPEC.md §4.1`:
- `songScrollLine` reads `songs.txt`.
- For each name: `SongData.load(name)` (parses `_data.json`).
- Creates `new SongSprite(songData)`, adds to line.
- `SongSprite` loads own cover + audio. Duration → Info Panel.

**Play Objects:** `Line` → `LineSprite` + `NoteGenerator` → spawns `Note` (2s early, recycled).

**Editor Flow** — see `PROJECT_SPEC.md §4`:
- **UI:** DAW grid. Rows=`Line`, Cols=beat/sub-beat slots.
- **Interaction:** mouse click toggles note at `(Row, Col)`.
- **Offset:** fractional times ok (e.g., 1.75 swing).
- **Navigation:** `Left`/`Right` (kb or UI) → prev/next bar. No free scroll.
- **Logic:** `TimeSignature` → `BeatStrength` (1.2/1.1/1.0) based on beat position.
- **Auto-save:** `Esc` writes `chart_[difficulty].json` (Windows only).

## 3. Persistence

**`FlxSave`:**
- Results/config. Key = `songName+difficulty`. Stores best `SongResult`.
- Note: PDF "JSON" = `FlxSave` (serializes to JSON).

**JSON Files:** Editor chart I/O (Windows only). Files: `chart_[difficulty].json`.

**Self-Instantiation:**
- `SongData.load(name)` parses own `_data.json`.
- `SongSprite` gets `SongData`, loads own cover/audio.
- No external Loader class.