# claude-marketplace — Hugo-generated Claude plugin marketplace

# List available recipes
default:
    @just --list

# Serve the site locally with live reload (drafts included)
dev:
    hugo server -D

# Build the site (writes public/, including marketplace.json)
build:
    hugo --minify

# Regenerate root marketplace.json from content (mirrors CI)
marketplace: build
    cp public/marketplace.json marketplace.json

# Validate that the generated marketplace.json is valid JSON
lint: build
    jq empty public/marketplace.json

# Remove generated output
clean:
    rm -rf public resources .hugo_build.lock

# Bump a plugin's version, e.g. `just bump code-simplifier 1.1.0`
bump plugin version:
    @test -f content/plugins/{{plugin}}.md \
        || { echo "no such plugin: {{plugin}}" >&2; exit 1; }
    sed -i 's/^version: .*/version: "{{version}}"/' \
        content/plugins/{{plugin}}.md
    @echo "{{plugin}} -> {{version}} (commit to main; CI regenerates marketplace.json)"
