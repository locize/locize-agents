# Locize translation conventions

This project's translations live in [Locize](https://www.locize.com), reachable via the
Locize MCP server (`https://mcp.locize.app`). When you translate, review, or touch
user-facing strings, use the Locize **context tools** so your output matches the
project's terminology, voice, and prior decisions. All are read-only (`read` scope).

## Before translating or reviewing a string

1. **Terminology — `get_glossary`.** Call `get_glossary(projectId, languages: "<source>,<target>")`.
   For each concept you get per language: `preferred` (the single term to use), `allowed`
   (acceptable variants), and `forbidden` (never use). Emit the `preferred` target term;
   never use a `forbidden` term.
2. **Voice — `get_styleguide`.** Call `get_styleguide(projectId, languages: "<target>")`
   and follow its `tone`, `formality`, `targetAudience`, and usage/localization rules.
   Use `guides.<target>` if present, otherwise `guides.__all`.
3. **Reuse — `search_translation_memory`.** Call
   `search_translation_memory(projectId, source: "<string>", sourceLanguage: "<source>", targetLanguages: "<target>")`.
   If a match has a high `score` (≈1 is exact), reuse its `target` instead of inventing a
   new translation.
4. **Visual context — `get_screenshot_context`.** When a string is ambiguous (e.g. a bare
   "Open"), call `get_screenshot_context(projectId, namespace, key)` to see where it
   appears and how much space it has before deciding the translation.

## Reviewing a pull request for terminology drift (no translation needed)

Call `get_glossary(projectId, languages: "<source>")` and, for every new or changed
**source** string in the diff, flag any that contains a `forbidden` term. Suggest the
language's `preferred` term as the fix. This is the fastest way to keep terminology
consistent — do it on PRs even when no translation is involved.

## Rules

- Use `preferred` terms; treat `forbidden` terms as never-allowed.
- Matching glossary terms against text is your job: terms are returned verbatim (case as
  stored). Match case-insensitively for lowercase terms; respect case for proper nouns.
- Don't guess terminology or tone — fetch it. If a project has no glossary/style guide,
  the tool returns an empty result; fall back to sensible defaults and say so.
- These tools are read-only. To push new keys or updates, use `report_missing_keys` /
  `update_translations` (which need `write` scope).
