---
name: walkthrough
description: Create an interactive guided walkthrough of the code changes in this repository using MergeWard
disable-model-invocation: true
---

Create an interactive guided walkthrough of the code changes in this repository using MergeWard.

**CRITICAL: You MUST use the MergeWard MCP tools to create walkthroughs. NEVER write walkthrough JSON files directly to disk.** The MCP tools handle required fields (IDs, timestamps, base_ref, etc.) that are easy to get wrong manually. If the MCP tools (`create_walkthrough`, `add_walkthrough_step`, etc.) are not available in your tool list, STOP and tell the user: "The MergeWard MCP server doesn't appear to be connected. Please check your .mcp.json configuration."

**Feature gating:** If `create_walkthrough` returns an error mentioning "requires Professional plan", "FeatureNotAvailable", or "Feature 'walkthroughs' requires", STOP immediately and tell the user: "Walkthroughs require a Professional plan or higher. Your current plan does not include this feature. Visit mergeward.com/pricing to upgrade." Do NOT attempt to work around this by writing files directly or retrying. If the error mentions "Not authorized", tell the user: "The MergeWard MCP server is not authenticated. Make sure you are signed into the MergeWard macOS app."

The MergeWard app renders walkthroughs as an interactive step-by-step tour with purple highlighting, navigation controls, and markdown explanations.

## Workflow

### 1. Gather Context

First, discover and understand the full scope of changes:

- Use the `list_changed_files` MCP tool to discover which files have changes. This is the source of truth for what files are in the diff — do NOT use git commands to discover changed files.
- Use the `get_diff_context` MCP tool for each changed file to see the actual diff content. Pass `context_lines: 20` for broader context.
- Read any files you need for deeper understanding of the changes.
- Identify the purpose of the change set: is it a feature, refactor, bugfix, etc.?

### 2. Plan the Walkthrough Order

**This is the most important step.** Do NOT walk through files in alphabetical order. Instead, design a narrative that builds understanding progressively:

- **Start with foundations**: types, data models, interfaces, configuration — things that later code depends on
- **Then core logic**: the main algorithms, services, or business logic that implements the feature
- **Then integration points**: how the new code connects to existing systems, API boundaries, bridge layers
- **Then error handling and edge cases**: validation, fallbacks, error types
- **Then tests**: what's being tested and how
- **Finally UI / presentation**: views, formatting, display logic that consumes the above

Within each file, focus on the most important changed sections. Not every changed line needs a step — pick the 5-15 most instructive ranges.

### 3. Create the Walkthrough

Use the `create_walkthrough` MCP tool with:
- `repo_path`: the current repository path
- `title`: a descriptive title (e.g., "Authentication Refactor" not "Code Changes")
- `description`: 1-2 sentences summarizing the change set

Save the returned `bundle_path` — you'll need it for all subsequent calls.

### 4. Add Steps

For each step, use the `add_walkthrough_step` MCP tool with:
- `bundle_path`: from step 3
- `step_order`: 1-based, in your planned presentation order
- `title`: short title shown in the navigation bar (e.g., "Define the WalkthroughStep type")
- `explanation`: **markdown** explanation (see quality guidelines below)
- `file_path`: relative path within the repo
- `line_start` / `line_end`: the line range to highlight (use the NEW side line numbers for added/modified code)
- `side`: `"new"` for added/modified lines (most common), `"old"` for deleted lines
- `summary` (optional): one-line key takeaway shown as a callout

### 5. Set Chapters

After all steps are added, use the `update_walkthrough` MCP tool to group steps into chapters:
- `bundle_path`: from step 3
- `chapters`: array of `{ "title": "...", "summary": "...", "step_start": N, "step_end": M }`

Chapters provide narrative structure. Group related steps (e.g., "Data Model", "Core Logic", "UI Layer").

## Explanation Quality Guidelines

Each step's `explanation` should:

- **Explain WHY, not just WHAT**: "This struct holds the walkthrough metadata separately from steps so the manifest can be updated without rewriting all step files" is better than "This defines a WalkthroughManifest struct"
- **Build on previous steps**: "Using the `CommentSide` type we saw in step 2, this field tracks..." — create a coherent narrative
- **Highlight non-obvious design decisions**: why this approach over alternatives
- **Use markdown**: bold key terms, use `code` for identifiers, use bullet lists for multi-point explanations
- **Be concise but substantive**: 2-5 sentences per step is the sweet spot
- **Cross-reference**: mention connections to earlier steps or other files when relevant

## Guidelines

- **5-15 steps** is the sweet spot. Fewer feels incomplete; more becomes tedious.
- **5-20 lines per highlight range**. Too narrow loses context; too broad loses focus.
- Prefer highlighting **new/modified** code (`side: "new"`). Only use `side: "old"` when explaining what was removed and why.
- **Don't highlight unchanged code** — steps should point at the actual changes.
- If a file has multiple important change regions, use separate steps for each.
- The walkthrough should tell a story. A reader going through all steps should finish with a complete mental model of the changes.
