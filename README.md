# Locize for AI agents

Conventions and setup for using [Locize](https://www.locize.com) from AI coding agents
(Claude Code, Cursor, VS Code, and any [MCP](https://modelcontextprotocol.io)-compatible
client) — so an agent translates, reviews, and lints terminology to your project's
standards, right in your editor.

This repo is the canonical home of the agent-convention snippets. Drop the one that
matches your tool into your project, or copy the shared rules into your existing
`CLAUDE.md` / `AGENTS.md` / `.cursorrules`.

- [`CLAUDE.md`](./CLAUDE.md) — for Claude Code
- [`AGENTS.md`](./AGENTS.md) — generic (Codex, and tools that read AGENTS.md)
- [`.cursorrules`](./.cursorrules) — for Cursor

They all carry the same rules; pick the file your tool reads.

## Connect the Locize MCP server

The conventions assume your agent can reach the Locize MCP server:

```bash
# Claude Code
claude mcp add --transport http locize https://mcp.locize.app
```

For Claude Desktop, Cursor, VS Code, and other clients, add `https://mcp.locize.app`
as a custom MCP connector and complete the OAuth flow, or use a
[Personal Access Token](https://www.locize.com/docs/integration/personal-access-tokens)
(`read` scope is enough for the context tools below). Full setup:
<https://www.locize.com/docs/integration/mcp>.

## The context tools these conventions use

All read-only, `read` scope:

| Tool | What it gives the agent |
|------|-------------------------|
| `get_glossary` | Approved & forbidden terms per language (`preferred` / `allowed` / `forbidden`) |
| `get_styleguide` | Tone, formality, audience, usage rules per language |
| `search_translation_memory` | Exact + fuzzy matches from prior translations |
| `get_screenshot_context` | The screenshot + region where a key appears |

## What the conventions tell the agent

- **Before translating or reviewing**, fetch context: use each glossary term's
  `preferred` value (never a `forbidden` one), apply the style guide's tone/formality,
  and reuse high-score translation-memory matches. Pull screenshot context when a string
  is ambiguous.
- **For pull-request terminology lint** (no translation needed): call
  `get_glossary(languages: "<source>")` and flag any new/changed source string that
  contains a `forbidden` term, suggesting the language's `preferred` term instead.
- Matching against source text is the agent's job — terms are returned verbatim (case as
  stored).

See [CLAUDE.md](./CLAUDE.md) for the full rule text.

## Localizing an app end-to-end

The conventions above assume an existing Locize project. To take an app from hardcoded
strings to fully localized (detect → instrument → extract → connect to Locize →
AI-translate → download), the canonical agent flow ships with
[i18next-cli](https://github.com/i18next/i18next-cli):

```bash
npx i18next-cli localize --print-agent-prompt
```

Paste the printed prompt into your agent, or let it run the command itself. The prompt is
version-matched to the installed CLI — regenerate it from the command rather than keeping
a copy in your conventions, so it never drifts from what the CLI actually does. (Without
an agent, `npx i18next-cli localize` runs the same flow as one interactive command.)

More: [launch post](https://www.locize.com/blog/i18next-cli-localize?from=locize-agents_readme__localize)
· [CLI docs](https://www.locize.com/docs/integration/cli?from=locize-agents_readme__localize).
