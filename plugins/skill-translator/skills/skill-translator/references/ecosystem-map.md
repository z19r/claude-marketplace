# Ecosystem Equivalence Map

Lookup tables for translating between language ecosystems. If the target language isn't listed here, use your own knowledge — these tables accelerate common cases, they don't limit what you can translate.

## Package Managers & Dependency Files

| Concept | TypeScript | Python | Rust | Go | Ruby | Dart/Flutter |
|---|---|---|---|---|---|---|
| Package manager | npm / pnpm / yarn | pip / uv / poetry | cargo | go mod | gem / bundler | pub |
| Dependency file | package.json | pyproject.toml / requirements.txt | Cargo.toml | go.mod | Gemfile | pubspec.yaml |
| Lock file | package-lock.json / pnpm-lock.yaml | uv.lock / poetry.lock | Cargo.lock | go.sum | Gemfile.lock | pubspec.lock |
| Install command | npm install | pip install / uv sync | cargo build | go mod download | bundle install | dart pub get / flutter pub get |
| Add dependency | npm install pkg | uv add pkg / pip install pkg | cargo add pkg | go get pkg | gem install pkg | dart pub add pkg |
| Registry | npmjs.com | pypi.org | crates.io | pkg.go.dev | rubygems.org | pub.dev |

## Test Frameworks & Runners

| Concept | TypeScript | Python | Rust | Go | Ruby | Dart/Flutter |
|---|---|---|---|---|---|---|
| Built-in test | — | unittest | cargo test | go test | minitest | dart test |
| Popular framework | jest / vitest | pytest | cargo test (built-in) | go test + testify | rspec | flutter_test |
| Run tests | npx jest / npx vitest | pytest | cargo test | go test ./... | bundle exec rspec | dart test / flutter test |
| Run single test | npx jest path | pytest path::test | cargo test test_name | go test -run TestName | rspec path:line | dart test path |
| Test file convention | `*.test.ts` / `*.spec.ts` | `test_*.py` / `*_test.py` | `#[cfg(test)] mod tests` in same file | `*_test.go` in same package | `*_spec.rb` in spec/ | `*_test.dart` in test/ |
| Assertion style | expect(x).toBe(y) | assert x == y | assert_eq!(x, y) | assert.Equal(t, x, y) | expect(x).to eq(y) | expect(x, equals(y)) |
| Mocking | jest.mock() / vi.mock() | unittest.mock / pytest-mock | mockall crate | testify/mock / gomock | rspec-mocks / double | mockito package |

## Linters & Formatters

| Concept | TypeScript | Python | Rust | Go | Ruby | Dart/Flutter |
|---|---|---|---|---|---|---|
| Linter | eslint / biome | ruff / pylint / flake8 | clippy | golangci-lint / go vet | rubocop | dart analyze |
| Formatter | prettier / biome | ruff format / black | rustfmt | gofmt / goimports | rubocop -a | dart format |
| Lint command | npx eslint . | ruff check . | cargo clippy | golangci-lint run | rubocop | dart analyze |
| Format command | npx prettier --write . | ruff format . | cargo fmt | gofmt -w . | rubocop -a | dart format . |
| Config file | .eslintrc / biome.json | pyproject.toml / ruff.toml | clippy.toml | .golangci.yml | .rubocop.yml | analysis_options.yaml |

## Build & Project Structure

| Concept | TypeScript | Python | Rust | Go | Ruby | Dart/Flutter |
|---|---|---|---|---|---|---|
| Build command | tsc / vite build / next build | python -m build | cargo build | go build | rake build | dart compile / flutter build |
| Dev server | vite dev / next dev | uvicorn / flask run | cargo run | go run . | rails s / puma | flutter run |
| Source dir | src/ | src/ or package_name/ | src/ | internal/ + cmd/ | lib/ | lib/ |
| Entry point | index.ts / main.ts | __main__.py / app.py | main.rs / lib.rs | main.go | app.rb / config.ru | main.dart |
| Config file | tsconfig.json | pyproject.toml | Cargo.toml | go.mod | Rakefile / Gemfile | pubspec.yaml |
| Compiled output | dist/ / .next/ | dist/ (wheels) | target/ | binary in project root | pkg/ | build/ |

