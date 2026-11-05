# PROJECT_SPEC — Tech terror

> **Source of Truth.** Read-only.

## 1. Overview
- **Game:** Offline drum rhythm game. HaxeFlixel. Target: Windows (Web for testing).
- **Diff:** Easy, Medium, Hard. **Lanes:** Variable. **Input:** `justPressed`.
- **Out of scope:** Visual effects, audio calibration.

## 2. Gameplay & UI
- **Duration (U-003):** Auto-read audio on Menu load. No `length` in JSON. `[Verify HaxeFlixel API]`.
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
- **Constants:** `basePoint = 100`, `baseHealPoint = 10`.

**Result:**
- **Accuracy:** `(Earned / Max) * 100`.
- **Rank:** SS (95), S (90), A (80), B (60), C (50), D (30), F (0).
- **Combo:** Miss resets to 0.
- **Clear:** `curHealth > 0`. **Pass:** Clear AND `Accuracy >= 50%`.

## 4. Data Structure
- **Paths:** `assets/songs/songs.txt`, `assets/songs/[name]/[name]_data.json`, `assets/songs/[name]/chart.json`.
- **Chart Schema:** `[{"line": 0, "timeToHitList": [1.0, 2.5]}]`
- **Objects:** `songData` (name, artist, bpm, previewStart, diff->scrollSpeed), `songObject` (data, result, cover, music), `songResult` (score, accuracy, rank, maxCombo, status), `Line` (sprite, key, generator), `NoteGenerator`, `Note` (sprite, timeToHit).

## 5. State Transitions
- **Loading ↔ Menu:** Enter/Space, Esc.
- **Menu → Play/Editor:** Enter, `7`.
- **Play → Result / Editor / Menu:** Level end/death, `7`, Esc.
- **Pause:** Sub-state.
- **Result → Menu / Play:** Enter/Space/Esc, `R`.

## 6. Unresolved (Do Not Guess)
- **U-009:** Beat strength for 6/8, 5/4?
- **U-010:** Penalty for empty press?
- **U-011:** Editor 0.25 sub = 12 columns? (Math wrong?)
- **U-012:** Editor bar/beat logic?
- **U-014:** Pause key?

## 7. Assumptions
- Notes scroll horizontally to vertical line. Tap only. Bar = measure, phách = beat.