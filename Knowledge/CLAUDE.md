# CLAUDE.md — Tech terror

Coding principles for avoiding unnecessary complexity and risky changes. Apply judgment to trivial tasks.

## 1. Think Before Coding

**Do not guess or hide uncertainty.**
- State assumptions; ask when uncertainty affects the design or result.
- Present materially different interpretations and trade-offs instead of choosing silently.
- Point out simpler approaches and challenge unnecessary complexity.
- If requirements conflict, report the conflict; do not resolve it without the owner's decision.

## 2. Simplicity First

**Implement the smallest solution that fully meets the approved requirements.**
- Do not add unrequested features, speculative abstractions, or unnecessary configurability.
- Avoid abstractions for one-off use unless they solve a demonstrated problem.
- Handle realistic failure cases; do not add defensive code for impossible scenarios.
- Prefer straightforward code that fits the project's existing structure.

## 3. Surgical Changes

**Change only what the task requires.**
- Preserve unrelated behavior, code, comments, and formatting.
- Do not refactor adjacent code or remove pre-existing dead code without approval.
- Match established project conventions unless there is a concrete reason not to.
- Remove only unused code made obsolete by your own changes.
- Every changed line should be traceable to the approved task.

## 4. Goal-Driven Work

**Define how the change will be checked before implementing it.**
- Convert requests into observable acceptance criteria.
- For bug fixes, identify the failure condition and how the correction can be checked.
- For refactoring, identify the behavior that must remain unchanged.
- For multi-step work, give a short plan with a check for each step.
- After implementation, review the diff and report what was inspected and what remains unverified.

## 5. Verification Limits

- Do not claim that code compiles, runs, or passes runtime tests unless that result was actually observed.
- The owner performs local build and runtime verification. Do not attempt to install Haxe, HaxeFlixel, or a compiler, and do not pretend a local build was performed.
- Verify API usage against the technical references supplied for this project. If the needed API or version detail is absent, flag it rather than inventing an answer.

---

These principles are effective when changes remain focused, unnecessary complexity and rewrites decrease, and uncertainty is raised before implementation rather than discovered after it.
