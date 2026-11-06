# PROJECT_SPEC — Tech terror

> **Source of Truth.** Read-only.

## 1. Overview
- **Game:** Offline drum rhythm game. HaxeFlixel. Target: Windows (Web for testing).
- **Diff:** Easy, Medium, Hard. **Lanes:** Variable. **Input:** `justPressed`.
- **Out of scope:** Visual effects, audio calibration.

## 2. Gameplay & UI
- **Duration:** Auto-read audio on Menu load. No `length` in JSON.
- **Scale:** Max ~100 songs. No optimization needed.
- **Flow:** Load -> UI -> Audio -> 3s countdown -> Gameplay. Notes spawn 2s pre-hit.
- **Persistence:** `FlxSave` for Results/Config. JSON Import/Export for Editor. Web is test-only.

## 3. Scoring & Timing
`secPerBeat = 60 / bpm`. `absTiming = |timing|`. Inclusive boundaries (`<=`).

| Rating | Window (absTiming) | Point Mult | Heal Mult |
|---|---|---|---|
| Perfect | `<= 2%` | 120% | 120% |
| Precise | `<= 4%` | 100% | 100% |
| Tight | `<= 6%` | 75% | 75% |
| Loose | `<= 10%` | 50% | 30% |
| Off | `<= 14%` | 25% | 10% |
| Miss | `> 14%` | 0% | -75% |

- **Beat Mult (`heso`):** Strong (1.2), Medium (1.1), Weak (1.0). Apply to point/heal.
- **Health:** `maxHealth = bpm`. Initial: `0.75 * maxHealth`. Cap: `[0, maxHealth]`. Lose at `curHealth <= 0`.
- **Miss Penalty:** `healPoint = -0.75 * 10 * heso`.
- **Empty Press:** 0 penalty, 0 score, does not break combo.
- **Constants:** `basePoint = 100`, `baseHealPoint = 10`.

**Result:**
- **Accuracy:** `(Earned / Max) * 100`.
- **Rank:** SS (95), S (90), A (80), B (60), C (50), D (30), F (0).
- **Combo:** Miss resets to 0.
- **Clear:** `curHealth > 0`. **Pass:** Clear AND `Accuracy >= 50%`.

## 4. Data Structure
- **Paths:** `assets/songs/songs.txt`, `assets/songs/[name]/[name]_data.json`, `assets/songs/[name]/chart.json`.
- **TimeSignature:** `name` ("4/4"), `id`, `strongBeats` (Array<Int>), `mediumBeats` (Array<Int>). Only 4/4 is supported.
- **Editor Grid Math:** `Columns = Beats / SubBeatDuration`. (e.g., 4/4, sub=0.5 -> 8 columns; sub=0.25 -> 16 columns).
- **Chart Schema:** `[{"line": 0, "notes": [{"time": 1.0, "strength": 1.2}, {"time": 1.75, "strength": 1.0}]}]` *(Note: `time` handles swing offsets)*.
- **Objects:** `songData` (name, artist, bpm, previewStart, diff->scrollSpeed), `songObject` (data, result, cover, music), `songResult` (score, accuracy, rank, maxCombo, status), `Line` (sprite, key, generator), `NoteGenerator`, `Note` (sprite, timeToHit, strength).

## 5. State Transitions & Controls
- **Loading ↔ Menu:** `Enter`/`Space` (to Menu), `Esc` (to Loading).
- **Menu → Play/Editor:** `Enter` (Play), `7` (Editor), `Left/Right` (select song), `Tab` (switch difficulty).
- **Play → Result / Editor / Menu:** Level end/death (Result), `7` (Editor), `Q`/`Backspace` (Quit to Menu).
- **Pause System:** 
  - In Play: `Esc` or `Enter` to Pause.
  - In Pause: `Esc` to Resume (back to Play). `Enter` to select a menu option. `Q` or `Backspace` to Quit to Menu.
- **Result → Menu / Play:** `Enter`/`Space`/`Esc` (Menu), `R` (Restart).
- **Editor Controls:** 
  - Change Bar (Measure): `Left/Right` keyboard arrows or UI buttons.
  - Toggle Note: Mouse click.
  - Exit to Menu: `Esc` (Triggers auto-save to `chart.json` before exiting).

## 6. Unresolved (DO NOT GUESS - Stop and Ask)
- None at this time. (All U-issues resolved).

## 7. Assumptions
- Notes scroll horizontally to vertical line. Tap only. Bar = measure, beat = phách.