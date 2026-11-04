# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. These guidelines are based primarily on the four principles in the user's supplied Karpathy Skills document and are extended only where needed for the Tech terror project.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

---

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.
- Read the relevant project specification, module documentation, and source files before proposing a non-trivial change.
- Identify dependencies and possible side effects.
- If the requested change conflicts with an existing confirmed decision, point out the conflict instead of silently overriding it.

Do not rush into implementation.

For significant tasks, first present:
1. Your understanding of the request.
2. Relevant existing design/code.
3. Assumptions and unresolved questions.
4. Proposed approach and tradeoffs.

Wait for the owner's approval before significant design or architectural changes. Keep planning brief for small tasks.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- Avoid unnecessary dependencies and design patterns.
- Prefer the simplest implementation that fits the existing project design.
- Do not optimize prematurely; prioritize the project's stated performance requirements where they are relevant.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

Do not interpret "simplicity" as permission to omit required behavior, validation, cleanup, or documented edge cases.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting unnecessarily.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- Preserve existing behavior unless the owner explicitly requests a change.
- If you notice unrelated dead code, mention it - don't delete it.
- Check the relevant callers and dependants before changing a public interface.

When your changes create orphans:
- Remove imports, variables, and functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request or an approved necessary consequence.

If a change affects other modules, explain why and identify the affected components.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → define valid and invalid inputs, then inspect or test both.
- "Fix the bug" → identify its cause, construct a reproducible case, then verify the proposed fix.
- "Refactor X" → define which behavior must remain unchanged and check it before and after where possible.

For multi-step tasks, state a brief plan:
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]

Strong success criteria let you work independently. Weak criteria ("make it work") require clarification.

Continue reviewing until all checks possible in your environment are complete. State clearly which checks were actually performed and which remain for the owner.

---

# PROJECT-SPECIFIC RULES

## 5. Project Sources of Truth

Use project files according to their purpose:

- `PROJECT_SPEC.md`: product requirements, gameplay rules, state transitions, module/object design, data, known discrepancies, unresolved questions, and proposed implementation pipeline.
- `ARCHITECTURE.md`: a navigational summary of the architecture described in the specification. It must not introduce new design decisions.
- `DECISIONS.md`: concise index of decisions and unresolved items; the detailed source remains `PROJECT_SPEC.md`.
- `TASK_TRACKER.md`: current implementation progress and user-reported verification status.
- `MODULE_DOCS/`: focused documentation for a module only after its design has been discussed or confirmed.
- `REFERENCES/`: documentation and source references supplied by the owner.

The latest owner-confirmed decision takes precedence. If files disagree, report the inconsistency and ask; do not silently choose.

Do not treat a proposal, assumption, placeholder, or unresolved question as confirmed.

## 6. Technical Accuracy and API Verification

**Never invent APIs or library behavior.**

The project uses Haxe and HaxeFlixel.

- Use the exact-version Haxe/HaxeFlixel documentation and source code supplied by the owner as primary technical references.
- Inspect the project's existing code to establish actual usage and conventions.
- Verify classes, methods, properties, constructors, signatures, and lifecycle behavior before relying on them.
- Do not assume APIs from another framework or library version are compatible.
- Do not invent methods or silently replace an unknown API with an assumed equivalent.
- Do not use web examples or remembered API knowledge as proof when the supplied version-specific references are available.

If an API or behavior cannot be verified:
1. Name the uncertain API or behavior.
2. Explain what evidence is missing.
3. Ask for the relevant reference/source if needed.
4. Mark any suggested approach as provisional.

Distinguish verified facts, assumptions, and unverified details.

## 7. Development Environment Constraints

The owner compiles and tests the project locally.

- Do not attempt to install Haxe, Haxelib, Lime, or HaxeFlixel.
- Do not attempt to compile or run the project.
- Do not claim that code compiles, runs, or behaves correctly without actual verification.
- Perform static code inspection and logical review.
- Give the owner precise local build/test steps when useful.
- Treat compiler output, runtime behavior, and test results supplied by the owner as evidence for the next iteration.

Keep these separate:
- **Static review:** inspection performed by Claude.
- **Build verification:** compilation performed by the owner.
- **Runtime verification:** actual game behavior observed by the owner.

Never describe static review as a successful build or runtime test.

## 8. Project-Specific Technical Priorities

When relevant to the task, respect these confirmed priorities and constraints from `PROJECT_SPEC.md`:

- Target Web using the existing HaxeFlixel project.
- Processing speed and frame rate are important.
- When leaving `PlayState`, all objects created in it must be deleted.
- Note recycling is part of the design.
- Audio-latency calibration is out of scope.
- Visual effects are out of scope.
- `Config.hx` is unnecessary and is to be deleted manually by the owner. Do not add dependencies on it or recreate it.

Do not infer additional performance requirements or implementation mechanisms beyond the specification.

## 9. Architecture and Object Lifecycle

- Respect the state flow, module concepts, and object responsibilities recorded in `PROJECT_SPEC.md`.
- Do not invent a class layout from conceptual names.
- The names of gameplay concepts do not automatically dictate one class per concept.
- Before changing module boundaries, state transitions, public interfaces, or ownership, explain the impact and obtain approval.
- Inspect object creation, reuse/recycling, cleanup, event listeners, timers, tweens, state transitions, and references to destroyed objects when relevant.
- Follow lifecycle behavior verified for the project's actual HaxeFlixel version.

## 10. Documentation Discipline

- Read the relevant sections of `PROJECT_SPEC.md` before changing specified behavior.
- Read the relevant module document, if one exists, before editing that module.
- Update documentation only when an approved decision or implementation change makes it necessary.
- Keep confirmed, proposed, assumed, and unresolved information separate.
- Do not silently "fix" a discrepancy by rewriting the specification to match code, or code to match the specification.
- Record unresolved questions rather than guessing.

## 11. Implementation Workflow

For significant tasks:

1. **Analyze:** understand the request; inspect relevant spec, code, and references.
2. **Design:** identify responsibilities, interactions, data flow, dependencies, and tradeoffs.
3. **Review:** present the design and unresolved questions to the owner.
4. **Record:** update the relevant specification/decision/module document after approval.
5. **Implement:** make the smallest approved change.
6. **Inspect:** review code statically against acceptance criteria and related modules.
7. **Hand off:** explain changed files, checks performed, and what the owner must build/test.

For small, localized tasks, do not force the full process.

When delivering code:
- Prefer a complete updated file when practical.
- For a large file, provide a precise patch and exact insertion/replacement locations.
- Never label an incomplete excerpt as a complete file.
- Identify all changed files.
- Do not claim tests were run if they were not.

## 12. Communication

- Be concise and technically precise.
- Explain meaningful tradeoffs, not obvious implementation details.
- Challenge incorrect assumptions respectfully.
- Ask only questions that materially affect correctness or design.
- Do not ask for approval for trivial implementation details.
- Do not overwhelm the owner with repeated summaries of already-confirmed information.
- Never pretend to know or verify something that is not established.

## 13. Final Objective

Help the owner build a maintainable, technically correct, reliable game through controlled and verifiable development.

**Think before coding. Keep it simple. Make surgical changes. Define success and verify what you can.**
