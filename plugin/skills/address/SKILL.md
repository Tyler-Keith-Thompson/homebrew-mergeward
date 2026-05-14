---
name: address
description: Address all unresolved MergeWard code review comments in this repository
disable-model-invocation: false
---

Address all unresolved MergeWard code review comments in this repository.

You have access to the MergeWard MCP server with tools for reading and managing code review comments stored in `.mergeward/reviews/` as `.cr` bundles.

## Workflow

1. Use `list_reviews` with the current repository path to find available reviews. The response includes a `bundle_path` field for each review.
2. Use `open_review` with the **exact `bundle_path`** returned by `list_reviews`. Do NOT construct the path yourself — bundle names include a hash suffix (e.g., `review-main-217a5a9a.cr`) that you cannot guess.
3. For each **unresolved** comment, in file order:
   a. Use `get_diff_context` to see the surrounding code and understand the change.
   b. Read the comment body and any existing replies to understand the feedback.
   c. Make the code change that addresses the feedback.
   d. Use `reply_to_comment` to explain what you changed (author: "claude").
   e. Use `resolve_comment` to mark it resolved (resolved_by: "claude").
4. After addressing all comments, provide a summary of changes made.

## Guidelines

- Address comments in file order for coherent changes.
- If a comment requires clarification, use `reply_to_comment` to ask for details instead of guessing.
- Skip comments that are already resolved.
- When making changes, follow the existing code style of the project.
- Verify that your changes compile after modifying each file.
- If a comment suggests a change you disagree with, reply explaining your reasoning rather than ignoring it.
- NEVER silently skip an unresolved comment. If you cannot address it with a code change (e.g., it suggests a major refactor, rewrite, or architectural change), reply to the comment acknowledging the feedback and ask the user how they'd like to proceed. Every unresolved comment must get either a code change or a reply.
- If any MCP tool returns a "Not authorized" or "requires ... plan" error, STOP and inform the user about the authentication/plan issue rather than attempting workarounds. For auth errors, suggest signing into the MergeWard macOS app.
