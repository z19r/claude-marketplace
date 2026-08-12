---
name: skill-translator
description: Translate programming-language-specific Claude Code skills into equivalent skills for a different target language or framework. Deep translation — adapts code examples, tooling, project structure, architectural patterns, and idioms, not just syntax swaps. Use whenever someone wants to port, convert, adapt, or translate an existing skill to another programming language, or says things like "make a Python version of this skill", "port this to Rust", "I need this skill but for Go", "translate this to Dart", "convert this TypeScript skill to Ruby". Also use when someone has a skill that works for one language and wants it to work for a different one, even if they don't use the word "translate".
---

# Skill Translator

Translate a skill written for one programming language/framework into an idiomatic equivalent for a different target language. This is deep translation — architectural patterns, error handling idioms, tooling, and project structure all adapt to the target ecosystem. The source skill's core workflow and logic stay identical; only the implementation surface changes.

## Workflow

### Phase 1: Capture Translation Target

Identify three things before starting:

1. **Source skill** — the skill to translate. Ask the user for the path. Read the entire SKILL.md and scan any bundled resources (scripts/, references/, assets/).

2. **Source language** — detect from the skill's code blocks, tooling references, and framework patterns. Confirm with the user: "This skill appears to be written for TypeScript/React — is that right?"

3. **Target language** — ask what language/framework to translate to. Be specific: "Python" is a language, but "Python with FastAPI" vs "Python with Django" produces very different translations. If the skill involves a web framework, CLI framework, or other domain-specific tooling, ask which target framework they want.

### Phase 2: Analysis

Before translating anything, read the source skill thoroughly and classify every section:

**Language-agnostic sections** (copy as-is):
- Workflow descriptions in prose
- Conceptual explanations
- Decision trees and conditional logic
- User interaction instructions
- Frontmatter structure (except name/description)

**Language-specific sections** (must translate):
- Code blocks and inline code
- File paths and extensions
- CLI commands (build, test, lint, run)
- Package/dependency references
- Project structure assumptions
- Error handling patterns
- Framework-specific architectural patterns

Present the analysis to the user as a summary before proceeding:

> **Translation summary for `<skill-name>` → `<target>`:**
> - X code blocks to translate
> - Y CLI commands to update
> - Z framework patterns to adapt
> - N sections that are language-agnostic (no changes needed)
> - Any patterns with no clean equivalent (listed specifically)
>
> Ready to translate?

Wait for confirmation.

### Phase 3: Translation

Work through the source skill section by section. For each language-specific section, consult the references:

- Read `references/ecosystem-map.md` for tooling and framework equivalences
- Read `references/translation-checklist.md` for the systematic inspection guide

Translation principles:

1. **Idiomatic over mechanical.** A list comprehension in Python is not `items.map()` with different syntax — it's a fundamentally different construct. Write code the way an expert in the target language would write it, not the way a TypeScript developer would write it in Python.

2. **Preserve the teaching intent.** If a code example exists to show "how to handle errors in this workflow", the translated example should teach the same lesson using the target language's error handling idiom — even if the pattern looks completely different (try/catch → Result<T,E> → if err != nil).

3. **Flag gaps explicitly.** When the source skill relies on a pattern with no clean equivalent in the target (e.g., React hooks → Go), don't silently drop it. Add a brief note in the translated skill explaining the gap and the recommended alternative. Format: `<!-- Translation note: [explanation] -->`

4. **Translate bundled resources.** For skills with scripts/, references/, or assets/:
   - Language-agnostic files (markdown, images, config schemas): copy unchanged
   - Scripts written in the source language: translate fully to the target language
   - If a script is too complex to translate confidently, flag it and explain what it does so the user can decide

5. **Naming conventions.** Apply the target language's naming conventions throughout — camelCase → snake_case, PascalCase → PascalCase, etc. This applies to function names, variable names, file names, and directory names in examples.

### Phase 4: Output

Write the translated skill to a new directory alongside the source:

```
<source-skill-name>-<target-lang>/
├── SKILL.md
├── references/     (if source had them)
├── scripts/        (if source had them, translated)
└── assets/         (if source had them, copied)
```

The translated SKILL.md frontmatter:
- **name**: `<source-name>-<target-lang>` (e.g., `deploy-helper-python`)
- **description**: same triggering intent as the source, with technology names swapped to the target ecosystem

