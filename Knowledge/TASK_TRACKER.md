# TASK_TRACKER — Tech terror

> **Rule:** Read-only. Updates via Handoff Prompt.
> **Flow Strategy:** UI -> Editor (Create Sample Chart) -> Playstate -> Result.

## Completed
- [x] **M0 — State skeleton:** App flow.
- [x] **M1 — Song loading:** Load `songs.txt` & `_data.json` metadata.

## Next (Unblocked - Follow this exact order)
- [ ] **M2 — Menu UI:** Display `songScrollLine`, navigation (left/right), difficulty switch (Tab), pass data to Play/Editor.
- [ ] **M3 — Playstate Placeholder:** Empty Playstate that accepts `songData` and allows returning to Menu (`Q`/`Backspace`).
- [ ] **M4 — Editor Core UI:** DAW-style grid, mouse clicking to toggle notes, scrolling.
- [ ] **M5 — Editor Save/Load:** Export/Import `chart.json`. **Owner will manually create the first sample song using this Editor.**
- [ ] **M6 — Playstate Note System:** Load `chart.json`, spawn notes 2s early, move them to the line, recycle.
- [ ] **M7 — Playstate Input & Rating:** Handle keyboard input, timing windows (Perfect to Miss), empty press rules.
- [ ] **M8 — PlayerStats:** Health/Score formulas (using `BeatStrength`).
- [ ] **M9 — Result State:** UI flow, save results via `FlxSave`, formulas.
- [ ] **M10 — Pause State:** Implement sub-state with `Esc`/`Enter` triggers and Resume/Quit options.

## Blocked
- None. All U-issues are resolved.