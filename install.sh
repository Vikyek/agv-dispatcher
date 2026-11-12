#!/usr/bin/env bash
#
# install.sh — Setup script for agv-dispatcher
# Installs/links the plugin and skill into Antigravity configuration.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEMINI_DIR="${HOME}/.gemini/config"
PLUGIN_DIR="${GEMINI_DIR}/plugins/agv-dispatcher"
SKILL_DIR="${GEMINI_DIR}/skills/agv-dispatcher"
PLUGINS_JSON="${GEMINI_DIR}/plugins.json"

echo "🚀 [agv-dispatcher] Installing plugin and skill..."

mkdir -p "${GEMINI_DIR}/plugins" "${GEMINI_DIR}/skills"

# Symlink plugin directory
ln -sfn "${SCRIPT_DIR}" "${PLUGIN_DIR}"

# Symlink skill directory
mkdir -p "${SKILL_DIR}"
ln -sf "${SCRIPT_DIR}/skills/dispatcher/SKILL.md" "${SKILL_DIR}/SKILL.md"

# Ensure registered in plugins.json if file exists
if [[ -f "${PLUGINS_JSON}" ]]; then
    if ! grep -q "agv-dispatcher" "${PLUGINS_JSON}"; then
        echo "📝 [agv-dispatcher] Registering in plugins.json..."
        python3 -c "
import json
p = '${PLUGINS_JSON}'
try:
    with open(p, 'r') as f:
        data = json.load(f)
    entries = data.get('entries', [])
    target = '~/.gemini/config/plugins/agv-dispatcher'
    if not any(e.get('path') == target for e in entries):
        entries.append({'path': target})
        data['entries'] = entries
        with open(p, 'w') as f:
            json.dump(data, f, indent=2)
        print('✅ Registered in plugins.json')
except Exception as e:
    print('Warning: could not update plugins.json:', e)
"
    fi
fi

echo "✅ [agv-dispatcher] Installation completed successfully!"
echo "   Plugin: ${PLUGIN_DIR}"
echo "   Skill:  ${SKILL_DIR}/SKILL.md"
