# Claude Marketplace Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a public Hugo-based plugin marketplace at `claude-marketplace.z19r.com` that serves both a browsable website and a `marketplace.json` registry for Claude Code plugin installation.

**Architecture:** Single repo with Hugo site + plugin directories. Hugo generates the website and marketplace.json at build time. Plugins use `git-subdir` sources pointing back to the same repo. Deployed via Netlify.

**Tech Stack:** Hugo, Netlify, CSS (no JS frameworks), Git

## Global Constraints

- Domain: `claude-marketplace.z19r.com`
- GitHub repo: `z19r/claude-marketplace`
- Marketplace name: `z19r-marketplace`
- Hugo config format: `hugo.toml`
- No JavaScript frameworks — pure Hugo templates + CSS
- Light and dark theme support via `prefers-color-scheme`
- Never mention Claude, Anthropic, or AI in commit messages or git metadata

---

### Task 1: Hugo Project Scaffold

**Files:**
- Create: `hugo.toml`
- Create: `netlify.toml`
- Create: `archetypes/plugins.md`
- Create: `.gitignore`

**Interfaces:**
- Produces: Hugo project root that all subsequent tasks build on
- Produces: `archetypes/plugins.md` template used by publisher workflow

- [ ] **Step 1: Create `hugo.toml`**

```toml
baseURL = "https://claude-marketplace.z19r.com/"
languageCode = "en-us"
title = "z19r Marketplace"

[outputs]
  home = ["HTML", "JSON"]

[outputFormats.JSON]
  baseName = "marketplace"
  mediaType = "application/json"
  isPlainText = true

[params]
  description = "Custom Claude Code plugins by z19r"
  marketplaceName = "z19r-marketplace"
  githubRepo = "z19r/claude-marketplace"
  ownerName = "Zack Kitzmiller"
  ownerURL = "https://claude-marketplace.z19r.com"
```

- [ ] **Step 2: Create `netlify.toml`**

```toml
[build]
  command = "hugo --minify"
  publish = "public"

[build.environment]
  HUGO_VERSION = "0.147.6"

[[headers]]
  for = "/marketplace.json"
  [headers.values]
    Content-Type = "application/json"
    Access-Control-Allow-Origin = "*"
```

- [ ] **Step 3: Create `archetypes/plugins.md`**

```markdown
---
title: "{{ replace .Name "-" " " | title }}"
name: "{{ .Name }}"
version: "0.1.0"
description: ""
author: "Zack Kitzmiller"
pluginPath: "plugins/{{ .Name }}"
keywords: []
category: "development"
date: {{ .Date }}
draft: false
---

Description and usage instructions.
```

- [ ] **Step 4: Create `.gitignore`**

```
public/
resources/
.hugo_build.lock
```

- [ ] **Step 5: Verify Hugo builds with no errors**

Run: `hugo --minify` from the project root.
Expected: Build succeeds (may warn about missing layouts — that's fine, Task 2 adds them).

---

### Task 2: Base Layout and Styles

**Files:**
- Create: `layouts/_default/baseof.html`
- Create: `layouts/index.html`
- Create: `content/_index.md`
- Create: `static/css/style.css`

**Interfaces:**
- Consumes: `hugo.toml` params (title, description, ownerName)
- Produces: Base HTML shell and homepage that Task 3 and Task 4 extend

- [ ] **Step 1: Create `layouts/_default/baseof.html`**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{ block "title" . }}{{ .Site.Title }}{{ end }}</title>
  <meta name="description" content="{{ .Site.Params.description }}">
  <link rel="stylesheet" href="/css/style.css">
</head>
<body>
  <header>
    <nav>
      <a href="/" class="site-title">{{ .Site.Title }}</a>
      <a href="/plugins/">Plugins</a>
    </nav>
  </header>
  <main>
    {{ block "main" . }}{{ end }}
  </main>
  <footer>
    <p>&copy; {{ now.Year }} {{ .Site.Params.ownerName }}</p>
  </footer>
