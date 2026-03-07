cask "mergeward" do
  desc "Code review tool for macOS with MCP server for Claude integration"
  homepage "https://mergeward.com"
  version "0.0.12"
  sha256 "94c4ba894e68db5c861a6dbfb128f978504b32ea800a7cdf409cf65f72c1f305"
  url "https://github.com/Tyler-Keith-Thompson/homebrew-mergeward/releases/download/v#{version}/mergeward-#{version}-universal-apple-darwin.zip"
  name "MergeWard"
  depends_on macos: ">= :sonoma"

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