## Error Handling Idioms

| Pattern | TypeScript | Python | Rust | Go | Ruby | Dart/Flutter |
|---|---|---|---|---|---|---|
| Exception-based | try/catch/finally | try/except/finally | — | — | begin/rescue/ensure | try/catch/finally |
| Result type | — (use libraries) | — (use libraries) | Result<T, E> | val, err := fn() | — | — (use dartz/fpdart) |
| Idiomatic style | try/catch or .catch() | try/except | Result + ? operator | if err != nil { return err } | begin/rescue | try/catch or Future.catchError |
| Custom errors | extends Error | extends Exception | enum + thiserror | errors.New / fmt.Errorf | StandardError subclass | extends Exception |
| Panic/abort | throw | raise | panic!() | panic() | raise | throw |

## Async & Concurrency

| Pattern | TypeScript | Python | Rust | Go | Ruby | Dart/Flutter |
|---|---|---|---|---|---|---|
| Async function | async/await | async/await (asyncio) | async/await (tokio/async-std) | goroutines + channels | async (fibers, ractors) | async/await |
| Concurrency model | event loop | event loop (asyncio) | tasks (tokio::spawn) | goroutines (CSP) | threads / fibers | event loop (isolates) |
| Parallel execution | Promise.all() | asyncio.gather() | tokio::join! / JoinSet | go func() + sync.WaitGroup | Thread.new / Parallel gem | Future.wait() / Isolate |
| HTTP client | fetch / axios | httpx / requests | reqwest | net/http | net/http / faraday | http package / dio |
| Runtime | Node.js / Bun / Deno | CPython | tokio / async-std | built-in | CRuby (MRI) | Dart VM |

## Web Frameworks

| Tier | TypeScript | Python | Rust | Go | Ruby | Dart/Flutter |
|---|---|---|---|---|---|---|
| Full-stack | Next.js / Nuxt | Django | — | — | Rails | Flutter (web) |
| API/micro | Express / Fastify / Hono | FastAPI / Flask | Axum / Actix-web | net/http / Gin / Echo | Sinatra / Roda | shelf / dart_frog |
| ORM/DB | Prisma / Drizzle / TypeORM | SQLAlchemy / Django ORM | Diesel / SeaORM | sqlx / GORM | ActiveRecord / Sequel | drift / floor |
| Template | JSX / EJS | Jinja2 / Django templates | Askama / Tera | html/template | ERB / Haml / Slim | — (widget tree) |

## CLI Frameworks

| Concept | TypeScript | Python | Rust | Go | Ruby | Dart/Flutter |
|---|---|---|---|---|---|---|
| Arg parsing | commander / yargs | argparse / click / typer | clap | cobra / flag | optparse / thor | args package |
| TUI | ink | rich / textual | ratatui | bubbletea / tview | tty-* gems | — |
| Colors/styling | chalk | rich / colorama | colored / owo-colors | lipgloss / color | colorize | ansicolor |

## Type System Patterns

| Pattern | TypeScript | Python | Rust | Go | Ruby | Dart/Flutter |
|---|---|---|---|---|---|---|
| Static types | yes (structural) | optional (type hints) | yes (algebraic) | yes (structural) | optional (Sorbet/RBS) | yes (sound null safety) |
| Generics | `<T>` | `[T]` (3.12+) / TypeVar | `<T>` | `[T]` (1.18+) | Sorbet generics | `<T>` |
| Null safety | strict null checks | Optional[T] | Option<T> | pointers can be nil | nil (duck typed) | ? suffix (sound null safety) |
| Union types | `A \| B` | `A \| B` (3.10+) / Union | enum variants | interfaces | duck typing | sealed classes |
| Interfaces | interface / type | Protocol / ABC | trait | interface | duck typing / modules | abstract class |
| Enums | enum (limited) | Enum class | enum (algebraic) | iota constants | — (symbols/constants) | enum |
