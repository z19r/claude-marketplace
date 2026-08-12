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
