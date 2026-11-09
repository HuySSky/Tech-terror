# EDITOR_DESIGN — Tech terror
> **Status:** Confirmed design for M4.4–M4.7.
> **Supersedes** the Editor sections of `PROJECT_SPEC.md §4/§5` and `ARCHITECTURE.md §2` where they conflict. Those files remain read-only; this file is the up-to-date reference for the Editor.

## 1. Confirmed Editor Architecture
- **EditorGrid** creates notes: sets `line`, `absBeat`, `x`, `y`, loads the line's instrument graphic.
- **NoteLayer** stores `NoteEntity`s. Does NOT know `EditorGrid`. Receives `currentBar`, `beatsPerMeasure` via setters.
- **EditorState** wires everything.

Corrections vs earlier docs:
- `x, y` are set by `EditorGrid.gridOnClick` (NOT by `NoteLayer.refreshVisuals`). Task 2 (relocating x/y to Layer) is **cancelled**.
- `refreshVisuals()` only sets `visible`.
- No `FlxTypedSignal` for Editor hover. Polling `lastHovered` from `EditorState.update` is intentional.

## 2. M4.4 — Toggle delete (Task 3)
**Behavior:** clicking a grid cell either creates a note, or removes the note that already occupies that exact `(line, absBeat)`.

**Click routing:**
- Cell click → `EditorGrid.gridOnClick(cell)` (single owner of click).
- Note click → **disabled**. `NoteLayer.add()` attaches only hover/out (see §3).

**EditorGrid.gridOnClick(cell):**
1. `absBeat = currentBar * beatsPerMeasure + col * subBeat`
2. `line = lines[row]`
3. `existing = noteLayer.findAt(line, absBeat, EditorConstants.EPSILON)`
4. If `existing != null` → `noteLayer.removeNote(existing)`; return.
5. Else create new `NoteEntity` (via `noteLayer.recycle`), set `line`, `absBeat`, `x`, `y`, load graphic (§4.5), `noteLayer.add(note)`.

**NoteLayer additions:**
```haxe
public function findAt(line:String, absBeat:Float, eps:Float):Null<NoteEntity>
public function removeNote(note:NoteEntity):Void
```
`removeNote`: `FlxMouseEvent.remove(note)` → `members.remove(note)` → `note.destroy()`. Call `refreshVisuals()` at end.

## 3. M4.5 — Hover info (Task 4)
**Owner direction:** no signals. Use `FlxMouseEvent` hover/out. Show hover info in Panel, not floating over the note.

- `NoteLayer.add(note)`: `FlxMouseEvent.add(note, null, null, onNoteHover, onNoteOut)`.
- `onNoteHover(note)`: `lastHovered = note`.
- `onNoteOut(note)`: `if (lastHovered == note) lastHovered = null`.
- `NoteLayer.lastHovered:Null<NoteEntity>` (public read).
- `EditorState.update`: call `panel.updateHover(layer.lastHovered)` every frame.
- `EditorPanel.updateHover(note:Null<NoteEntity>)`: if `null` → clear hover row; else render `line`, `bar`, `beat`, `offsetMs`.

Note callback is `null` (no click on note). Cell click owns toggle (§2).

## 4. M4.6 — Instrument picker (Task 5a)

### 4.1 Assets
- Manifest: `assets/images/instruments_name.txt` — one name per line, trimmed, empty lines skipped.
- Graphic per name: `assets/images/[name].jpg`.
- Pre-load at `EditorState.create()`.
- New file `editor/Instruments.hx`:
  - `static loadAll():Void` — read manifest, `Assets.getBitmapData` each jpg, cache in `Map<String, FlxGraphic>`.
  - `static names():Array<String>`
  - `static graphic(name:String):FlxGraphic`
- **Fallback:** missing name → gray square, `trace` warning.

### 4.2 Click routing
- `EditorGrid.load` wraps each line icon (`SPRITE_SIZE` square) with `FlxMouseEvent.add(icon, () -> onIconClick(row), null, null, null)`.
- `EditorGrid.onIconClick:Int->Void` — plain function-ref callback set by `EditorState`. Not a signal.
- `EditorState` wires: `grid.onIconClick = row -> openInstrumentPicker(row)`.

### 4.3 Picker UI
- New file `editor/InstrumentPickerState.hx` — a `FlxSubState` (modal, blocks grid input).
- Layout: vertical list of `FlxText` buttons inside a panel (reuse Panel colors).
- Click name → `onPick(name:String)`; `close()`.
- `Esc` → `close()` without change.
- Center on screen.
- Library: `FlxSubState` + `FlxText` + `FlxG.mouse.overlaps` — no extra libs needed.

### 4.4 Rename application
`EditorGrid.applyRename(row:Int, newName:String)`:
1. `oldName = lines[row]`
2. If `oldName == newName` → return.
3. `lines[row] = newName`
4. Reload icon: `icon.loadGraphic(Instruments.graphic(newName))`, scaled to `SPRITE_SIZE`.
5. For each `note in noteLayer.members` where `note.line == oldName`:
   - `note.line = newName`
   - `note.loadGraphic(Instruments.graphic(newName))`, scaled to note size.
