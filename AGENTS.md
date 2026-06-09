# Locize translation conventions

This project's translations live in [Locize](https://www.locize.com), reachable via the
Locize MCP server (`https://mcp.locize.app`). When translating, reviewing, or editing
user-facing strings, use the Locize **context tools** (read-only, `read` scope) so output
matches the project's terminology, voice, and prior decisions.

## Before translating or reviewing a string

1. **`get_glossary(projectId, languages: "<source>,<target>")`** — per concept, per
   language: `preferred` (use this), `allowed` (acceptable), `forbidden` (never use).
   Emit the `preferred` target term; never a `forbidden` one.
2. **`get_styleguide(projectId, languages: "<target>")`** — follow `tone`, `formality`,
   `targetAudience`, usage/localization rules. Use `guides.<target>` if present, else
   `guides.__all`.
3. **`search_translation_memory(projectId, source, sourceLanguage, targetLanguages)`** —
   reuse a high-`score` `target` (≈1 is exact) instead of writing a new translation.
4. **`get_screenshot_context(projectId, namespace, key)`** — when a string is ambiguous,
   look at where it appears and the space available before deciding.

## Reviewing a PR for terminology drift (no translation needed)

Call `get_glossary(projectId, languages: "<source>")` and flag any new/changed **source**
string that contains a `forbidden` term; suggest the `preferred` term as the fix.

## Rules

- Use `preferred` terms; treat `forbidden` terms as never-allowed.
- Matching terms against text is your job: terms are verbatim (case as stored). Match
  case-insensitively for lowercase terms; respect case for proper nouns.
- Don't guess terminology or tone — fetch it. Empty result = no glossary/style guide
  configured; fall back to sensible defaults and say so.
- These tools are read-only; pushing keys/updates uses `report_missing_keys` /
  `update_translations` (`write` scope).
