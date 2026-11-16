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
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/aeman"
  end

  test do
    assert_equal "aeman v#{version}", shell_output("#{bin}/aeman --version").strip
  end
end
