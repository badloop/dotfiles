# Agent Skills Spec Summary

Quick reference for the agentskills.io specification. Full spec at https://agentskills.io/specification.

## Directory Structure

```
skill-name/
  SKILL.md          # Required - instructions + frontmatter
  scripts/          # Optional - executable code
  references/       # Optional - detailed docs loaded on demand
  assets/           # Optional - templates, configs, data files
```

## Frontmatter Fields

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | Max 64 chars. Lowercase + hyphens only. Must match directory name. No leading/trailing/consecutive hyphens. |
| `description` | Yes | Max 1024 chars. Non-empty. Third person. Describes what + when. |
| `license` | No | License name or reference to bundled file. |
| `compatibility` | No | Max 500 chars. Environment requirements. |
| `metadata` | No | Arbitrary key-value map (string -> string). |
| `allowed-tools` | No | Space-delimited list of pre-approved tools. Experimental. |

## Name Validation Rules

- Only lowercase alphanumeric + hyphens: `a-z`, `0-9`, `-`
- Cannot start or end with `-`
- Cannot contain `--` (consecutive hyphens)
- Must match the parent directory name exactly

## Token Budget Guidelines

| Layer | Budget | When Loaded |
|-------|--------|-------------|
| Metadata (name + description) | ~100 tokens | Startup (all skills) |
| SKILL.md body | <5000 tokens recommended | When skill activates |
| Reference files | As needed | When agent follows a link |

## Key Rules

- SKILL.md body: under 500 lines
- File references: one level deep from SKILL.md (no chains)
- Paths: forward slashes only, no backslashes
- Reference files >100 lines: include table of contents
- Description: specific keywords, third person, what + when

## Best Practices Checklist

```
- [ ] name matches directory, valid format
- [ ] description is third person with trigger keywords
- [ ] SKILL.md < 500 lines
- [ ] No absolute paths
- [ ] Forward slashes only
- [ ] References one level deep
- [ ] Side effects require confirmation
- [ ] Consistent terminology
- [ ] No time-sensitive info
- [ ] Concise (no unnecessary explanations)
```
