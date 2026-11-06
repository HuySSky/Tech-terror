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
- **TimeSignature:** `name` ("4/4"), `id`, `strongBeats` (Array<Int>), `mediumBeats` (Array<Int>).
- **Editor Grid Math:** `Columns = Beats / SubBeatDuration`. (e.g., 4/4, sub=0.5 -> 8 columns; sub=0.25 -> 16 columns).
- **Chart Schema:** `[{"line": 0, "notes": [{"time": 1.0, "strength": 1.2}, {"time": 1.75, "strength": 1.0}]}]` *(Note: `time` handles swing offsets)*.
- **Objects:** 
  - `songData`: (name, artist, bpm, previewStart, diff->scrollSpeed).
  - `songSprite`: Visual object for Menu. Equivalent to `songObject`. Initialized via `new(data: SongData)`. Contains data, result, cover, music.
  - `songScrollLine`: Container for `songSprite`. Layouts them horizontally.
  - `songResult`: (score, accuracy, rank, maxCombo, status).
  - `Line`, `NoteGenerator`, `Note` (sprite, timeToHit, strength).

## 4.1 Menu UI Layout
- **Top Half (Carousel):** `songScrollLine` holds `songSprite` objects arranged horizontally with a fixed gap. 
  - **Selection:** The currently selected song is scaled up (`x1.2`) and centered.
  - **Navigation:** Press Left/Right arrows to change selection. Unselected songs scale down to `x1.0`.
- **Bottom Half (Info Panel):** A dark rectangle UI overlay. Shows: Song Name, Artist, BPM, and Current Difficulty (Easy/Medium/Hard). Also shows High Score & Rank of the current difficulty (read from `FlxSave`).
- **`songSprite` Specs:**
  - Base size: 175x325 pixels (placeholder solid color if no cover exists).
  - Displays the cover image (150x150). Does NOT contain text.
- **`songScrollLine` Positioning (Instructions):**
  - Arrange the `songSprite` objects horizontally with a fixed 50px gap.
  - The selected sprite scales to `x1.2`. Unselected sprites scale to `x1.0`.
  - Implement logic to shift the entire `songScrollLine` (X-axis) so that the *selected sprite* is perfectly centered on the screen.
- **Controls & Logic:**
  - `Left`/`Right` arrows: Update `selectedIndex`, reposition `songScrollLine`, update Info Panel.
  - `Tab`: Cycles Difficulty (Easy -> Medium -> Hard). Updates the Info Panel's High Score to match the new difficulty.
  - `Enter`: Start Playstate with current `songData` and `difficulty`.
  - `7`: Start Editor with current `songData`.

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