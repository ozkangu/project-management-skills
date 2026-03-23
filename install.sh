#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SKILL_NAME="project-management-skills"
BACKUP_DIR=""

echo "Installing $SKILL_NAME..."

# --- Cleanup function for rollback on error ---
cleanup_on_error() {
  EXIT_CODE=$?
  if [ $EXIT_CODE -ne 0 ]; then
    echo ""
    echo "Installation failed with exit code $EXIT_CODE" >&2
    if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
      echo "Attempting to restore from backup..." >&2
      if [ -f "$BACKUP_DIR/pipeline-config.json" ]; then
        cp "$BACKUP_DIR/pipeline-config.json" "$SCRIPT_DIR/config/pipeline-config.json" 2>/dev/null || true
        echo "  Restored config file" >&2
      fi
      if [ -L "$COMMANDS_DIR/$SKILL_NAME" ]; then
        rm "$COMMANDS_DIR/$SKILL_NAME" 2>/dev/null || true
        echo "  Removed incomplete symlink" >&2
      fi
      rm -rf "$BACKUP_DIR" 2>/dev/null || true
    fi
  fi
}

trap cleanup_on_error EXIT

# --- Step 1: Validate required files ---
echo ""
echo "Validating required files..."

MISSING=0
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
    echo "  MISSING: $path" >&2
    MISSING=1
  fi
done

if [ "$MISSING" -eq 1 ]; then
  echo "Error: Required files are missing. Cannot continue." >&2
  exit 1
fi
echo "  All required files present."

# --- Step 2: Detect Claude Code environment ---
echo ""
echo "Detecting Claude Code environment..."

CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"

if [ -d "$CLAUDE_DIR" ]; then
  echo "  Found Claude Code config at $CLAUDE_DIR"
else
  echo "  Claude Code config directory not found at $CLAUDE_DIR"
  echo "  Creating $CLAUDE_DIR..."
  mkdir -p "$CLAUDE_DIR"
fi

# --- Step 3: Install skill as Claude Code custom slash command ---
echo ""
echo "Installing skill to Claude Code commands..."

mkdir -p "$COMMANDS_DIR"

LINK_TARGET="$COMMANDS_DIR/$SKILL_NAME"

if [ -L "$LINK_TARGET" ]; then
  echo "  Removing existing symlink at $LINK_TARGET"
  rm "$LINK_TARGET"
elif [ -e "$LINK_TARGET" ]; then
  echo "  Warning: $LINK_TARGET exists and is not a symlink. Backing up to ${LINK_TARGET}.bak"
  mv "$LINK_TARGET" "${LINK_TARGET}.bak"
fi

ln -s "$SCRIPT_DIR" "$LINK_TARGET"
echo "  Symlinked $SCRIPT_DIR -> $LINK_TARGET"

# --- Step 4: Provider configuration ---
echo ""
echo "Provider configuration:"

# Create backup before modifying config
BACKUP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/$SKILL_NAME.backup.XXXXXX")
cp "$SCRIPT_DIR/config/pipeline-config.json" "$BACKUP_DIR/pipeline-config.json"
echo "  Created config backup at $BACKUP_DIR"

echo "  Current default provider: $(grep -o '"default_provider": *"[^"]*"' "$SCRIPT_DIR/config/pipeline-config.json" | head -1 | sed 's/.*: *"//' | sed 's/"//')"
echo ""
echo "  Available providers:"
echo "    1) openai"
echo "    2) anthropic"
echo ""
printf "  Select default provider [1-2, or press Enter to keep current]: "

if [ -t 0 ]; then
  read -r PROVIDER_CHOICE || PROVIDER_CHOICE=""
else
  PROVIDER_CHOICE=""
  echo "(non-interactive, keeping current)"
fi

case "$PROVIDER_CHOICE" in
  1)
    if sed -i.bak 's/"default_provider": *"[^"]*"/"default_provider": "openai"/' "$SCRIPT_DIR/config/pipeline-config.json" 2>/dev/null; then
      rm -f "$SCRIPT_DIR/config/pipeline-config.json.bak"
      echo "  Default provider set to: openai"
    else
      echo "  ERROR: Failed to update provider configuration" >&2
      exit 1
    fi
    ;;
  2)
    if sed -i.bak 's/"default_provider": *"[^"]*"/"default_provider": "anthropic"/' "$SCRIPT_DIR/config/pipeline-config.json" 2>/dev/null; then
      rm -f "$SCRIPT_DIR/config/pipeline-config.json.bak"
      echo "  Default provider set to: anthropic"
    else
      echo "  ERROR: Failed to update provider configuration" >&2
      exit 1
    fi
    ;;
  *)
    echo "  Keeping current provider setting."
    ;;
esac

# --- Step 5: Post-install verification ---
echo ""
echo "Post-install verification..."

VERIFY_OK=1

# Check symlink is valid
if [ -L "$LINK_TARGET" ] && [ -d "$LINK_TARGET" ]; then
  echo "  Symlink valid: $LINK_TARGET -> $(readlink "$LINK_TARGET")"
else
  echo "  ERROR: Symlink verification failed" >&2
  VERIFY_OK=0
fi

# Check pipeline-config.json is valid JSON
if command -v python3 >/dev/null 2>&1; then
  if python3 -c "import json; json.load(open('$SCRIPT_DIR/config/pipeline-config.json'))" 2>/dev/null; then
    echo "  pipeline-config.json: valid JSON"
  else
    echo "  ERROR: pipeline-config.json is not valid JSON" >&2
    VERIFY_OK=0
  fi
elif command -v node >/dev/null 2>&1; then
  if node -e "JSON.parse(require('fs').readFileSync('$SCRIPT_DIR/config/pipeline-config.json','utf8'))" 2>/dev/null; then
    echo "  pipeline-config.json: valid JSON"
  else
    echo "  ERROR: pipeline-config.json is not valid JSON" >&2
    VERIFY_OK=0
  fi
else
  echo "  Skipping JSON validation (no python3 or node found)"
fi

# Check SKILL.md is readable
if [ -r "$SCRIPT_DIR/SKILL.md" ]; then
  echo "  SKILL.md: readable"
else
  echo "  ERROR: SKILL.md is not readable" >&2
  VERIFY_OK=0
fi

chmod 755 "$SCRIPT_DIR/install.sh"

# Clean up backup on success
if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
  rm -rf "$BACKUP_DIR"
  echo "  Cleaned up backup directory"
fi

if [ "$VERIFY_OK" -eq 1 ]; then
  echo ""
  echo "Installation complete."
  echo ""
  echo "Next steps:"
  echo "  1. Review config/pipeline-config.json"
  echo "  2. Choose execution.mode = manual | hybrid | auto"
  echo "  3. Choose estimation.default_provider and model aliases"
  echo "  4. Run /project-management-skills in Claude Code to use the skill"
else
  echo ""
  echo "Installation completed with errors. Review the messages above." >&2
  exit 1
fi
