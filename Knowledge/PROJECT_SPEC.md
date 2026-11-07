# PROJECT_SPEC — Tech terror
> **Source of Truth.** Read-only.

## 1. Overview
- **Game:** Offline drum rhythm game. HaxeFlixel.
- **Platform:** Windows (Web test only).
- **Window:** 1280x768.
- **Difficulty:** Easy, Medium, Hard.
- **Lanes:** Variable (one per `Line`). **Input:** `justPressed`.
- **Out of Scope:** Visual effects, audio calibration.

## 2. Gameplay & UI
- **Duration:** Auto-read from audio on Menu load. No JSON `length`.
- **Flow:** Load → UI → audio → 3s countdown → gameplay (input active).
- **Note Spawn:** 2s before hit time.
- **Fail Condition:** `curHealth <= 0`.

## 3. Scoring & Timing

**Constants:** `basePoint=100`, `baseHealPoint=10`, `secPerBeat=60/bpm`, `absTiming=|timing-timeToHit|` (s).

**Rating Table** (inclusive `<=`, windows = % of `secPerBeat`):

| Rating | Window | Point Mult | Heal Mult |
|---|---|---|---|
| Perfect | ≤2% | 120% | 120% |
| Precise | ≤4% | 100% | 100% |
| Tight | ≤6% | 75% | 75% |
| Loose | ≤10% | 50% | 30% |
| Off | ≤14% | 25% | 10% |
| Miss | >14% | 0% | -75% |

**Beat Mult (`heso`):** Strong 1.2, Medium 1.1, Weak 1.0. Applied to point & heal.
**Hit:** `point = basePoint * pointMult * heso`; `healPoint = baseHealPoint * healMult * heso`; combo +1.
**Miss:** `point=0`; `healPoint = -baseHealPoint * 0.75 * heso`; combo=0. Auto-miss if `absTiming > 14%` `secPerBeat`.
**Empty Press:** 0pt, 0heal, no combo break, no note consumed.
**Health:** `maxHealth=bpm`. Initial `0.75*maxHealth`. Clamp `[0,maxHealth]`.

**Result:**
- **Score:** Σ `point` across judged notes.
- **Max Score:** Σ `basePoint * 1.2 * note.heso` over all notes.
- **Accuracy:** Weighted average theo rating. `accuracy = Σ(count[i] * weight[i]) / totalNotes` (0–100).
- **Weight Table:**
  | Rating  | Weight |
  |---------|--------|
  | Perfect | 100    |
  | Precise | 85     |
  | Tight   | 75     |
  | Loose   | 70     |
  | Off     | 60     |
  | Miss    | 0      |
- **Rank:** SS≥95, S≥90, A≥80, B≥60, C≥50, D≥30, F<30.
- **Status:** `fail` (hp≤0), `clear` (hp>0), `pass` (clear AND acc≥50%).

## 4. Data Structure & Objects

**Paths:**
- `assets/songs/songs.txt` (one name per line, no ext).
- `assets/songs/[name]/[name]_data.json`
- `assets/songs/[name]/[name].mp3` (Audio)
- `assets/songs/[name]/[name].jpg` (Cover 150x150)
- `assets/songs/[name]/chart_[difficulty].json`

**`[name]_data.json`:**
```json
{
  "name": "Display Title",
  "artist": "Artist",
  "bpm": 120,
  "previewStart": 0.0,
  "timeSignature": "4/4",
  "difficulty": {
    "easy":   { "scrollSpeed": 1.0 },
    "medium": { "scrollSpeed": 1.5 },
    "hard":   { "scrollSpeed": 2.0 }
  }
}
```

**Chart Schema (`chart_[difficulty].json`):**
```json
{
  "lines": ["Kick", "Snare", "Hat", "Ride"],
  "notes": [
    { "line": "Kick", "notes": [
        { "time": 1.0, "strength": 1.2 },
        { "time": 1.75, "strength": 1.0 }
    ]}
  ]
}
```
- **`time`:** absolute beats (fractional ok).
- **`strength`:** BeatStrength 1.2/1.1/1.0.

