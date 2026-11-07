# CLAUDE.md — Tech terror

Behavioral guidelines for a HaxeFlixel rhythm game. Bias toward caution over speed; use judgment on trivial tasks.

## 1. Role & Core Principles

- **Zero-Fluff Output:** No explanations, no prose, no run instructions. Output ONLY complete file contents inside markdown blocks, each prefixed with a `### [path]` header (e.g., `### source/song/SongData.hx`). Do NOT write or edit any file in `source/` or elsewhere — the Owner pastes your code and runs tests. A one-line summary in the Handoff is the maximum allowed text.
- **No Guessing:** Verify Haxe/HaxeFlixel APIs before use. Missing API or missing logic → report as `U-xxx` (see `PROJECT_SPEC.md §6`).
- **Conflict Resolution:** Report exact discrepancies between `PROJECT_SPEC.md` and code. Do not silently pick one side.
- **Self-Instantiation:** Objects encapsulate their own creation/loading (`SongData.load(name)`, `new SongSprite(songData)`). No external Loader classes.
- **No Reinventing the Wheel:** Use stdlib (`FlxG.keys.justPressed`, `openfl.Assets.getText`, `Math.min/max`).

## 2. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- If a task has multiple valid interpretations, pick one and document the choice in the Handoff's Unresolved Issues; do NOT silently guess.
- If a simpler approach exists than what the task literally asks, use it and note it in the summary. Push back when warranted.
- If something is genuinely unclear (missing API, conflicting spec, undefined data flow), **stop and ask**. Name what's confusing.
- Do not stack assumptions and hope they're right.

This does not contradict Zero-Fluff: thinking happens before the response; the response itself still contains only code + Handoff.

## 3. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No defensive validation for data we generated ourselves (see `EXAMPLES.md §2`).
- If you write 200 lines and it could be 50, rewrite it.

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 4. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it in the Handoff — don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that **your** changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: every changed line should trace directly to the task.

## 5. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform each task into a verifiable goal:
- "Add X" → "X exists, compiles, and matches `PROJECT_SPEC.md`".
- "Fix bug Y" → "Y no longer occurs under the conditions described in the task".
- "Refactor Z" → "behavior unchanged; no unrelated lines touched".

For multi-step tasks (e.g., M2.2 = cover load + text render + constructor passing + duration), state a brief plan in the summary:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
```

Strong criteria let you work independently. Weak criteria ("make it work") require constant clarification.

**Note:** This project has no test suite. Verification is Owner-run via `lime test web` (§6). Do not write tests unless explicitly asked.

## 6. Workflow (Code-First)

- **Default:** Read relevant spec/architecture sections → Write Code → Handoff.
- **Stop & Ask:** Only when missing APIs, conflicting docs, or `U-xxx` blockers prevent progress.
- **Wait for Approval:** Architectural changes (new core classes, data flow changes, spec deviations).

## 7. Verification

- Owner verifies via `lime test web`. **NEVER claim code runs or has been tested.**
- If unsure a method exists in HaxeFlixel 5.x, say so in the Handoff rather than guessing.

## 8. Handoff Prompt (MANDATORY & ULTRA-SHORT)

End EVERY response with this exact format:

1. **Task:** [ID]
2. **Files:** [List]
3. **Summary:** [1 sentence max]
4. **Unresolved Issues:** [None, or `U-xxx: 1-line description` — list new issues here only. Do NOT edit `PROJECT_SPEC.md`; the Owner will append them.]
---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.