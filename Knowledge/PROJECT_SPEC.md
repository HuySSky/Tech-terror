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
- **Scale:** Max ~100 songs. Optimize.
- **Flow:** Load → UI → audio → 3s countdown → gameplay (input active).
- **Note Spawn:** 2s before hit time.
- **Persistence:** `FlxSave` for results/config. JSON import/export for Editor. Web test-only.

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
**Health:** `maxHealth=bpm`. Initial `0.75*maxHealth`. Clamp `[0,maxHealth]`. Fail `curHealth<=0`.

**Result:**
- **Score:** Σ `point` across judged notes.
- **Max Score:** Σ `basePoint * 1.2 * note.heso` over all notes.
- **Accuracy:** `(Score / Max Score) * 100`.
- **Rank:** SS≥95, S≥90, A≥80, B≥60, C≥50, D≥30, F<30.
- **Combo:** Hit+1, Miss reset 0.
- **Status:** `fail` (hp≤0), `clear` (hp>0), `pass` (clear AND acc≥50%).

## 4. Data Structure

**Paths:**
- `assets/songs/songs.txt`
- `assets/songs/[name]/[name]_data.json`
- `assets/songs/[name]/chart_[difficulty].json` (e.g., `chart_easy.json`)

**`songs.txt`:** One name per line, no ext, no path. E.g. `song1\nsong2`.

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
- **`previewStart`:** seconds into audio.
- **`timeSignature`:** string (e.g., `"4/4"`). Parsed by `TimeSignature`.
- **`difficulty`:** map may omit diffs.

**`TimeSignature` (class):** parses string `"4/4"` → `name`(String), `id`(Int), `strongBeats:Array<Int>`, `mediumBeats:Array<Int>`, `beatsPerMeasure`(Int, numerator). Beat indices 0-based within measure.

**`SongData` (class):** fields `name`, `artist`, `bpm`, `previewStart`, `timeSignature`, `difficulty→scrollSpeed`. Loaded via `SongData.load(name)` (parses own `_data.json`). NOT contains `subBeat` (Editor-only).

**Chart scope:** one `chart_[difficulty].json` per diff. Diff affects `scrollSpeed`, high score, file loaded.

**Chart Schema (`chart_[difficulty].json`):** lines = instrument names (strings).
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

**Editor Grid Math:**
- `columnsPerBar = beatsPerMeasure / subBeat`
- `beatsPerMeasure` = time sig numerator (4 for 4/4).
- `subBeat` = Editor-internal (default 0.25 → 16 cols/bar for 4/4).

**Editor Settings:** can adjust `scrollSpeed`, `bpm`, #lines, `subBeat`. On save: write `scrollSpeed`, `bpm`, `lines` → `_data.json` + `chart_[difficulty].json`. `subBeat` kept as Editor state (not saved to song data).

**Editor BeatStrength assignment:** for note at time `t`: `b = floor(t mod beatsPerMeasure)`. `b ∈ strongBeats`→1.2; `b ∈ mediumBeats`→1.1; else 1.0.

**Core Objects:**
- `SongData`: see above.
- `TimeSignature`: see above.
- `SongSprite`: Menu visual. `new(songData:SongData)`. Loads own cover (150x150 placeholder) + audio. No text.
- `SongScrollLine`: Container. Reads `songs.txt`, calls `SongData.load(name)`. H-layout, 50px gap.
- `SongResult`: `(score:Int, accuracy:Float, rank:String, maxCombo:Int, status:String)`.
- `Line`, `LineSprite`, `NoteGenerator`, `Note`: `(sprite, hitTime, strength)`.

### 4.1 Menu UI Layout

**Top Half (Carousel):**
- `songScrollLine` holds `songSprite`s, H-arranged, 50px gap.
- Selected scales ×1.2, screen-centered; others ×1.0.
- `Left`/`Right` change index, shift line so selected centered.

**Bottom Half (Info Panel):** dark overlay. Shows:
- Song Name, Artist, BPM, Duration (from audio), Current Difficulty.
- High Score & Rank for current song+diff (from `FlxSave`).

**`songSprite` Specs:**
- Base 175x325 (placeholder solid color if no cover).
- Cover 150x150, centered H, offset Y=30 (top half).
- Text bottom half: song name + artist.

**Controls:**
- `Left`/`Right`: update `selectedIndex`, reposition line, refresh Info.
- `Tab`: cycle diff (Easy→Medium→Hard). Update Info high score.
- `Enter`: → `PlayState` with current `songData` + `difficulty`.
- `7`: → `EditorState` with current `songData`.

## 5. State Transitions & Controls

**Loading ↔ Menu:** `Enter`/`Space`→Menu; `Esc`→Loading.

**Menu → Play/Editor:** `Enter`→Play; `7`→Editor; `Left`/`Right`→select; `Tab`→diff.

**Play → Result/Editor/Menu:** end/death→Result; `7`→Editor; `Q`/`Backspace`→Menu.

**Pause:** In Play: `Esc`/`Enter`→Pause. In Pause: `Esc`→Resume; `Enter`→select option; `Q`/`Backspace`→Menu.

**Result → Menu/Play:** `Enter`/`Space`/`Esc`→Menu; `R`→Restart (same `songData`+`difficulty`).

**Editor Controls:**
- Change Bar: `Left`/`Right` (kb or UI buttons).
- Toggle Note: mouse click.
- Exit: `Esc` (auto-save `chart_[difficulty].json` first; Windows only).
- Load on open: reads existing `chart_[difficulty].json`.

## 6. Unresolved (DO NOT GUESS — Stop and Ask)
- None at this time.
- **Rule:** When Claude hits a missing API or spec conflict during coding, append a new `U-xxx` here (1-line description). Next ID: **U-027**.

## 7. Assumptions
- Notes scroll horizontally toward vertical hit line. Tap only. Bar=measure, beat=phách.
- **Lane keys:** fixed per `lines` index in `chart_[difficulty].json`. Default 4 lanes `D`,`F`,`J`,`K`. More lanes → extend (`D`,`F`,`J`,`K`,`L`,`S`,...).
- **Persistence:** "JSON" in PDF = `FlxSave` in code. `FlxSave` serializes to JSON.
