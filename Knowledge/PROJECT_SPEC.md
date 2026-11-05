# PROJECT_SPEC — Tech terror

> **Source of Truth.** Read-only for Claude.

## 1. Overview & Rules
- **Game:** Offline drum rhythm game. HaxeFlixel (Web).
- **Diff:** Easy, Medium, Hard. **Lanes:** Variable per song. **Input:** `justPressed`.
- **Out of scope:** Visual effects, audio calibration.

## 2. Scoring & Timing
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

## 3. Data & Key Objects
- **Paths:** `assets/songs/songs.txt`, `assets/songs/[song_name]/`.
- **Chart JSON:** `[{"line": 0, "timeToHitList": [1.0]}]`
- **Save:** Volume persisted via `FlxSave`.
- **Objects:**
  - `songData`: name, artist, bpm, previewStart, diff→scrollSpeed.
  - `songObject`: holds `songData`, `songResult`, cover, music.
  - `songScrollLine`: Group of `songObject`s.
  - `songResult`: score, accuracy, rank, maxCombo, status.
  - `Line` (owns sprite, key, `NoteGenerator`), `NoteGenerator` (spawns/recycles `Note`), `Note` (sprite, `timeToHit`).

## 4. Unresolved Questions (Do Not Guess)
| ID | Topic | Question |
|---|---|---|
| U-002 | Web I/O | How to save Editor/Results? (`FlxSave` or JSON download?) |
| U-003 | UI | Source of Song Length in Menu? (Use placeholder). |
| U-005 | Timing | Signed convention (early/late)? `≤` or `<`? |
| U-006 | Result | Formulas for Accuracy, Rank, Max-Combo, Clear/Pass? |
| U-007 | Health | Initial `curHealth`? Cap/clamping? Does Miss penalty use `heso`? |
| U-008 | Balance | Final values for `point`/`healPoint`? |
| U-009 | Rhythm | Beat strength for 6/8, 5/4, etc.? |
| U-010 | Input | Penalty for pressing key with no note in range? |
| U-011 | Editor | 0.25 subdivision = 12 columns? (Math seems wrong) |
| U-012 | Editor | Meaning of "2 nhịp", next "bar", "one nhịp per move"? |
| U-014 | Input | Key to trigger Pause/Setting? |

## 5. Assumptions
- Notes scroll horizontally to vertical hit line. Tap notes only.
- "Bar" = measure, "phách" = beat.