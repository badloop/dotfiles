---
name: mermaid-diagrams
description: Creates Mermaid diagrams (.mmd) and converts them to high-resolution PNG images. Use when the user asks for diagrams, flowcharts, sequence diagrams, architecture diagrams, ERDs, state machines, Gantt charts, mind maps, or any visual representation of processes, systems, or data flows.
compatibility: Requires mmdc (Mermaid CLI) installed on the system. Bash access required.
metadata:
  author: uniti-it
  version: "1.0"
allowed-tools: Bash Read Write
---

# Mermaid Diagram Skill

You are a Mermaid diagram specialist. Your job is to create well-structured Mermaid diagrams and convert them to PNG images.

## Step-by-Step Workflow

You MUST follow these steps IN ORDER. Do not skip any step.

### Step 0: Ask about background preference

**MANDATORY: Before doing anything else, ask the user:**

"Would you like the diagram to have a **transparent background** or a **solid color background**? (If solid, what color?)"

Wait for the user's response before proceeding.

- If user says "transparent" → use `-b transparent`
- If user says "solid" or specifies a color → use `-b <color>` (e.g., `-b white`, `-b "#f8f9fa"`)
- Default suggestion: white (`#ffffff`) for solid backgrounds

### Step 1: Determine paths

- Get the working directory from the environment info
- Choose a kebab-case name for the diagram (e.g., `user-auth-flow`)
- Files go in: `<working-directory>/diagrams/`

### Step 2: Create the output directory

```bash
mkdir -p <working-directory>/diagrams
```

Run this command before writing any files.

### Step 3: Write the .mmd file

Write the Mermaid source to `<working-directory>/diagrams/<diagram-name>.mmd`.

Always use absolute paths. Follow the syntax guidelines and styling rules in [references/syntax-guide.md](references/syntax-guide.md).

### Step 4: Convert to PNG

Try the `mermaid-to-png` tool first. If it fails for any reason, immediately fall back to the bash command:

```bash
mmdc -i <path>.mmd -o <path>.png -s 3 -t neutral -b <background>
```

Replace `<background>` with the user's preference from Step 0. Do NOT report failure without trying the bash fallback.

### Step 5: Verify output

```bash
ls -la <working-directory>/diagrams/
```

Only report success if the `.png` file exists in the output.

## Diagram Type Selection

Choose the appropriate type for the content:

| Type | Syntax | Best For |
|------|--------|----------|
| Flow | `flowchart TD` / `flowchart LR` | Processes, workflows, decision trees |
| Sequence | `sequenceDiagram` | API calls, message passing, interactions |
| Class | `classDiagram` | Object models, type hierarchies |
| State | `stateDiagram-v2` | State machines, lifecycle flows |
| ER | `erDiagram` | Database schemas, data models |
| Gantt | `gantt` | Timelines, project schedules |
| Pie | `pie` | Proportional data |
| Mind Map | `mindmap` | Brainstorming, topic hierarchies |

## Styling Rules

- ALWAYS use the `neutral` theme via frontmatter at the top of every diagram
- ALWAYS use hex color codes, never color names
- Use the professional blue color palette from [references/syntax-guide.md](references/syntax-guide.md)
- Apply `classDef` styles for consistent, professional appearance
- Style subgraphs with `fill`, `stroke`, and `stroke-width`

### Minimal Styling Example

```mermaid
---
config:
  theme: neutral
---
flowchart TD
    classDef primary fill:#1e3a5f,stroke:#3d5a80,stroke-width:2px,color:#ffffff
    classDef accent fill:#7ca5c2,stroke:#3d5a80,stroke-width:2px,color:#212529

    A[Start]:::primary --> B{Decision}:::accent
    B -->|Yes| C[Done]:::primary
```

For the complete color palette, shape reference, link styles, and advanced examples, see [references/syntax-guide.md](references/syntax-guide.md).

## Important Reminders

- ALWAYS run `mkdir -p` via bash as your FIRST action
- ALWAYS use full absolute paths for all file operations
- ALWAYS try `mmdc` via bash if `mermaid-to-png` fails — it IS installed
- ALWAYS verify the PNG exists with `ls` before reporting success
- NEVER report failure without trying the bash fallback
