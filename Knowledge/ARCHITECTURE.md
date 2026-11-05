# ARCHITECTURE — Tech terror

> **Status:** WIP. Owner/DeepSeek maintained. Claude is read-only.

## 1. App Structure & Constraints
- **Framework:** HaxeFlixel. Entry: `Main.hx` → `LoadingState`.
- **Dirs:** `source/`, `assets/{songs, images, music, sounds, data}/`.
- **Constraint:** Delete `Config.hx`. No dependencies on it.

## 2. States & Transitions
- **Main:** `Loading`, `Menu`, `Play`, `Editor`, `Result`.
- **Sub-state:** `Pause` (inside Play).
- **Flow:**
  - `Loading` ↔ `Menu`
  - `Menu` → `Play` / `Editor`
  - `Play` ↔ `Editor`
  - `Play` → `Result` (passes `songResult`)
  - `Play` → `Menu`
  - `Result` → `Menu` (Enter/Space/Esc) | `Play` (R)
- *Class ownership of transitions is TBD.*

## 3. Gameplay Flow
1. Load assets (sprites, audio, data).
2. Show UI (Health, Score).
3. Start audio → 3s countdown → Gameplay.
4. Loop: Input → Note check → `PlayerStats` update.
- **Modules:** `Input`, `GameSystem`, `NoteSystem`, `PlayerStats`, `ResultSystem`. *(Class mapping TBD).*

## 4. Object Model & Lifecycle
- **Menu:** `songScrollLine` manages `songObject`s. Load: `songs.txt` → `_data.json` → `songObject`. Left/Right changes selection.
- **Play:** 
  - `Line` reads chart, creates `LineSprite`, owns 1 `NoteGenerator`.
  - `NoteGenerator` reads `timeToHitList` → spawns `Note` 2s early using Line's sprite.
- **Lifecycle:** Leaving `PlayState` **MUST** delete all created objects. Note recycling required.

## 5. Persistence
- **Chart JSON:**
  ```json
  [{"line": 0, "timeToHitList": [1.0, 2.5]}, {"line": 1, "timeToHitList": [0.5]}]