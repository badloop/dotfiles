---
name: skill-builder
description: Creates and validates Agent Skills (SKILL.md) per the agentskills.io specification. Use when the user asks to create a new skill, convert instructions into a skill, build a skill, or package a workflow as a reusable skill.
compatibility: Requires Bash and Read/Write file access. Optionally uses skills-ref CLI for validation if installed.
metadata:
  author: ""
  version: "1.0"
allowed-tools: Bash Read Write
---

# Skill Builder

You build Agent Skills that conform to the agentskills.io specification. Every skill you create must follow the tenets below. These are non-negotiable.

## Tenets (Non-Negotiable)

### 1. No Absolute Paths

**Never hardcode absolute paths in any skill file.** Portability is paramount.

- Use `~` or `${HOME}` for home directory references
- Use paths relative to the skill directory for bundled files (`scripts/`, `references/`, `assets/`)
- For external tools/scripts the skill depends on, use one of these discovery strategies:
  - **Environment variable**: `${GRAPH_AUTH_DIR}`, `${TOOL_HOME}`, etc.
  - **`which` / `command -v` discovery**: locate executables on `$PATH`
  - **Relative to a known anchor**: `${HOME}/.local/share/...`, `~/code/work/...`
  - **Document the requirement** and let the agent resolve it at runtime

**Good:**
```bash
source "${GRAPH_AUTH_DIR}/graph_auth.py"
python3 ~/code/work/today/tools/graph_auth.py  # ~ expands per-user
```

**Bad:**
```bash
python3 /home/username/code/work/today/tools/graph_auth.py  # hardcoded user
```

### 2. Progressive Disclosure

- SKILL.md body must be under 500 lines
- Only include what the agent needs to get started
- Move endpoint references, schemas, and detailed docs into `references/` files
- SKILL.md links to reference files; agent loads them on demand

### 3. Concise Over Verbose

- Assume the agent is intelligent. Don't explain what PDFs are or how HTTP works.
- Every token must justify its cost. Challenge each paragraph: "Does the agent really need this?"
- Provide defaults, not menus of options

### 4. Confirm Before Side Effects

- Any skill that sends messages, creates resources, modifies external state, or costs money must instruct the agent to show the user what it will do and get explicit confirmation before executing.

### 5. One Level Deep References

- All referenced files must be directly linked from SKILL.md
- Never chain references (SKILL.md -> file A -> file B)

### 6. Forward Slashes Only

- Always use `/` in paths, never `\`

### 7. Description in Third Person

- The `description` field must be written in third person
- Good: "Sends and reads Microsoft Teams messages via Graph API"
- Bad: "I can help you send Teams messages"

## Workflow: Creating a New Skill

### Step 1: Gather Requirements

Ask the user:
1. What does this skill do? (one sentence)
2. What tools/scripts/APIs does it depend on?
3. What are the key workflows? (list the 2-4 main things)
4. Are there any side effects? (sending messages, creating resources, etc.)

### Step 2: Plan the Structure

Determine what goes where:

```
skill-name/
  SKILL.md              # Core instructions (<500 lines)
  references/           # Endpoint docs, schemas, detailed guides
  scripts/              # Executable helpers (if any)
  assets/               # Templates, configs (if any)
```

### Step 3: Write the Frontmatter

```yaml
---
name: kebab-case-name       # lowercase, hyphens only, max 64 chars
description: >-             # third person, max 1024 chars
  What it does and when to use it. Include trigger keywords.
compatibility: >-           # optional, environment requirements
  What's needed to run this skill.
metadata:
  author: author-name
  version: "1.0"
allowed-tools: Bash Read Write  # adjust per skill needs
---
```

Validate:
- `name` matches the directory name
- `name` is lowercase alphanumeric + hyphens, no leading/trailing/consecutive hyphens
- `description` is third person, includes trigger keywords, explains when to activate
- No absolute paths anywhere in frontmatter

### Step 4: Write the Body

Follow this structure:

1. **One-line role statement** - "You are a [X] assistant. Your job is to [Y]."
2. **Prerequisites / Authentication** - How to set up, using portable paths
3. **Step-by-step workflows** - The 2-4 main operations, each with clear steps
4. **Important rules** - Confirmation requirements, gotchas, constraints
5. **API/function signatures** - Quick reference for key interfaces
6. **Links to references** - "For complete endpoint docs, see [references/api.md](references/api.md)"

### Step 5: Write Reference Files

For each reference file:
- Add a table of contents if >100 lines
- Keep focused on one domain (don't mix endpoints with schemas)
- Use tables for structured data (endpoints, fields, error codes)

### Step 6: Validate

Run through this checklist:

```
- [ ] No absolute paths in any file (grep for /home/, /Users/, C:\)
- [ ] SKILL.md body < 500 lines
- [ ] name field matches directory name
- [ ] name is valid (lowercase, hyphens, no consecutive --, no leading/trailing -)
- [ ] description is third person
- [ ] description includes trigger keywords
- [ ] All file references are one level deep from SKILL.md
- [ ] Forward slashes only in all paths
- [ ] Side effects require user confirmation
- [ ] Consistent terminology throughout
- [ ] No time-sensitive information
```

If `skills-ref` is installed, also run:
```bash
skills-ref validate ./skill-name
```

### Step 7: Present for Review

Show the user:
1. The directory tree
2. Full SKILL.md content
3. Summary of each reference file
4. Any open questions or tradeoffs

## Path Portability Patterns

For detailed patterns and examples of portable path handling, see [references/path-patterns.md](references/path-patterns.md).

## Spec Quick Reference

For the key rules from the agentskills.io specification, see [references/spec-summary.md](references/spec-summary.md).
