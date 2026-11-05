# ARCHITECTURE — Tech terror

> **Status:** WIP. Read-only for Claude.

## 1. Stack & Constraints
- **Framework:** HaxeFlixel. Entry: `Main.hx` → `LoadingState`. Build: `lime test web`.
- **Dirs:** `source/`, `assets/{songs,images,music,sounds,data}/`.
- **Constraint:** Delete `Config.hx`. Leaving `PlayState` MUST delete all objects (prevent RAM leak).

## 2. States & Transitions
- **Main:** `Loading`, `Menu`, `Play`, `Editor`, `Result`. **Sub-state:** `Pause` (in Play).
- **Flow:**
  - `Loading` ↔ `Menu`
  - `Menu` → `Play` (Enter) / `Editor` (7)
  - `Play` ↔ `Editor`
  - `Play` → `Result` / `Menu`
  - `Result` → `Menu` (Enter/Space/Esc) / `Play` (R)

## 3. Play Flow & Object Model
- **Flow:** Load assets → UI → Audio (3s countdown) → Gameplay Loop.
- **Menu:** `songScrollLine` manages `songObject`. Loads `songs.txt` → `_data.json`.
- **Play:** 
  - `Line` reads chart → creates `LineSprite` → owns 1 `NoteGenerator`.
  - `NoteGenerator` reads `timeToHitList` → spawns `Note` 2s early via Line's sprite.

## 4. Persistence
- **Chart JSON:** `[{"line": 0, "timeToHitList": [1.0, 2.5]}, {"line": 1, "timeToHitList": [0.5]}]`