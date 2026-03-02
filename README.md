# homebrew-mergeward

Homebrew tap for [MergeWard](https://mergeward.com) — AI-native code review tool.

## Install

```bash
brew tap Tyler-Keith-Thompson/mergeward
brew install mergeward
```

This installs:

- **`mergeward-mcp`** — MCP server for Claude Code / Claude Desktop integration
- **`mergeward`** — CLI to open repositories in MergeWard.app

## Configure Claude

After installing, configure the MCP server:

```bash
# Claude Code
claude mcp add mergeward -- mergeward-mcp

# Claude Desktop — add to ~/Library/Application Support/Claude/claude_desktop_config.json:
{
  "mcpServers": {
    "mergeward": {
      "command": "/opt/homebrew/bin/mergeward-mcp"
    }
  }
}
```

## Usage

```bash
# Open current repo in MergeWard
mergeward .

# Open a specific repo
mergeward /path/to/repo
```
