cask "mergeward" do
  desc "Code review tool for macOS with MCP server for Claude integration"
  homepage "https://mergeward.com"
  version "0.0.5"
  sha256 "cf708ac4d9664d671d57570ac2bc0c1b23898d0d4ec191af667a0bdfc115c5bf"
  url "https://github.com/Tyler-Keith-Thompson/homebrew-mergeward/releases/download/v#{version}/mergeward-#{version}-universal-apple-darwin.zip"
  name "MergeWard"
  depends_on macos: ">= :sonoma"

  app "mergeward/MergeWard.app"
  binary "mergeward/mergeward-mcp"
  binary "mergeward/mergeward"

  caveats <<~EOS
    To configure MergeWard MCP for Claude Code, run:

      claude mcp add mergeward -- #{HOMEBREW_PREFIX}/bin/mergeward-mcp

    To open a repository in MergeWard:

      mergeward .
  EOS
end
