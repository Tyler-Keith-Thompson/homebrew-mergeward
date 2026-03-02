class Mergeward < Formula
  desc "Code review tool for macOS with MCP server for Claude integration"
  homepage "https://mergeward.com"
  version "0.0.1"
  sha256 "a769c202d890a0d5f01aa51d178f1ebf028685985f31512b078ac8ba429d68d3"
  url "https://github.com/Tyler-Keith-Thompson/MergeWard/releases/download/v#{version}/mergeward-#{version}-universal-apple-darwin.tar.gz"
  license "Proprietary"

  depends_on :macos

  def install
    bin.install "mergeward-mcp"
    bin.install "mergeward"
  end

  def caveats
    <<~EOS
      To configure MergeWard MCP for Claude Code, run:

        claude mcp add mergeward -- #{opt_bin}/mergeward-mcp

      To open a repository in MergeWard:

        mergeward .

      Note: The MergeWard macOS app must be installed for the CLI and
      keychain-based auth. Without the app, set environment variables:

        export MERGEWARD_TOKEN="your-access-token"
        export MERGEWARD_REFRESH_TOKEN="your-refresh-token"
    EOS
  end

  test do
    assert_predicate bin/"mergeward-mcp", :executable?
    assert_predicate bin/"mergeward", :executable?
  end
end
