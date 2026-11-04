# MODULE_DOCS

This directory contains focused design documents for modules/objects described in `PROJECT_SPEC.md`.

Do not create detailed module specifications by guessing from a name. First inspect the original design material and current source, then discuss missing responsibilities and interfaces with the owner.

## Suggested documents

Create only when needed:
- `LOADING.md`
- `MENU.md`
- `SONG_OBJECTS.md` (songData, songObject, songScrollLine, songResult)
- `PLAY.md`
- `NOTE_AND_LINE.md`
- `NOTE_GENERATOR.md`
- `INPUT_AND_NOTE_SYSTEM.md`
- `PLAYER_STATS.md`
- `PAUSE_SETTING.md`
- `RESULT.md`
- `EDITOR.md`

These are suggested documentation groupings, not confirmed class names or mandatory one-class-per-file boundaries.

## Module document template

# <Module or object group>

## Status
- Design: CONFIRMED / PROPOSED / NEEDS REVIEW
- Implementation: NOT ASSESSED / IN PROGRESS / IMPLEMENTED / OWNER-TESTED
- Related source files:

## 1. Responsibility
Describe only responsibilities supported by the design or approved by the owner.

## 2. Data
- Inputs:
- Outputs:
- Stored state:

## 3. Interactions
List collaborators and explain the interaction/data flow. Mark unknown interactions as unresolved.

## 4. Lifecycle
Creation, activation, pause, cleanup, destruction, and resource ownership where relevant.

## 5. Constraints
Gameplay, performance, framework, and scope constraints.

## 6. Unresolved questions
Do not silently decide these.

## 7. Acceptance criteria
Observable conditions that define completion.

## 8. Verification
- Static review:
- Owner build test:
- Owner runtime test:
