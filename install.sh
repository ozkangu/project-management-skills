#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

echo 'Installing project-management-skills...'
echo 'Validating required files...'

for path in \
  "$SCRIPT_DIR/SKILL.md" \
  "$SCRIPT_DIR/config/pipeline-config.json" \
  "$SCRIPT_DIR/references/estimation-benchmarks.json" \
  "$SCRIPT_DIR/skills/discover/SKILL.md" \
  "$SCRIPT_DIR/skills/scope/SKILL.md" \
  "$SCRIPT_DIR/skills/architect/SKILL.md" \
  "$SCRIPT_DIR/skills/estimate/SKILL.md" \
  "$SCRIPT_DIR/skills/plan/SKILL.md" \
  "$SCRIPT_DIR/skills/execute/SKILL.md" \
  "$SCRIPT_DIR/skills/retro/SKILL.md"
do
  if [ ! -f "$path" ]; then
    echo "Missing required file: $path" >&2
    exit 1
  fi
done

chmod 755 "$SCRIPT_DIR/install.sh"

echo 'Installation complete.'
echo 'Next steps:'
echo '  1. Review config/pipeline-config.json'
echo '  2. Choose execution.mode = manual | hybrid | auto'
echo '  3. Choose estimation.default_provider and model aliases'