6. `noteLayer.refreshVisuals()`.

### 4.5 Note sprites
Notes currently are red `makeGraphic` rects. Replace with instrument jpg:
- Width: `Math.round(GRID_W / 32)` (unchanged; matches `PROJECT_SPEC.md §5` for 4/4).
- Height: `Math.round(ROW_H * 0.8)`.
- Load: `note.loadGraphic(Instruments.graphic(line))` then `setGraphicSize` to the target if the jpg is larger.

## 5. M4.7 — Strumline (Task 5b)

### 5.1 What it is (Editor-only)
A vertical cursor over the grid that shows "music currently playing" position. Moves left→right during playback. Editor-only. Does NOT exist in `PlayState`.

### 5.2 Class: `editor/EditorStrumline.hx`
Extends `FlxSprite` (1px wide vertical rect, from `ROW_Y` to bottom of last row).

Fields:
- `currentBeat:Float` — position within current bar, `[0, beatsPerMeasure)`.
- `markBeat:Float` — marked start position (same range).
- `isPlaying:Bool` — false initially.
- `beatsPerMeasure:Int` (setter)
- `totalBars:Int` (setter)
- `currentBar:Int` (setter, synced with `EditorGrid.currentBar` via `EditorState`)

**Position conversion:**
```
pixelsPerBeat = GRID_W / beatsPerMeasure
x = GRID_X + currentBeat * pixelsPerBeat
y = ROW_Y
height = lines.length * ROW_PITCH
```

### 5.3 Click routing (set marker + scrub)
Click on the column-number row (the `FlxText` numbers rendered by `EditorGrid.load`).

- `EditorGrid` adds `FlxMouseEvent.add(numText, () -> onColumnNumClick(col), null, null, null)`.
- `EditorGrid.onColumnNumClick:Int->Void` — plain callback set by `EditorState`.
- `EditorState` handler:
  - `beatInBar = col * subBeat`
  - `strumline.markBeat = strumline.currentBeat = beatInBar`
  - Seek audio to mark beat (see §5.5).

### 5.4 Space toggle
`EditorState.update`:
```
if (FlxG.keys.justPressed.SPACE) strumline.togglePlay();
```
`EditorStrumline.togglePlay()`:
- If `!isPlaying`: `isPlaying = true`; `currentBeat = markBeat`; seek audio to `markBeat`; play audio.
- If `isPlaying`: `isPlaying = false`; `currentBeat = markBeat`; pause audio; seek audio to `markBeat`.

`EditorStrumline.update(elapsed)` when `isPlaying`:
```
currentBeat += (bpm / 60) * elapsed
if (currentBeat >= beatsPerMeasure):
    currentBar += 1
    currentBeat -= beatsPerMeasure
if (currentBar > totalBars - 1): isPlaying = false
```
Recompute `x` after each update.

### 5.5 Audio seek / play — **BLOCKED (U-042)**
`EditorState` receives `songData:SongData`, not the folder name. Audio path is `assets/songs/[folder]/[folder].mp3`, where `[folder]` is the constructor arg of `new SongData(...)`, NOT `songData.name` (display title).

Two options pending Owner:
- **(a)** Store `songName` in `SongData` (set in `load()` from constructor arg).
- **(b)** Add `songName` parameter to `EditorState` constructor; thread from `MenuState`.

Until resolved, implement M4.7 **visually only** (strumline animates, clicks set beat, no audio).

### 5.6 Persistence
**No save** of strumline beat/mark. `chart_[difficulty].json` schema unchanged.

## 6. Task order
1. **M4.4** — Toggle delete
2. **M4.5** — Hover info
3. **M4.6** — Instrument picker
4. **M4.7** — Strumline (visual only until U-042 resolved)

## 7. U-issues
- **U-042:** `EditorState` needs `songName` (folder name) for audio play/seek in M4.7. Option (a) or (b) in §5.5 — Owner decides.
```

---

1. **Task:** Editor design — M4.4 / M4.5 / M4.6 / M4.7 (Tasks 3, 4, 5a, 5b).
2. **Files:** `EDITOR_DESIGN.md` (new, supersedes Editor sections of `PROJECT_SPEC.md §4/§5` + `ARCHITECTURE.md §2`).
3. **Summary:** Toggle via `gridOnClick` + `NoteLayer.findAt/removeNote`; hover via `lastHovered` polling (no signals); instrument picker = modal `FlxSubState` + `Instruments` cache; strumline = vertical cursor + Space play/pause, click number row to mark — audio blocked on U-042.
4. **Unresolved Issues:** `U-042: EditorState cần songName (folder) cho audio strumline — chọn (a) thêm field SongData hay (b) thêm param EditorState?`