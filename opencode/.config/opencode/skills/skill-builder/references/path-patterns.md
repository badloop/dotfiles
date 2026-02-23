# Path Portability Patterns

## The Problem

Absolute paths like `/home/username/code/work/today/tools/script.py` break when:
- A different user runs the skill
- The repo is cloned to a different location
- The skill is shared or open-sourced

## Pattern 1: Home-Relative Paths

Use `~` or `${HOME}` for anything anchored to the user's home directory.

```bash
# Good
python3 ~/code/work/today/tools/graph_auth.py
source "${HOME}/.config/opencode/skills/my-skill/scripts/helper.sh"

# Bad
python3 /home/username/code/work/today/tools/graph_auth.py
```

In Python:
```python
import os
home = os.path.expanduser("~")
tool_path = os.path.join(home, "code", "work", "today", "tools", "graph_auth.py")
```

## Pattern 2: Environment Variables

For tools that may live in different locations per environment, define an env var.

```bash
# Skill instructs the agent to discover or set the variable
GRAPH_AUTH_DIR="${GRAPH_AUTH_DIR:-~/code/work/today/tools}"
python3 "${GRAPH_AUTH_DIR}/graph_auth.py"
```

In Python:
```python
import os
tool_dir = os.environ.get("GRAPH_AUTH_DIR", os.path.expanduser("~/code/work/today/tools"))
```

## Pattern 3: Skill-Relative Paths

For files bundled with the skill itself, always use relative paths from SKILL.md.

```markdown
See [references/api-guide.md](references/api-guide.md) for endpoint details.
Run the helper: `python3 scripts/validate.py`
```

The agent resolves these relative to the skill directory it loaded SKILL.md from.

## Pattern 4: PATH Discovery

For executables that should be on the system PATH:

```bash
# Check if tool exists
if ! command -v mmdc &> /dev/null; then
    echo "Error: mmdc (Mermaid CLI) is not installed"
    exit 1
fi

# Use it without a path
mmdc -i diagram.mmd -o diagram.png
```

## Pattern 5: Runtime Discovery

When the agent needs to find something at runtime (e.g., a repo root, a config directory):

```bash
# Find git repo root
REPO_ROOT=$(git rev-parse --show-toplevel)

# Find a file by convention
TOOL=$(find ~/code -name "graph_auth.py" -path "*/tools/*" 2>/dev/null | head -1)
```

## Decision Matrix

| Situation | Pattern | Example |
|-----------|---------|---------|
| User's config/data files | Home-relative (`~`) | `~/.config/opencode/...` |
| Tools that vary by setup | Environment variable | `${GRAPH_AUTH_DIR}/script.py` |
| Files inside the skill | Relative from SKILL.md | `references/guide.md` |
| System executables | PATH discovery | `command -v mmdc` |
| Project-specific files | Runtime discovery | `git rev-parse --show-toplevel` |
