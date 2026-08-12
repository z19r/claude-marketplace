# Translation Checklist

Systematic guide for what to inspect and translate in a source skill. Work through each category in order. For each item, decide: **translate** (has a clean equivalent), **adapt** (no direct equivalent — redesign the pattern), or **flag** (needs user input).

## 1. Frontmatter

- [ ] **name**: append target language suffix (e.g., `deploy-helper` → `deploy-helper-python`)
- [ ] **description**: replace source language/framework references with target equivalents. Keep the triggering intent identical — same verbs, same use cases, just different technology names

## 2. Code Blocks

For every fenced code block in the skill:

- [ ] **Language tag**: change ` ```typescript ` to ` ```python ` (or whatever the target is)
- [ ] **Syntax**: full idiomatic rewrite, not mechanical transpilation. A TypeScript arrow function doesn't become `lambda` in Python — it becomes a `def` with proper naming
- [ ] **Standard library usage**: map to the target's stdlib equivalents (e.g., `Array.map()` → list comprehension, `fs.readFile` → `pathlib.Path.read_text()`)
- [ ] **Third-party imports**: map to ecosystem equivalents using `references/ecosystem-map.md`. If no equivalent exists, flag it
- [ ] **Error handling**: translate to the target's idiomatic pattern. Don't just swap `try/catch` for `try/except` — if translating to Rust, restructure around `Result<T, E>` and `?`
- [ ] **Type annotations**: translate type syntax. If the target has optional typing (Python), keep annotations as the skill's examples should model best practices

### Shallow vs Deep — Code Example

**Source (TypeScript):**
```typescript
const results = await Promise.all(
  items.map(item => fetchData(item.id))
);
const filtered = results.filter(r => r.status === 'ok');
```

**Shallow translation to Python** (mechanical — avoid this):
```python
results = await asyncio.gather(
    *[fetch_data(item.id) for item in items]
)
filtered = [r for r in results if r.status == "ok"]
```

**Deep translation to Python** (idiomatic):
```python
async with asyncio.TaskGroup() as tg:
    tasks = [tg.create_task(fetch_data(item.id)) for item in items]
results = [t.result() for t in tasks]
filtered = [r for r in results if r.status == "ok"]
```

**Deep translation to Rust** (pattern shift):
```rust
let results: Vec<_> = futures::future::join_all(
    items.iter().map(|item| fetch_data(item.id))
).await;
let filtered: Vec<_> = results.into_iter()
    .filter(|r| r.status == Status::Ok)
    .collect();
```

**Deep translation to Go** (architectural change — no async/await):
```go
var wg sync.WaitGroup
results := make([]Result, len(items))
for i, item := range items {
    wg.Add(1)
    go func(i int, id string) {
        defer wg.Done()
        results[i] = fetchData(id)
    }(i, item.ID)
}
wg.Wait()
var filtered []Result
for _, r := range results {
    if r.Status == "ok" {
        filtered = append(filtered, r)
    }
}
```

## 3. Inline Code References

- [ ] **File extensions**: `.ts` → `.py`, `.rs`, `.go`, `.rb`, `.dart`
- [ ] **File paths**: `src/components/Button.tsx` → `lib/widgets/button.dart` (Flutter) or `src/button.rs`
- [ ] **CLI commands**: `npm install` → `cargo add`, `npx jest` → `cargo test`, etc.
- [ ] **Config file names**: `tsconfig.json` → `Cargo.toml`, `pyproject.toml`, etc.
- [ ] **Function/method signatures**: translate naming conventions (camelCase → snake_case for Python/Rust, PascalCase for Go exports)

## 4. Naming Conventions

| Convention | TypeScript | Python | Rust | Go | Ruby | Dart |
|---|---|---|---|---|---|---|
| Functions | camelCase | snake_case | snake_case | PascalCase (exported) | snake_case | camelCase |
| Variables | camelCase | snake_case | snake_case | camelCase | snake_case | camelCase |
| Constants | UPPER_SNAKE | UPPER_SNAKE | UPPER_SNAKE | PascalCase | UPPER_SNAKE | lowerCamelCase |
| Classes/Types | PascalCase | PascalCase | PascalCase | PascalCase | PascalCase | PascalCase |
| Files | kebab-case or camelCase | snake_case | snake_case | snake_case | snake_case | snake_case |
| Packages | kebab-case | snake_case | snake_case | lowercase | snake_case | snake_case |

## 5. Project Structure

- [ ] **Directory layout**: translate to the target's conventions. A `src/components/` React tree doesn't become `src/components/` in Go — it becomes `internal/` or `pkg/`
- [ ] **Module system**: ES modules → Python packages, Rust modules, Go packages, Ruby requires, Dart imports
- [ ] **Config files**: translate or replace all config file references

## 6. Tooling Commands

- [ ] **Build**: `npm run build` → `cargo build`, `go build`, `flutter build`, etc.
- [ ] **Test**: `npm test` → `cargo test`, `pytest`, `go test ./...`, `flutter test`
- [ ] **Lint**: `npx eslint` → `cargo clippy`, `ruff check`, `golangci-lint run`, `dart analyze`
- [ ] **Format**: `npx prettier` → `cargo fmt`, `ruff format`, `gofmt`, `dart format`
- [ ] **Run/dev**: `npm run dev` → `cargo run`, `flask run`, `go run .`, `flutter run`

## 7. Framework-Specific Patterns

These require architectural adaptation, not just syntax changes:

- [ ] **React hooks** → equivalent state management (Riverpod in Flutter, closures in Rust, etc.)
- [ ] **Express middleware** → Axum extractors/layers, Gin middleware, Rack middleware, shelf middleware
- [ ] **Django ORM queries** → ActiveRecord, SQLAlchemy, Diesel, GORM equivalents
- [ ] **Dependency injection** → constructor injection, trait objects, interface satisfaction, etc.

When no clean equivalent exists, **flag it** with a comment in the translated skill explaining the gap and the recommended alternative pattern.

## 8. Bundled Resources

For skills with `scripts/`, `references/`, or `assets/` directories:

- [ ] **Language-agnostic files** (markdown docs, templates, config schemas): copy as-is
- [ ] **Scripts in the source language**: translate fully or flag for manual rewrite if complex
- [ ] **Assets**: copy as-is (images, fonts, etc. don't change)
