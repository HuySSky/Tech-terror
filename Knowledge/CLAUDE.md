# CLAUDE.md — Tech terror

## 1. Coding Principles
- **No Guessing:** Never invent Haxe/HaxeFlixel APIs. Verify against references; flag if missing.
- **Simplicity:** Minimum code for requirements. No unrequested features or speculative abstractions.
- **Surgical:** Change only what the task requires. Do not refactor adjacent code without approval.
- **Context:** If docs/code conflict, report the exact discrepancy. Do not silently choose.

## 2. Verification Limit
- Do not claim code compiles or runs. Owner handles `lime test web`.

## 3. Handoff Prompt Format (STRICT)
At the end of every coding response, you MUST output:
1. **Task Completed:** Milestone/Task ID.
2. **Files Modified:** List of created/changed source files.
3. **Implementation Summary:** Brief technical description.
4. **Unresolved Issues:** New blockers/U-IDs.
5. **Verification Required:** Exact local commands (e.g., `lime test web`).