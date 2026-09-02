#!/bin/sh
# Vendors the i18next-localization skill from its source of truth in
# i18next/i18next-cli (where the drift-guard tests live). Re-run after a
# skill change upstream; the only edit applied here is the attribution tag,
# so registrations coming through this plugin are counted separately.
set -e
BASE="https://raw.githubusercontent.com/i18next/i18next-cli/main/skills/i18next-localization"
DEST="$(dirname "$0")/../skills/i18next-localization"
mkdir -p "$DEST/references"
curl -fsSL "$BASE/SKILL.md" | sed 's/from=i18next_cli__skill/from=locize_plugin__skill/' > "$DEST/SKILL.md"
curl -fsSL "$BASE/references/stacks.md" > "$DEST/references/stacks.md"
echo "synced $DEST from i18next/i18next-cli main"
