# Maintaining this repo

## `locize-translation-conventions` has a copy on the MCP server

The Locize MCP server serves the same skill over MCP (`locize-mcp-server/skills/locize-translation-conventions/SKILL.md`), so a client without this plugin gets it too. A change to the skill here goes there as well; the server's copy differs in one line only (it says to use the `i18next-localization` skill "if it is installed"). `CONVENTIONS.md` carries the same rules in shorter words (Gemini loads it, and users copy it into their own files), so a rule change goes there too.

## Refresh the vendored `i18next-localization` skill

The skill's source of truth is [i18next/i18next-cli](https://github.com/i18next/i18next-cli/tree/main/skills/i18next-localization), where its drift-guard tests live. After a skill change there, run this from the repo root, then raise `version` in every manifest (`.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` twice, `plugin.json`, `gemini-extension.json`):

```bash
BASE=https://raw.githubusercontent.com/i18next/i18next-cli/main/skills/i18next-localization
DEST=skills/i18next-localization
curl -fsSL "$BASE/SKILL.md" | sed -e 's/from=i18next_cli__skill/from=locize_plugin__skill/' -e '/^allowed-tools:/d' > "$DEST/SKILL.md"
curl -fsSL "$BASE/references/stacks.md" > "$DEST/references/stacks.md"
curl -fsSL "$BASE/references/icu-mf2.md" > "$DEST/references/icu-mf2.md"
grep -n allowed-tools "$DEST/SKILL.md"   # must print nothing
claude plugin validate .
```

Two edits, nothing else:

- The attribution tag becomes `locize_plugin__skill`, so sign-ups through this plugin are counted apart from the upstream skill.
- The `allowed-tools` line goes. The Claude plugin directory accepts pre-approved tools beyond Read, Grep, Glob and LS only from Verified organizations, so Claude Code asks before each `npx i18next-cli` run unless the user has allowed it.

## Files the Claude plugin directory accepts

The whole repo is the plugin, so every file in it ships with the plugin. From an organization that isn't Verified, the directory refuses the version if any file breaks these rules:

- Only Markdown, text, JSON, YAML and PNG, JPEG, GIF, WebP or ICO images, each with its extension; `LICENSE`, a README, `.gitignore` and the plugin icon are the exceptions. 1.0.2 was refused with `.cursorrules` as the only file without one.
- No scripts or other programs, and nothing that starts with `#!`.
- No `package.json`, lockfile, `.npmrc` or other package-manager configuration.
- In `.claude-plugin/`, only `plugin.json` and `marketplace.json`.
- No `CLAUDE.md`, `CLAUDE.local.md` or `AGENTS.md`, in any case and in any folder. 1.0.8 passed with `CLAUDE.md` and `AGENTS.md` on 2026-11-23 and was refused for them on 11-27, so the copy-in template is `CONVENTIONS.md`.

## Pushing during a review

Every push is checked again, with or without a version bump, and the result replaces the one under review: a docs-only push during the review of 1.0.8 sent it back to Needs changes. Push while a version is in review only when it has to change.