**Core Objects:**
- **`TimeSignature`:** Parses `"4/4"` → fields `name`, `id`, `strongBeats`, `mediumBeats`, `beatsPerMeasure`.
- **`SongData`:** `new SongData(songName)` parses `_data.json` internally. Fields: name, artist, bpm, previewStart, timeSignature, scrollSpeed map.
- **`Song`:** Menu visual. `new(name)` creates `SongData`, loads cover + audio. Exposes `data:SongData`. No text. Base 175x325.
- **`SongScrollLine`:** Holds `Song` sprites. H-layout, 50px gap. L/R nav. `select(index)` scales/repositions. `get(index):Song`.
- **`PlayerStats`:** Runtime class (PlayState only). Fields: score, curHealth, maxHealth, combo, maxCombo, 6 rating counts. Handles health/score logic per §3.
- **`SongResult`:** Persistence/UI class. Fields: songName, difficulty, score, accuracy, rank, maxCombo, status, 6 rating counts.
  - `fromPlayerStats(stats, songName, diff)` → builds object.
  - `saveData(save:FlxSave)` → compares score, saves if higher.
  - `loadData(save:FlxSave, songName, diff):Bool` → reads save.
- **`Line` / `LineSprite` / `NoteGenerator` / `Note`:** `Note(sprite, hitTime, strength)`.

- **Editor Objects (Modular):**
  - **`EditorState`**: Orchestrator. Holds `songData`, `bpm`, `beatsPerMeasure`. Instantiates and links UI components.
  - **`EditorPanel`**: Top UI panel. `updateInfo(bar, totalBars, bpm, beats)`.
  - **`EditorGrid`**: Extends `FlxTypedSpriteGroup`. Draws rows, columns, beat lines. Holds `currentBar`. `changeBar(dir)` calls `rebuild()`.
  - **`EditorNavigation`**: Extends `FlxTypedSpriteGroup`. Renders `<` and `>`. Uses `onNavigate:Int->Void` callback on mouse click.

## 5. UI Layouts & Controls

**Menu Layout:**
- **Top:** Carousel (Selected ×1.2, centered). L/R changes index.
- **Bottom:** Info Panel (Name, Artist, BPM, Duration, Difficulty, High Score, Rank).
- **Controls:** `Left/Right` (select), `Tab` (cycle diff), `Enter` (Play), `7` (Editor), `Esc` (Loading).

**Play State:**
- **Controls:** `Esc/Enter` (Pause), `Q/Backspace` (Quit to Menu), `7` (Editor).

**Pause (Sub-state):**
- **Controls:** `Esc` (Resume), `Enter` (Select option), `Q/Backspace` (Menu). Options: Resume, Restart, Quit.

**Result State:**
- **Controls:** `Enter/Space/Esc` (Menu), `R` (Restart same song+diff).

**Editor Layout:**
- DAW grid. Rows=`Line`, Cols=beat/sub-beat slots (`subBeat` default 0.25 → 16 cols/bar for 4/4).
- **Grid Math:** `columnsPerBar = beatsPerMeasure / subBeat`.
- **BeatStrength:** `b = floor(t mod beatsPerMeasure)`. `b ∈ strongBeats`→1.2; `b ∈ mediumBeats`→1.1; else 1.0.
- **Editor Controls:**
  - `Left`/`Right` (kb) or mouse click on `<` `>` arrows: prev/next bar.
  - Mouse click (grid): toggle note (M4.2).
  - `Esc`: Auto-save JSON, exit.
- **Settings:** Can adjust scrollSpeed, bpm, #lines (writes to `_data.json` + chart). `subBeat` is Editor-only.

## 6. Unresolved (DO NOT GUESS — Stop and Ask)
- **U-034:** Tight, Loose, Off weights for Accuracy calculation are TBD.
- **Rule:** When Claude hits a missing API or spec conflict during coding, list it in the Handoff Prompt's **Unresolved Issues** field. Do NOT edit this file. Next ID: **U-035**.

## 7. Assumptions
- Notes scroll horizontally toward vertical hit line.
- **Lane keys:** Fixed by index in `chart_[difficulty].json`. Default 4 lanes `D`,`F`,`J`,`K`. Extend: `D`,`F`,`J`,`K`,`L`,`S`,...
- **Persistence:** "JSON" in PDF = `FlxSave` in code. `FlxSave` serializes to JSON.
