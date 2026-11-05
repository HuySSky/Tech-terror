# PROJECT_SPEC — Tech terror

> **Source of Truth.** Read-only for Claude. DeepSeek/Owner maintained.

## 1. Overview & Stack
- **Game:** Offline drum rhythm game (faculty event). No melody.
- **Stack:** Haxe + HaxeFlixel. Target: Web. Build: `lime test web`. Entry: `Main.hx`.
- **Performance:** FPS prioritized. Leaving `PlayState` must destroy all objects.
- **Dirs:** `source/`, `assets/{songs, images, music, sounds, data}/`.
- **Out of scope:** Visual effects, audio calibration.

## 2. Gameplay Mechanics
- **Difficulties:** Easy, Medium, Hard (1 chart each).
- **Lanes:** Variable per song. Keys assigned by designer. No remapping.
- **Input:** `justPressed` only. Simultaneous hits allowed.
- **Flow:** Load → UI → Audio → **3s countdown** → Gameplay. `NoteGenerator` spawns notes 2s pre-hit.

## 3. Scoring & Timing
`secPerBeat = 60 / bpm`

| Rating | Window | Point Mult | Heal Mult |
|---|---|---|---|
| Perfect | ±2% | 120% | 120% |
| Precise | ±4% | 100% | 100% |
| Tight | ±6% | 75% | 75% |
| Loose | ±10% | 50% | 30% |
| Off | ±14% | 25% | 10% |
| Miss | >14% | 0% | -75% |

- **Beat Mult (`heso`):** Strong (1.2), Medium (1.1), Weak (1.0).
- **Formula:** `point *= heso`, `healPoint *= heso`.
- **Health:** `maxHealth = bpm`. Lose when `curHealth <= 0`.
- **Defaults:** `point = 100`, `healPoint = 10`.

## 4. State Transitions
- **Loading ↔ Menu:** Enter/Space (Menu), Esc (Loading).
- **Menu → Play/Editor:** Enter (Play), `7` (Editor).
- **Play → Result:** Level end or death.
- **Play → Editor:** `7`.
- **Play → Menu:** Esc.
- **Play ↔ Pause:** Sub-state.
- **Result → Menu:** Enter/Space/Esc. **Result → Play:** `R`.

## 5. Data & Persistence
- **Song List:** `assets/songs/songs.txt`.
- **Song Folder:** `assets/songs/[song_name]/`.
- **Chart JSON:** `[{"line": 0, "timeToHitList": [1.0, 2.5]}, {"line": 1, "timeToHitList": [0.5]}]`
- **Volume:** Persisted via `FlxSave`.

## 6. Key Objects
- `songData`: name, artist, bpm, previewStart, difficulty→scrollSpeed.
- `songObject`: holds `songData`, `songResult`, cover, music.
- `songScrollLine`: Group of `songObject`s. `add()`, `next()`, `pre()`, `getCurrentSong()`.
- `songResult`: score, accuracy, rank, max combo, status.
- `Note`: Sprite, `timeToHit`.
- `NoteGenerator`: 1 per Line. Manages `Group<Note>`. Recycles notes.
- `Line`: sprite, importance, input key, `NoteGenerator`, `LineSprite`.

## 7. Unresolved Questions (Do Not Guess)
| ID | Topic | Question |
|---|---|---|
| U-002 | Web I/O | Browser cannot write to `assets/`. Use `FlxSave` or JSON download for Editor/Results? |
| U-003 | UI | Source of Song Length in Menu? (Placeholder allowed) |
| U-005 | Timing | Signed convention (early/late)? `≤` or `<` at boundaries? |
| U-006 | Result | Formulas for Accuracy, Rank, Max-Combo, Clear/Pass? |
| U-007 | Health | Initial `curHealth`? Cap/clamping? Does Miss penalty use `heso`? |
| U-008 | Balance | Final values for `point`/`healPoint`? |
| U-009 | Rhythm | Beat strength for 6/8, 5/4, etc.? |
| U-010 | Input | Penalty for pressing key with no note in range? |
| U-011 | Editor | 0.25 subdivision = 12 columns? (Math seems wrong) |
| U-012 | Editor | Meaning of "2 nhịp", next "bar", "one nhịp per move"? |
| U-014 | Input | Key to trigger Pause/Setting? |

## 8. Assumptions
- Notes scroll horizontally to a vertical hit line. Tap notes only (no holds).
- "Bar" = measure, "phách" = beat.