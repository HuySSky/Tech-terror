# ARCHITECTURE — Tech terror

> **Status:** WIP. Read-only.

## 1. Stack & Constraints
- **Framework:** HaxeFlixel. Entry: `Main.hx` → `LoadingState`.
- **Dirs:** `source/`, `assets/`.
- **Memory:** When exiting `PlayState`, all objects must be destroyed/cleared to prevent RAM leaks.

## 2. Core Flows
- **App:** `Loading` ↔ `Menu` → `Play`/`Editor` → `Result`.
- **Play:** Load -> UI -> Audio (3s delay) -> Gameplay Loop. 
  - `Pause` is a sub-state. Triggered by `Esc`/`Enter`. 
  - Inside Pause: `Esc` resumes, `Q`/`Backspace` quits to Menu.
- **Menu:** 
  - `MenuState` initializes `songScrollLine`.
  - `songScrollLine` reads `songs.txt` -> loads `_data.json` -> creates `songSprite` objects via `new(songData)`.
  - `songScrollLine.add(songSprite)`: Adds to the horizontal line.
  - **Visuals:** Selected song scales to 1.2x. Left/Right input updates selection index.
  - **Info Panel:** Updates automatically based on the selected `songSprite`.
- **Play Objects:** `Line` -> `LineSprite` + `NoteGenerator` -> spawns `Note` (2s early, recycles).
- **Editor:** 
  - **UI:** DAW-style grid (like FL Studio Channel Rack). Rows = Instruments (`Line`), Columns = Beats/Sub-beats.
  - **Interaction:** Mouse click toggles a note on/off at `(Row, Column)`. 
  - **Offset:** Grid supports fractional offsets (e.g., 1.75) for swing notes. 
  - **Navigation (Bars):** NO free horizontal scrolling. Use UI buttons (Left/Right arrows) or Keyboard (Left/Right arrows) to jump to the Previous/Next Bar (Measure).
  - **Logic:** Direct JSON I/O (Windows). Uses `TimeSignature` class. When saving, assigns `BeatStrength` (1.2, 1.1, 1.0) to notes based on their exact beat position.
  - **Auto-save:** Exiting the Editor state (`Esc` or returning to Menu) automatically writes the current chart to `chart.json`.
- **Input Rule:** Empty presses (mashing) result in 0 penalty, 0 score, and do not break combo.

## 3. Persistence
- **Data:** `FlxSave` (Results/Config). JSON (Editor).