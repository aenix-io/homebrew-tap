class Aeman < Formula
  desc "Short-term planning for engineering teams with web UI and MCP server"
  homepage "https://github.com/aenix-io/aeman"
  url "https://github.com/aenix-io/aeman/archive/refs/tags/v0.53.1.tar.gz"
  sha256 "aeb27f3e2cca414635c87e14706c71dcd999c68347a943eb225673dd1116c8c6"
  license "Apache-2.0"
  head "https://github.com/aenix-io/aeman.git", branch: "main"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web" do
      system "npm", "ci", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/aeman"
  end

  def caveats
    <<~EOS
      The MCP daemon can run under one of two managers. Use only one: both
      default to the same data directory and port, and the second one fails
      to start on the held lock.

      brew services: put the board in ~/.homebrew/services/aeman.env, e.g.
        AEMAN_REPOS=board=https://github.com/OWNER/REPO.git
      then run
        brew services start aeman
      After `brew upgrade aeman`: brew services restart aeman

      aeman service: install the unit from the Homebrew binary, so the unit
      keeps pointing at it across upgrades:
        #{opt_bin}/aeman service install --repo board=https://github.com/OWNER/REPO.git
      After `brew upgrade aeman`, restart the daemon:
        macOS: launchctl kill SIGTERM gui/$(id -u)/io.aenix.aeman
        Linux: systemctl --user restart aeman.service

      To switch from `aeman service` to brew services, run
      `aeman service uninstall` first; the other way, `brew services stop aeman`.
    EOS
  end

  service do
    run [opt_bin/"aeman", "mcp"]
    environment_variables AEMAN_MCP_LISTEN: "127.0.0.1:8766", PATH: std_service_path_env
    keep_alive true
    process_type :background
    # The daemon drains unpushed commits on SIGTERM for up to 30s.
    stop_timeout 35
    log_path var/"log/aeman.log"
    error_log_path var/"log/aeman.log"
  end

  test do
    assert_equal "aeman #{version}", shell_output("#{bin}/aeman --version").strip
  end
end