</body>
</html>
```

- [ ] **Step 2: Create `static/css/style.css`**

```css
:root {
  --bg: #fafafa;
  --bg-card: #ffffff;
  --text: #1a1a1a;
  --text-muted: #666666;
  --border: #e0e0e0;
  --accent: #2563eb;
  --accent-hover: #1d4ed8;
  --code-bg: #f3f4f6;
  --radius: 8px;
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --bg: #0f0f0f;
    --bg-card: #1a1a1a;
    --text: #e5e5e5;
    --text-muted: #999999;
    --border: #2a2a2a;
    --accent: #60a5fa;
    --accent-hover: #93bbfd;
    --code-bg: #1e1e1e;
  }
}

:root[data-theme="dark"] {
  --bg: #0f0f0f;
  --bg-card: #1a1a1a;
  --text: #e5e5e5;
  --text-muted: #999999;
  --border: #2a2a2a;
  --accent: #60a5fa;
  --accent-hover: #93bbfd;
  --code-bg: #1e1e1e;
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  background: var(--bg);
  color: var(--text);
  line-height: 1.6;
}

header {
  border-bottom: 1px solid var(--border);
  padding: 1rem 2rem;
}

nav {
  max-width: 960px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 2rem;
}

nav a {
  color: var(--text);
  text-decoration: none;
}

nav a:hover { color: var(--accent); }

.site-title {
  font-weight: 700;
  font-size: 1.1rem;
}

main {
  max-width: 960px;
  margin: 0 auto;
  padding: 2rem;
}

footer {
  border-top: 1px solid var(--border);
  padding: 1.5rem 2rem;
  text-align: center;
  color: var(--text-muted);
  font-size: 0.85rem;
}

h1 { font-size: 2rem; margin-bottom: 0.5rem; }
h2 { font-size: 1.4rem; margin-bottom: 0.5rem; }

code {
  font-family: "SF Mono", "Fira Code", "Cascadia Code", monospace;
  background: var(--code-bg);
  padding: 0.15em 0.4em;
  border-radius: 4px;
  font-size: 0.9em;
}

pre {
  background: var(--code-bg);
  padding: 1rem;
  border-radius: var(--radius);
  overflow-x: auto;
  margin: 1rem 0;
}

pre code {
  background: none;
  padding: 0;
}

.hero {
  text-align: center;
  padding: 3rem 0;
}

.hero p {
  color: var(--text-muted);
  font-size: 1.1rem;
  margin-bottom: 1.5rem;
}

.install-command {
  display: inline-block;
  background: var(--code-bg);
  border: 1px solid var(--border);
  padding: 0.75rem 1.5rem;
  border-radius: var(--radius);
  font-family: "SF Mono", "Fira Code", monospace;
  font-size: 0.95rem;
  margin-bottom: 2rem;
}

.plugin-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.25rem;
  margin-top: 1.5rem;
}

.plugin-card {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 1.25rem;
  text-decoration: none;
  color: var(--text);
  transition: border-color 0.15s;
}

.plugin-card:hover {
  border-color: var(--accent);
}

.plugin-card h3 {
  font-size: 1.1rem;
  margin-bottom: 0.4rem;
}

.plugin-card p {
  color: var(--text-muted);
  font-size: 0.9rem;
  margin-bottom: 0.75rem;
}

.plugin-meta {
  display: flex;
  gap: 0.75rem;
  font-size: 0.8rem;
  color: var(--text-muted);
}

.plugin-meta span {
  background: var(--code-bg);
  padding: 0.15em 0.5em;
  border-radius: 4px;
}

.plugin-detail { padding-top: 1rem; }

.plugin-detail .install-box {
  background: var(--code-bg);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 1rem 1.25rem;
  margin: 1.5rem 0;
}

.plugin-detail .install-box code {
  background: none;
  font-size: 0.95rem;
}

.plugin-detail .meta-table {
  margin: 1.5rem 0;
}

.plugin-detail .meta-table dt {
  font-weight: 600;
  font-size: 0.85rem;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.03em;
  margin-top: 0.75rem;
}

.plugin-detail .meta-table dd {
  margin-left: 0;
}

.keywords {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
  list-style: none;
}

