# TASK_TRACKER — Tech terror
> **Rule:** Read-only. Updates via Handoff Prompt.
> **Flow:** UI → Editor (Sample Chart) → Playstate → Result.

## Completed
- [x] **M0 — State skeleton:** App flow.
- [x] **M1 — Song loading:** `songs.txt` + `_data.json` metadata.
- [x] **M2.1 — Menu UI: Carousel & Layout:** `SongScrollLine`, `SongSprite`, L/R nav, Tab diff switch, scaling/centering.
- [x] **M2.1b — Fix Data Arch:** `SongData` parse (`timeSignature`→`TimeSignature`, `difficulty`→`scrollSpeed` map). `TimeSignature` class created. `SongLoader.hx` removed. `SongScrollLine` reads `songs.txt` + creates `new Song(name)`.
- [x] **M2.2 — Fix Menu Visuals:** `Song` load 150x150 cover (top), render name+artist (bottom). `MenuState` pass `songData`+`difficulty` via constructor. Info Panel: show Audio Duration.
- [x] **M3.1 — Fix State Constructors & Keys:** Add constructors to `PlayState`/`EditorState` (`songData`, `difficulty`). Fix `PlayState` keys (Quit `Q`/`Backspace`, Pause `Esc`/`Enter`). Fix `EditorState` exit `Esc`.
- [x] **M4.1 — Editor UI: Grid:** DAW grid, rows=lines, cols=beats/sub-beats. L/R bar nav.
- [x] **M4.1b — Editor UI Refinement:** Light background, arrows, column numbers, continuous rows, beat/bar separators.
- [x] **M4.1c — Refactor EditorState:** Split into EditorPanel, EditorGrid, EditorNavigation. Orchestrated by EditorState.
- [x] **M4.2 — Editor Interaction:** Mouse click toggle notes.

## Next (Unblocked - Exact Order)
- [ ] **M4.3b — NoteLayer:** Create class. Implement `toggle`, `refreshVisuals`, `clearLine`, `bind(grid)`.
- [ ] **M4.3c — EditorGrid Rewrite:** Remove `notes` Map, `cells`, `update()` click. Add getters, `rebuild()`, `cellAt()`.
- [ ] **M4.3d — EditorState Wiring:** Wire signals, route click to `noteLayer.toggle()`, call `refreshVisuals()`.
- [ ] **M4.3e — EditorPanel UI:** Add Sub-beat control, Hover Info Box, `isOver()` check.
- [ ] **M5.1 — Editor Save:** Auto-save `chart_[difficulty].json` on `Esc`. Assign `BeatStrength` via `TimeSignature`.
- [ ] **M5.2 — Editor Load:** Read existing `chart_[difficulty].json`.
- [ ] **M6.1 — Play: Chart Loading:** Load `chart_[difficulty].json`, init notes.
- [ ] **M6.2 — Play: Spawn & Move:** Spawn 2s early, move to line, recycle hit/miss.
- [ ] **M7.1 — Play: Input:** Map keys to lines. Empty press rules.
- [ ] **M7.2 — Play: Rating:** Timing windows (Perfect→Miss) via `secPerBeat`.
- [ ] **M8.1 — PlayerStats Class:** Define fields (health, score, combo, rating counts). Implement health init (`maxHealth=bpm`, 75% init) and fail condition.
- [ ] **M8.2 — PlayerStats Logic:** Implement hit/miss calculations (point, heal, combo) based on Rating & BeatStrength (`heso`).
- [ ] **M9.1 — SongResult Class:** Define fields & methods (`fromPlayerStats`, `saveData`, `loadData`). Ensure JSON serialization for FlxSave.
- [ ] **M9.2 — PlayState Outro & Save:** Calculate result at end of song/death. Call `saveData`. Switch to `ResultState(songResult)`.
- [ ] **M9.3 — Result UI:** Display `SongResult` data (Score, Accuracy, Rank, Combo, Status, Rating counts). Show "New Record!" if applicable.
- [ ] **M9.4 — Menu High Score UI:** In `MenuState.refresh()`, call `SongResult.loadData()`. Display High Score & Rank in Info Panel.
- [ ] **M10 — Pause State:** Sub-state overlay, `Esc`/`Enter` triggers, Resume/Restart/Quit.

## Blocked
- **M5.1 (Partially):** U-037 (Cho phép đổi `beatsPerMeasure` runtime? Đề xuất B: Không cho đổi, chỉ load. Sẽ chốt ở M5.1).
- **M9.1/M9.2:** Blocked by U-034 (Missing Tight/Loose/Off weights for Accuracy). Need Owner decision to finalize `SongResult` math.
