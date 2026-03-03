cask "mergeward" do
  desc "Code review tool for macOS with MCP server for Claude integration"
  homepage "https://mergeward.com"
  version "0.0.2"
  sha256 "95773fba116bff79343d5f0bb32022022741cf731ee8977dc120096dcd905a8f"
  url "https://github.com/Tyler-Keith-Thompson/homebrew-mergeward/releases/download/v#{version}/mergeward-#{version}-universal-apple-darwin.tar.gz"
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