.keywords li {
  background: var(--code-bg);
  padding: 0.15em 0.5em;
  border-radius: 4px;
  font-size: 0.85rem;
  color: var(--text-muted);
}

.content-body { margin-top: 1.5rem; }
.content-body p { margin-bottom: 1rem; }
```

- [ ] **Step 3: Create `content/_index.md`**

```markdown
---
title: "z19r Marketplace"
---
```

- [ ] **Step 4: Create `layouts/index.html`**

```html
{{ define "title" }}{{ .Site.Title }}{{ end }}
{{ define "main" }}
<div class="hero">
  <h1>{{ .Site.Title }}</h1>
  <p>{{ .Site.Params.description }}</p>
  <div class="install-command">/plugin marketplace add https://claude-marketplace.z19r.com/marketplace.json</div>
</div>

<h2>Plugins</h2>
<div class="plugin-grid">
  {{ range where .Site.RegularPages "Section" "plugins" }}
  <a href="{{ .RelPermalink }}" class="plugin-card">
    <h3>{{ .Params.name }}</h3>
    <p>{{ .Params.description }}</p>
    <div class="plugin-meta">
      <span>v{{ .Params.version }}</span>
      <span>{{ .Params.category }}</span>
    </div>
  </a>
  {{ end }}
</div>
{{ end }}
```

- [ ] **Step 5: Build and verify the homepage renders**

Run: `hugo server -D`
Expected: Site serves at localhost:1313 with the hero section and empty plugin grid.

---

### Task 3: Plugin Listing and Detail Pages

**Files:**
- Create: `layouts/plugins/list.html`
- Create: `layouts/plugins/single.html`
- Create: `content/plugins/_index.md`

**Interfaces:**
- Consumes: `baseof.html` base template, `style.css` classes (`.plugin-grid`, `.plugin-card`, `.plugin-detail`)
- Consumes: Plugin content page frontmatter (`name`, `version`, `description`, `author`, `keywords`, `category`, `pluginPath`)
- Produces: Browsable plugin listing at `/plugins/` and detail pages at `/plugins/<name>/`

- [ ] **Step 1: Create `content/plugins/_index.md`**

```markdown
---
title: "Plugins"
---
```

- [ ] **Step 2: Create `layouts/plugins/list.html`**

```html
{{ define "title" }}Plugins — {{ .Site.Title }}{{ end }}
{{ define "main" }}
<h1>Plugins</h1>
<p style="color: var(--text-muted); margin-bottom: 1rem;">
  {{ len .Pages }} plugin{{ if ne (len .Pages) 1 }}s{{ end }} available
</p>
<div class="plugin-grid">
  {{ range .Pages }}
  <a href="{{ .RelPermalink }}" class="plugin-card">
    <h3>{{ .Params.name }}</h3>
    <p>{{ .Params.description }}</p>
    <div class="plugin-meta">
      <span>v{{ .Params.version }}</span>
      <span>{{ .Params.category }}</span>
    </div>
  </a>
  {{ end }}
</div>
{{ end }}
```

- [ ] **Step 3: Create `layouts/plugins/single.html`**

```html
{{ define "title" }}{{ .Params.name }} — {{ .Site.Title }}{{ end }}
{{ define "main" }}
<div class="plugin-detail">
  <h1>{{ .Title }}</h1>
  <p style="color: var(--text-muted);">{{ .Params.description }}</p>

  <div class="install-box">
    <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 0.5rem;">Install this plugin:</p>
    <code>/plugin install {{ .Params.name }}@{{ .Site.Params.marketplaceName }}</code>
  </div>

  <dl class="meta-table">
    <dt>Version</dt>
    <dd>{{ .Params.version }}</dd>
    <dt>Author</dt>
    <dd>{{ .Params.author }}</dd>
    <dt>Category</dt>
    <dd>{{ .Params.category }}</dd>
    {{ with .Params.keywords }}
    <dt>Keywords</dt>
    <dd>
      <ul class="keywords">
        {{ range . }}<li>{{ . }}</li>{{ end }}
      </ul>
    </dd>
    {{ end }}
    <dt>Source</dt>
    <dd><a href="https://github.com/{{ $.Site.Params.githubRepo }}/tree/main/{{ .Params.pluginPath }}" style="color: var(--accent);">View on GitHub</a></dd>
  </dl>

  <div class="content-body">
    {{ .Content }}
  </div>
