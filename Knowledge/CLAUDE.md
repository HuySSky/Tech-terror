# CLAUDE.md — Tech terror

## 1. Coding Principles
- **No Guessing:** Verify Haxe/HaxeFlixel APIs. Flag if missing.
- **Simplicity:** Minimal code. No unrequested features.
- **Surgical:** Change only what the task requires. No refactoring without approval.
- **Conflict:** Report docs/code discrepancies. Do not guess.
- **Schema:** Follow `PROJECT_SPEC.md` strictly.

## 2. Verification Limit
- Do not claim code compiles/runs. Owner verifies via `lime test web`.

## 3. Handoff Prompt Format (STRICT)
EVERY coding response MUST end with:
1. **Task Completed:** ID.
2. **Files Modified:** List.
3. **Implementation Summary:** Brief.
4. **Unresolved Issues:** New blockers/U-IDs.
5. **Verification Required:** Local commands.