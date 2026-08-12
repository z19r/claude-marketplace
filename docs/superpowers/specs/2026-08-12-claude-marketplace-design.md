# Claude Marketplace — Design Spec

## Goal

A public marketplace for custom Claude Code plugins, hosted as a Hugo static site on Netlify at `claude-marketplace.z19r.com`. Users add the marketplace URL to their Claude Code settings and install plugins natively via `/plugin install`. Zack is the sole publisher (for now).

## Architecture

Single Git repo (`z19r/claude-marketplace`) containing both the Hugo site and the plugin directories. Hugo generates the browsable website and the `marketplace.json` registry at build time. Plugin sources use `git-subdir` pointing back to the same repo.

### Repo Structure

```
claude-marketplace/
├── hugo.toml                         # Site config
├── netlify.toml                      # Build: hugo --minify
├── content/
│   ├── _index.md                     # Homepage intro / getting started
│   └── plugins/
│       ├── _index.md                 # Plugin listing page intro
│       ├── skill-translator.md       # Plugin content page
│       └── code-simplifier.md
├── layouts/
│   ├── _default/
│   │   ├── baseof.html               # Base template (head, nav, footer)
│   │   └── list.html                 # Generic list template
│   ├── plugins/
│   │   ├── list.html                 # Plugin grid listing
│   │   └── single.html              # Plugin detail page
│   ├── index.html                    # Homepage template
│   └── _default/
│       └── marketplace.json.json     # Output format template for registry
├── static/
│   └── css/
│       └── style.css                 # Site styles
├── archetypes/
│   └── plugins.md                    # Template for new plugin content pages
└── plugins/                          # Actual plugin directories
    ├── skill-translator/
    │   ├── .claude-plugin/plugin.json
    │   └── skills/skill-translator/...
    └── code-simplifier/
        └── ...
```

### Plugin Content Frontmatter

```yaml
---
title: "Skill Translator"
name: "skill-translator"
version: "1.0.0"
description: "Translate programming-language-specific skills to other languages"
author: "Zack Kitzmiller"
pluginPath: "plugins/skill-translator"
keywords: ["translation", "porting", "language"]
category: "development"
date: 2026-08-12
---

Full description and usage instructions here.
```

### Generated marketplace.json

```json
{
  "name": "z19r-marketplace",
  "description": "Custom Claude Code plugins by z19r",
  "owner": {
    "name": "Zack Kitzmiller",
    "url": "https://claude-marketplace.z19r.com"
  },
  "plugins": [
    {
      "name": "skill-translator",
      "description": "Translate programming-language-specific skills to other languages",
      "version": "1.0.0",
      "source": {
        "source": "git-subdir",
        "url": "https://github.com/z19r/claude-marketplace.git",
        "path": "plugins/skill-translator",
        "ref": "main"
      },
      "author": { "name": "Zack Kitzmiller" },
      "keywords": ["translation", "porting", "language"],
      "category": "development",
      "homepage": "https://claude-marketplace.z19r.com/plugins/skill-translator/"
    }
  ]
}
```

### User Install Flow

1. Add marketplace (one time):
   ```
   /plugin marketplace add https://claude-marketplace.z19r.com/marketplace.json
   ```

2. Install a plugin:
   ```
   /plugin install skill-translator@z19r-marketplace
   ```

### Publisher Workflow (adding a new plugin)

1. Drop the plugin directory into `plugins/<name>/`
2. Create `content/plugins/<name>.md` with frontmatter (use archetype: `hugo new plugins/<name>.md`)
3. `git push` to main
4. Netlify builds and deploys — site and registry auto-update

## Website Pages

### Homepage (`/`)
- Brief intro: what this is, how to add it to Claude Code
- One-liner install command (copy-able)
- Link to plugin listing

### Plugin Listing (`/plugins/`)
- Grid of plugin cards
- Each card: name, description, version, category
- Cards link to detail pages

### Plugin Detail (`/plugins/<name>/`)
- Full description (from markdown body)
- Install command: `/plugin install <name>@z19r-marketplace`
- Version, author, keywords, category
- Link to source (GitHub repo path)

## Design

- Clean, minimal, dark-friendly
- No JS frameworks — Hugo templates + CSS
- Responsive grid for plugin cards
- Monospace accents for code/commands
- Light and dark theme support via `prefers-color-scheme`

## Tech Stack

- Hugo (static site generator)
- Netlify (hosting + CI/CD)
- Custom domain: `claude-marketplace.z19r.com`
- GitHub: `z19r/claude-marketplace`

## Out of Scope (for now)

- Multi-publisher support / auth
- Search / filtering (add later when plugin count warrants it)
- Download counts / analytics
- Plugin ratings / reviews
- Automated plugin validation in CI
