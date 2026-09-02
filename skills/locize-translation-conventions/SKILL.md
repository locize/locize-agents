---
name: locize-translation-conventions
description: "Translate, review and lint user-facing strings to a project's own terminology, tone and prior decisions using the Locize MCP context tools (glossary, style guide, translation memory, screenshot context). Use when the user asks to translate strings or keys, review or proofread a translation, check terminology or glossary compliance, keep translations consistent, apply the style guide, reuse existing translations, or lint a pull request for forbidden terms, in a project whose translations live in Locize. Not for setting i18n up from scratch; that is the i18next-localization skill."
---

# Locize translation conventions

This project's translations live in [Locize](https://www.locize.com), reachable via the
Locize MCP server (`https://mcp.locize.app`). When you translate, review, or touch
user-facing strings, use the Locize **context tools** so your output matches the
project's terminology, voice, and prior decisions. All are read-only (`read` scope).

## Before translating or reviewing a string

1. **Terminology: `get_glossary`.** Call `get_glossary(projectId, languages: "<source>,<target>")`.
   For each concept you get per language: `preferred` (the single term to use), `allowed`
   (acceptable variants), and `forbidden` (never use). Emit the `preferred` target term;
   never use a `forbidden` term.
2. **Voice: `get_styleguide`.** Call `get_styleguide(projectId, languages: "<target>")`
   and follow its `tone`, `formality`, `targetAudience`, and usage/localization rules.
   Use `guides.<target>` if present, otherwise `guides.__all`.
3. **Reuse: `search_translation_memory`.** Call
   `search_translation_memory(projectId, source: "<string>", sourceLanguage: "<source>", targetLanguages: "<target>")`.
   If a match has a high `score` (about 1 is exact), reuse its `target` instead of inventing a
   new translation.
4. **Visual context: `get_screenshot_context`.** When a string is ambiguous (for example a bare
   "Open"), call `get_screenshot_context(projectId, namespace, key)` to see where it
   appears and how much space it has before deciding the translation.

## Reviewing a pull request for terminology drift (no translation needed)

Call `get_glossary(projectId, languages: "<source>")` and, for every new or changed
**source** string in the diff, flag any that contains a `forbidden` term. Suggest the
language's `preferred` term as the fix. This is the fastest way to keep terminology
consistent; do it on PRs even when no translation is involved.

## Setting i18n up from scratch

If the app has hardcoded strings and no i18next setup yet, this is the wrong skill: use the
`i18next-localization` skill (installed with this plugin), or run
`npx i18next-cli localize --print-agent-prompt` and follow the printed steps.

## Rules

- Use `preferred` terms; treat `forbidden` terms as never-allowed.
- Matching glossary terms against text is your job: terms are returned verbatim (case as
  stored). Match case-insensitively for lowercase terms; respect case for proper nouns.
- Don't guess terminology or tone; fetch it. If a project has no glossary or style guide,
  the tool returns an empty result; fall back to sensible defaults and say so.
- These tools are read-only. To push new keys or updates, use `report_missing_keys` /
  `update_translations` (which need `write` scope).
