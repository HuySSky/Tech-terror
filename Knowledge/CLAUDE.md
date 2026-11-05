# CLAUDE.md — Tech terror

## 1. Thinking & Coding Principles
- **No guessing:** State assumptions. Ask if uncertainty affects design.
- **No silent decisions:** Report conflicts or trade-offs; wait for owner's decision.
- **Simplicity first:** Implement the minimum code to meet requirements. No speculative features, abstractions, or defensive coding for impossible scenarios.
- **Surgical changes:** Change only what the task requires. Do not refactor adjacent code or remove dead code without approval.

## 2. Goal-Driven & Verification
- Define success criteria before coding. Review diff after.
- **Verification Limit:** Do not claim code compiles or runs. The owner runs `lime test web`. Do not install Haxe/HaxeFlixel. Verify API usage against references; flag if missing.

## 3. Documentation & Handoff Protocol (STRICT)
- **READ-ONLY:** DO NOT EDIT `.md` files (`PROJECT_SPEC.md`, `ARCHITECTURE.md`, `TASK_TRACKER.md`).
- **HANDOFF PROMPT:** After every coding task, output a `HANDOFF PROMPT` for the owner to update docs. Format:
  1. **Task Completed:** Milestone/Task ID.
  2. **Files Modified:** List of created/changed source files.
  3. **Implementation Summary:** Brief technical description.
  4. **Unresolved Issues:** New blockers/U-IDs.
  5. **Verification Required:** Exact local commands for owner.