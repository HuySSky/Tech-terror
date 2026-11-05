# ARCHITECTURE — Tech terror

> **Status:** WIP. Read-only.

## 1. Stack & Constraints
- **Framework:** HaxeFlixel. Entry: `Main.hx` → `LoadingState`.
- **Dirs:** `source/`, `assets/`.
- **Constraint:** Delete `Config.hx`. Leaving `PlayState` MUST delete all objects (prevent RAM leak).

## 2. Core Flows
- **App:** `Loading` ↔ `Menu` → `Play`/`Editor` → `Result`.
- **Play:** Load -> UI -> Audio (3s) -> Loop. `Pause` is a sub-state.
- **Menu:** `songScrollLine` reads `songs.txt` -> loads `_data.json` -> spawns `songObject`.
- **Play Object:** `Line` -> `LineSprite` + `NoteGenerator` -> spawns `Note` (2s early, recycles).
- **Editor:** Direct JSON I/O (Windows).

## 3. Persistence
- **Data:** `FlxSave` (Results/Config). JSON (Editor).