</div>
{{ end }}
```

- [ ] **Step 4: Verify with a test plugin page**

Create a temporary `content/plugins/test-plugin.md` with sample frontmatter, run `hugo server -D`, verify the listing and detail pages render correctly. Delete the test file afterward.

---

### Task 4: marketplace.json Generation

**Files:**
- Create: `layouts/_default/index.json.json`

**Interfaces:**
- Consumes: All pages in the `plugins` section, plus `hugo.toml` params (`marketplaceName`, `ownerName`, `ownerURL`, `githubRepo`)
- Produces: `/marketplace.json` — the registry file Claude Code fetches

- [ ] **Step 1: Create `layouts/_default/index.json.json`**

```
{{- $plugins := slice -}}
{{- range where .Site.RegularPages "Section" "plugins" -}}
{{- $plugin := dict
  "name" .Params.name
  "description" .Params.description
  "version" .Params.version
  "source" (dict
    "source" "git-subdir"
    "url" (printf "https://github.com/%s.git" $.Site.Params.githubRepo)
    "path" .Params.pluginPath
    "ref" "main"
  )
  "author" (dict "name" .Params.author)
  "keywords" .Params.keywords
  "category" .Params.category
  "homepage" (printf "%s%s" $.Site.BaseURL (strings.TrimPrefix "/" .RelPermalink))
-}}
{{- $plugins = $plugins | append $plugin -}}
{{- end -}}
{{- dict
  "name" .Site.Params.marketplaceName
  "description" .Site.Params.description
  "owner" (dict "name" .Site.Params.ownerName "url" .Site.Params.ownerURL)
  "plugins" $plugins
| jsonify (dict "indent" "  ") -}}
```

- [ ] **Step 2: Build and verify marketplace.json**

Run: `hugo --minify`
Then: `cat public/marketplace.json | python3 -m json.tool`
Expected: Valid JSON with the correct structure — `name`, `owner`, `plugins` array with `git-subdir` sources.

- [ ] **Step 3: Verify marketplace.json validates**

Check that each plugin entry has: `name`, `description`, `version`, `source` (with `source`, `url`, `path`, `ref` fields), `author`.

---

### Task 5: Seed Plugins and Content Pages

**Files:**
- Create: `content/plugins/skill-translator.md`
- Create: `content/plugins/code-simplifier.md`
- Copy: `plugins/skill-translator/` (from existing `skill-translator/`)
- Copy: `plugins/code-simplifier/` (from existing `skills/code-simplifier.md` — needs restructuring into plugin format)

**Interfaces:**
- Consumes: Plugin listing template, detail template, marketplace.json template
- Produces: Two real plugins in the marketplace, verifying the full pipeline

- [ ] **Step 1: Create `content/plugins/skill-translator.md`**

```markdown
---
title: "Skill Translator"
name: "skill-translator"
version: "1.0.0"
description: "Translate programming-language-specific skills to other languages with deep adaptation of code, tooling, and architectural patterns"
author: "Zack Kitzmiller"
pluginPath: "plugins/skill-translator"
keywords: ["translation", "porting", "language", "framework"]
category: "development"
date: 2026-08-12
draft: false
---

Translate a skill written for one programming language or framework into an idiomatic equivalent for a different target. Deep translation — adapts code examples, tooling, project structure, architectural patterns, and idioms, not just syntax swaps.

## Usage

Invoke when you want to port an existing skill to a new language:

- "Make a Python version of this TypeScript skill"
- "Port this to Rust"
- "I need this skill but for Go"
- "Convert this to Dart/Flutter"

The skill analyzes the source, classifies sections as language-agnostic vs language-specific, presents a translation summary, then translates section by section with full eval support.

## Supported Languages

