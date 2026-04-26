cask "mergeward" do
  desc "Code review tool for macOS with MCP server for Claude integration"
  homepage "https://mergeward.com"
  version "0.0.71"
  sha256 "989ef79fd7acf1afa530fbe28cc15c5769564f24465df1cbffb45fa4008663eb"
  url "https://github.com/Tyler-Keith-Thompson/homebrew-mergeward/releases/download/v#{version}/mergeward-#{version}-universal-apple-darwin.zip"
  name "MergeWard"
  depends_on macos: ">= :sequoia"

  app "mergeward/MergeWard.app"
  binary "mergeward/mergeward"

  preflight do
    # Wipe Sparkle's transient install staging dir before installing the new
    # build. Pre-v0.0.67 builds could leave this dir in a state where the
    # freshly-launched Autoupdate couldn't write through (POSIX EPERM on
    # mkdir), causing all subsequent in-app updates to fail with "An error
    # occurred while running the updater." Safe to remove on every install
    # — Sparkle recreates it on demand. Runs as the calling user (no sudo),
    # so ~/Library is reachable.
    require "fileutils"
    stale = Pathname.new(Dir.home)/"Library/Caches/com.mergeward.app/org.sparkle-project.Sparkle/Installation"
    FileUtils.rm_rf(stale) if stale.exist?
  end

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
