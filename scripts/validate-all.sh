#!/usr/bin/env bash
set -euo pipefail

readonly ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for required in \
  "README.md" \
  "CHANGELOG.md" \
  "LICENSE" \
  ".agents/plugins/marketplace.json" \
  ".claude-plugin/marketplace.json" \
  "plugins/rota/.codex-plugin/plugin.json" \
  "plugins/rota/.claude-plugin/plugin.json" \
  "plugins/rota/skills/rota/SKILL.md"; do
  if [[ ! -f "$ROOT/$required" ]]; then
    echo "missing required file: $required" >&2
    exit 1
  fi
done

python3 -I - "$ROOT" <<'PY'
import json
import sys
from pathlib import Path

root = Path(sys.argv[1])


def load_json(relative_path: str) -> dict:
    path = root / relative_path
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise SystemExit(f"invalid JSON in {relative_path}: {error}") from error
    if not isinstance(payload, dict):
        raise SystemExit(f"JSON root must be an object: {relative_path}")
    return payload


for relative_path in (
    "plugins/rota/.codex-plugin/plugin.json",
    "plugins/rota/.claude-plugin/plugin.json",
):
    manifest = load_json(relative_path)
    for key, expected in (("name", "rota"), ("version", "0.1.0"), ("skills", "./skills/")):
        if manifest.get(key) != expected:
            raise SystemExit(f"{relative_path} must set {key!r} to {expected!r}")
    if manifest.get("license") != "MIT":
        raise SystemExit(f"{relative_path} must declare the MIT license")

codex_marketplace = load_json(".agents/plugins/marketplace.json")
if codex_marketplace.get("name") != "rota":
    raise SystemExit("Codex marketplace must be named 'rota'")
entries = codex_marketplace.get("plugins")
if not isinstance(entries, list) or len(entries) != 1:
    raise SystemExit("Codex marketplace must contain exactly one plugin")
entry = entries[0]
expected_entry = {
    "name": "rota",
    "source": {"source": "local", "path": "./plugins/rota"},
    "policy": {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
    "category": "Productivity",
}
if entry != expected_entry:
    raise SystemExit("Codex marketplace entry does not match the local Rota source contract")

claude_marketplace = load_json(".claude-plugin/marketplace.json")
if claude_marketplace.get("name") != "rota":
    raise SystemExit("Claude marketplace must be named 'rota'")
claude_entries = claude_marketplace.get("plugins")
if not isinstance(claude_entries, list) or len(claude_entries) != 1:
    raise SystemExit("Claude marketplace must contain exactly one plugin")
claude_entry = claude_entries[0]
if claude_entry.get("name") != "rota" or claude_entry.get("source") != "./plugins/rota":
    raise SystemExit("Claude marketplace must point to ./plugins/rota")

skill_root = root / "plugins/rota/skills"
skill_paths = {path.relative_to(skill_root).as_posix() for path in skill_root.rglob("SKILL.md")}
if skill_paths != {"rota/SKILL.md"}:
    raise SystemExit(f"Rota must expose exactly one skill entrypoint, found: {sorted(skill_paths)}")

for forbidden_name in (
    "superflow_rota.py",
    "plano.json",
    "implementation_plan.json",
    "workflow.json",
):
    found = [path.relative_to(root).as_posix() for path in root.rglob(forbidden_name) if ".git" not in path.parts]
    if found:
        raise SystemExit(f"retired execution artifact present: {', '.join(found)}")

print("structure and manifests: valid")
PY

echo "validate-all: passed"