Pre-built equivalence tables for TypeScript, Python, Rust, Go, Ruby, and Dart/Flutter. Works with any language — Claude translates using its own knowledge for languages not in the lookup tables.
```

- [ ] **Step 2: Create `content/plugins/code-simplifier.md`**

```markdown
---
title: "Code Simplifier"
name: "code-simplifier"
version: "1.0.0"
description: "Simplify and refine code for clarity, consistency, and maintainability while preserving all functionality"
author: "Zack Kitzmiller"
pluginPath: "plugins/code-simplifier"
keywords: ["refactoring", "simplification", "code-quality"]
category: "development"
date: 2026-08-12
draft: false
---

An expert code simplification specialist focused on enhancing code clarity, consistency, and maintainability while preserving exact functionality. Operates autonomously on recently modified code.

## What It Does

- Reduces unnecessary complexity and nesting
- Eliminates redundant code and abstractions
- Improves readability through clear naming
- Consolidates related logic
- Applies project-specific coding standards from CLAUDE.md
```

- [ ] **Step 3: Copy the skill-translator plugin directory**

```bash
cp -r skill-translator/ plugins/skill-translator/
```

Note: This copies from the existing skill-translator directory in the custom-skills repo into the marketplace repo's `plugins/` directory.

- [ ] **Step 4: Create code-simplifier as a proper plugin**

The existing `skills/code-simplifier.md` is a standalone skill file, not a plugin. Restructure it:

```bash
mkdir -p plugins/code-simplifier/.claude-plugin
mkdir -p plugins/code-simplifier/skills/code-simplifier
```

Create `plugins/code-simplifier/.claude-plugin/plugin.json`:
```json
{
  "name": "code-simplifier",
  "description": "Simplify and refine code for clarity, consistency, and maintainability while preserving all functionality.",
  "author": {
    "name": "Zack Kitzmiller",
    "email": "zackkitzmiller@gmail.com"
  }
}
```

Copy the existing skill file as the plugin's SKILL.md:
```bash
cp skills/code-simplifier.md plugins/code-simplifier/skills/code-simplifier/SKILL.md
```

- [ ] **Step 5: Full build and verify**

Run: `hugo --minify`
Verify:
1. `public/index.html` shows both plugins in the grid
2. `public/plugins/skill-translator/index.html` renders the detail page
3. `public/plugins/code-simplifier/index.html` renders the detail page
4. `public/marketplace.json` contains both plugins with correct sources

---

### Task 6: Netlify Deploy

**Files:**
- No new files — `netlify.toml` was created in Task 1

**Interfaces:**
- Consumes: Complete Hugo site from Tasks 1-5
- Produces: Live site at `claude-marketplace.z19r.com`

- [ ] **Step 1: Initialize git repo and push**

```bash
git init
git add .
git commit -m "Initial marketplace site"
git remote add origin git@github.com:z19r/claude-marketplace.git
git push -u origin main
```

Note: Create the `z19r/claude-marketplace` repo on GitHub first.

- [ ] **Step 2: Connect to Netlify**

1. Go to Netlify → New site → Import from Git → Select `z19r/claude-marketplace`
2. Build command: `hugo --minify` (already in netlify.toml)
3. Publish directory: `public` (already in netlify.toml)
4. Deploy

- [ ] **Step 3: Configure custom domain**

1. In Netlify site settings → Domain management → Add custom domain: `claude-marketplace.z19r.com`
2. Add CNAME record in DNS: `claude-marketplace.z19r.com` → Netlify's provided domain
3. Enable HTTPS (Netlify handles this automatically)

- [ ] **Step 4: Verify the live site**

1. Visit `https://claude-marketplace.z19r.com` — homepage loads
2. Visit `https://claude-marketplace.z19r.com/plugins/` — both plugins listed
3. Visit `https://claude-marketplace.z19r.com/marketplace.json` — valid JSON with correct `Content-Type: application/json` header
4. Test install flow:
   ```
   /plugin marketplace add https://claude-marketplace.z19r.com/marketplace.json
   /plugin install skill-translator@z19r-marketplace
   ```

---

## Execution

Plan complete and saved to `docs/superpowers/plans/2026-08-12-claude-marketplace.md`. Two execution options:

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?
