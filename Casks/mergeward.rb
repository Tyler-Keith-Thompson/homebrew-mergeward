cask "mergeward" do
  desc "Code review tool for macOS with MCP server for Claude integration"
  homepage "https://mergeward.com"
  version "0.0.28"
  sha256 "f59a8f7ee9e749c234523d970b2035a3dfdee4f1f392fd63de918af91d366074"
  url "https://github.com/Tyler-Keith-Thompson/homebrew-mergeward/releases/download/v#{version}/mergeward-#{version}-universal-apple-darwin.zip"
  name "MergeWard"
  depends_on macos: ">= :sequoia"

  app "mergeward/MergeWard.app"
  binary "mergeward/mergeward-mcp"
  binary "mergeward/mergeward"

  postflight do
    system_command "/usr/bin/xattr",
      args: ["-cr", "#{appdir}/MergeWard.app"],
      sudo: false
  end

  caveats <<~EOS
    To configure MergeWard MCP for Claude Code, run:

      claude mcp add mergeward -- #{HOMEBREW_PREFIX}/bin/mergeward-mcp

    To open a repository in MergeWard:

      mergeward .
  EOS
end
