cask "mergeward" do
  desc "Code review tool for macOS with MCP server for Claude integration"
  homepage "https://mergeward.com"
  version "0.0.51"
  sha256 "974421fea7bd86028ed8d39bed93cdfaad1775273979300d285279d18423f667"
  url "https://github.com/Tyler-Keith-Thompson/homebrew-mergeward/releases/download/v#{version}/mergeward-#{version}-universal-apple-darwin.zip"
  name "MergeWard"
  depends_on macos: ">= :sequoia"

  app "mergeward/MergeWard.app"
  binary "mergeward/mergeward"

  postflight do
    system_command "/usr/bin/xattr",
      args: ["-cr", "#{appdir}/MergeWard.app"],
      sudo: false
    # Backward-compat symlink: existing MCP configs reference mergeward-mcp
    system_command "/bin/ln",
      args: ["-sf", "mergeward", "#{HOMEBREW_PREFIX}/bin/mergeward-mcp"],
      sudo: false
    # Auto-update Claude Code plugin skills (idempotent)
    system_command "#{HOMEBREW_PREFIX}/bin/mergeward",
      args: ["install", "claude-plugin"],
      sudo: false
  end

  caveats <<~EOS
    To configure MergeWard MCP for Claude Code, run:

      claude mcp add mergeward -- #{HOMEBREW_PREFIX}/bin/mergeward mcp

    To open a repository in MergeWard:

      mergeward .
  EOS
end
