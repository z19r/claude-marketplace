# Skill Translator — Implementation Plan

## Goal

Create a standalone Claude Code plugin skill that translates programming-language-specific skills into equivalent skills for a different target language/framework. Deep translation — adapts architectural patterns, idioms, tooling, and project structure conventions, not just code block syntax. Single target language per invocation.

## Architecture

- **Plugin structure** mirroring skill-creator's layout (`.claude-plugin/plugin.json` + `skills/skill-translator/`)
- **SKILL.md** drives the workflow: analyze → translate → output
- **Reference files** provide ecosystem equivalence tables Claude consults during translation
- No eval infrastructure of its own — the user can run skill-creator's eval pipeline on the output if they want to verify

## Tech Stack

- Markdown (SKILL.md + references)
- Claude Code plugin format (plugin.json)

## Constraints

- Strictly programming languages — no natural language localization
- Single target per invocation
- Must preserve the source skill's core workflow/logic; only the implementation surface changes
- Output is a complete, usable skill — not a diff or patch

---

## Task 1: Plugin scaffold

**Files:**
- Create: `skill-translator/.claude-plugin/plugin.json`

**Interfaces:**
- plugin.json declares the plugin name, description, author

**Steps:**
1. Create `skill-translator/.claude-plugin/plugin.json` with name `skill-translator`, description covering the trigger cases
2. Verify structure matches skill-creator's plugin format

---

## Task 2: Ecosystem map reference

**Files:**
- Create: `skill-translator/skills/skill-translator/references/ecosystem-map.md`

**Interfaces:**
- Referenced from SKILL.md when Claude needs to look up equivalences

**Steps:**
1. Write `ecosystem-map.md` covering these dimensions across major languages (TypeScript, Python, Rust, Go, Java, Ruby, C#):
   - Package managers and dependency files
   - Test frameworks and test runners
   - Linters and formatters
   - Build tools and project structure
   - Error handling idioms
   - Async/concurrency patterns
   - Type system patterns
   - Common framework equivalences (web, CLI, data)
2. Verify each mapping is accurate and idiomatic for the target

---

## Task 3: Translation checklist reference

**Files:**
- Create: `skill-translator/skills/skill-translator/references/translation-checklist.md`

**Interfaces:**
- Referenced from SKILL.md as a systematic guide during the translation pass

**Steps:**
1. Write `translation-checklist.md` covering what to inspect in a source skill:
   - Frontmatter (name suffix, description rewording)
   - Code blocks (language tag, idiomatic rewrite)
   - Inline code references (file extensions, CLI commands, function signatures)
   - Tool/dependency names
   - Project structure assumptions (directory layouts, config files)
   - Framework-specific architectural patterns (flag when no clean equivalent exists)
   - Build/test/run commands
2. Include examples of shallow vs deep translation for each category

---

## Task 4: SKILL.md — main skill

**Files:**
- Create: `skill-translator/skills/skill-translator/SKILL.md`

**Interfaces:**
- Entry point for the skill; references `references/ecosystem-map.md` and `references/translation-checklist.md`

**Steps:**
1. Write frontmatter with name and pushy description (triggers on "translate skill", "convert skill to X", "port this skill", "make a Python version of this skill", etc.)
2. Write the workflow sections:
   - **Capture Translation Target**: identify source skill path, detect source language, confirm target language with user
   - **Analysis Phase**: read source skill, classify each section (language-agnostic / language-specific), summarize what will change and what stays — present to user before translating
   - **Translation Phase**: section-by-section deep translation using ecosystem-map and checklist references; flag sections with no clean equivalent and propose alternatives
   - **Output Phase**: write translated skill to `<original-name>-<target-lang>/SKILL.md`, preserving directory structure for any bundled resources; copy language-agnostic resources as-is, translate language-specific ones
   - **Review handoff**: present the translated skill for user review, offer to iterate
3. Include guidance on naming conventions for translated skills
4. Include guidance on handling bundled scripts (translate or flag for manual rewrite)

---

## Execution

Inline — 4 sequential tasks, all file creation, no test infrastructure needed.