### Phase 5: Review & Evaluation

Present the translated skill to the user:

1. Show a side-by-side diff of key sections — original code block vs translated code block for 2-3 representative examples
2. List every translation note / gap flagged during translation
3. Ask: "Does this look right? Anything I should adjust?"

Iterate until the user is satisfied.

### Phase 6: Test the Translated Skill

Once the user approves the translation, offer to run test cases to verify the translated skill produces correct output in the target language.

#### Step 1: Create test prompts

Write 2-3 realistic test prompts — tasks a real user would give the translated skill. Save to `<skill-name>-<target-lang>-workspace/evals/evals.json`:

```json
{
  "skill_name": "<translated-skill-name>",
  "evals": [
    {
      "id": 1,
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

See `references/schemas.md` for the full schema.

#### Step 2: Run test cases

For each test case, spawn two subagents in the same turn:

**With translated skill** — point at the translated skill, save outputs to `iteration-1/eval-<ID>/with_skill/outputs/`.

**With original skill** — point at the source skill as baseline, save outputs to `iteration-1/eval-<ID>/original_skill/outputs/`. This lets the user compare whether the translated skill produces equivalent results.

Put results in `<skill-name>-<target-lang>-workspace/` as a sibling to the translated skill directory.

#### Step 3: Draft assertions while runs are in progress

Write assertions that verify the translation preserves behavior — the translated skill should produce functionally equivalent output to the original, just in the target language. Update `eval_metadata.json` files with assertions. See `references/schemas.md` for assertion schema.

#### Step 4: Grade and launch the viewer

Once all runs complete:

1. **Grade each run** — spawn a grader subagent that reads `agents/grader.md` and evaluates assertions against outputs. Save results to `grading.json` in each run directory. Use fields `text`, `passed`, and `evidence` in the expectations array.

2. **Aggregate into benchmark**:
   ```bash
   python -m scripts.aggregate_benchmark <workspace>/iteration-1 --skill-name <name>
   ```

3. **Launch the viewer**:
   ```bash
   nohup python eval-viewer/generate_review.py \
     <workspace>/iteration-1 \
     --skill-name "<translated-skill-name>" \
     --benchmark <workspace>/iteration-1/benchmark.json \
     > /dev/null 2>&1 &
   ```

   In headless environments, use `--static <output_path>` for a standalone HTML file.

4. Tell the user the viewer is open and explain the two tabs (Outputs for qualitative review, Benchmark for quantitative comparison).

#### Step 5: Iterate

Read `feedback.json` after the user finishes reviewing. Improve the translated skill based on feedback, rerun tests into `iteration-2/`, and repeat until the user is satisfied.

### Phase 7: Description Optimization (optional)

After the translated skill is finalized, offer to optimize the description for accurate triggering in the target ecosystem. Run the optimization loop:

```bash
python -m scripts.run_loop \
  --eval-set <path-to-trigger-eval.json> \
  --skill-path <path-to-translated-skill> \
  --model <model-id-powering-this-session> \
  --max-iterations 5 \
  --verbose
```

Use the eval review template at `assets/eval_review.html` to let the user review trigger queries before running the loop.

### Phase 8: Package

If the `present_files` tool is available, package the translated skill:

```bash
python -m scripts.package_skill <path/to/translated-skill-folder>
```

Direct the user to the resulting `.skill` file.

## Handling Edge Cases

**Multi-language skills**: Some skills already support multiple languages (e.g., a "cloud deploy" skill with AWS/GCP/Azure variants). In this case, translate only the language-specific parts — the multi-variant structure stays the same.

**Skills with no code**: If the source skill is entirely prose (workflow instructions, checklists), there's nothing to translate. Say so and ask if they want to proceed anyway (maybe the prose references language-specific concepts that should be updated).

**Unfamiliar target language**: The ecosystem map covers TypeScript, Python, Rust, Go, Ruby, and Dart/Flutter. For any other language, translate using your own knowledge — the translation checklist still guides what to inspect. Let the user know you're working without pre-built equivalence tables and they should review more carefully.

**Bundled scripts that are large or complex**: For scripts over ~200 lines, give the user a choice: translate the full script (may need manual verification), write a stub with clear documentation of what each function should do, or skip the script and flag it.
