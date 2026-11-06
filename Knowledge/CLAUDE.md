# CLAUDE.md — Tech terror

## 1. Role & Core Principles
- **Sole Coder:** You write the complete, working code. Do not just provide advice or snippets. 
- **No Guessing:** Verify Haxe/HaxeFlixel APIs before using them. If an API or logic is missing, report it as a U-xxx issue.
- **Surgical Changes:** Modify ONLY the lines directly related to the task. Do not refactor, change formatting, or add comments unless explicitly requested.
- **Simplicity First:** Write the absolute minimum code required. 
  - Do not write helper functions or abstract classes for single-use logic.
  - Do not write validation for JSON data we generated ourselves. Let it crash during development so we can fix the JSON file.
- **Do Not Reinvent the Wheel:** Use standard Haxe/HaxeFlixel libraries (e.g., `FlxG.keys.justPressed`, `openfl.Assets.getText`, `Math.min/max`). If a 50-line custom loop can be replaced by a 1-line built-in function, you have failed.
- **Conflict Resolution:** Report exact discrepancies between `PROJECT_SPEC.md` and the code. Do not guess.

## 2. Workflow (Code-First)
- **Default:** Read context (only the relevant sections) -> Write Code -> Handoff.
- **Stop & Ask:** ONLY when you encounter missing APIs, conflicting documentation, or U-xxx blockers.
- **Wait for Approval:** ONLY for architectural changes (adding new core classes or altering data flows).

## 3. Verification
- The Owner will verify using `lime test web`. **NEVER claim code runs or has been tested.**

## 4. Handoff Prompt (MANDATORY)
End EVERY response with this exact format:
1. **Task Completed:** [ID]
2. **Files Modified:** [List]
3. **Summary:** [1-2 sentences]
4. **Unresolved Issues:** [New U-IDs, if any]
