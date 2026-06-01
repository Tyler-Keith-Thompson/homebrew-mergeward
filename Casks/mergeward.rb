cask "mergeward" do
  desc "Code review tool for macOS with MCP server for Claude integration"
  homepage "https://mergeward.com"
  version "0.0.79"
  sha256 "a036ce4e83419d2c117fdd8bda97af60cb81ee6ef3be8970d309bbda21dc6507"
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
    # CRITICAL: also strip com.apple.quarantine from the CLI binary. Homebrew
    # auto-strips it for `app` artifacts but NOT for `binary` artifacts, so
    # without this the binary triggers Gatekeeper's online notary-ticket
    # round-trip on first run (bare binaries can't have tickets stapled).
    # If the user's Mac can't reach Apple's notary CDN — propagation lag right
    # after a release, corporate firewall, spotty network — they see "Apple
    # could not verify mergeward" and the `mergeward install claude-plugin`
    # step below blows up. The binary IS signed and notarized; we're just
    # skipping the network round-trip Gatekeeper would otherwise do, which
    # the local signature already covers.
    system_command "/usr/bin/xattr",
      args: ["-cr", "#{staged_path}/mergeward/mergeward"],
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
