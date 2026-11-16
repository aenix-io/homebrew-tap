# aenix-io Homebrew tap

Homebrew formulas for tools published by aenix. Once aenix-io/aeman releases with GoReleaser, each release tag publishes the `aeman` formula here: prebuilt binaries for macOS and Linux go to the GitHub release and the new formula is committed to `main`, so `brew upgrade` picks up every release; pre-release tags (`v1.2.3-rc1`) leave it alone. Until then the formula builds from the source tarball and is updated by hand (see below).

## Installation

```bash
brew install aenix-io/tap/aeman
```

Installing by the full name also marks the formula as trusted, which current Homebrew requires for formulas from third-party taps.

## Formulas

| Formula | Description | Source |
| --- | --- | --- |
| `aeman` | Short-term planning for engineering teams with web UI and MCP server | [aenix-io/aeman](https://github.com/aenix-io/aeman) |

## Running the MCP daemon

`aeman mcp` starts the MCP server on stdio for AI agents; see [docs/api.md](https://github.com/aenix-io/aeman/blob/main/docs/api.md) for the tools and flags. For one daemon shared by every client on the machine (`aeman mcp --listen`), pick one of two service managers. Run only one of them: both use the same default data directory and port, so the second one fails to start on the held lock.

With `brew services`, put the board settings in `~/.homebrew/services/aeman.env` (`$XDG_CONFIG_HOME/homebrew/services/aeman.env` if `XDG_CONFIG_HOME` is set), one `AEMAN_*` variable per line, and start the service:

```bash
dir="${XDG_CONFIG_HOME:+$XDG_CONFIG_HOME/homebrew}"; dir="${dir:-$HOME/.homebrew}/services"
mkdir -p "$dir"
echo 'AEMAN_REPOS=board=https://github.com/OWNER/REPO.git' >> "$dir/aeman.env"
chmod go-w "$dir/aeman.env"
brew services start aeman
```

The service listens on `127.0.0.1:8766` unless the file sets `AEMAN_MCP_LISTEN`; logs go to `$(brew --prefix)/var/log/aeman.log`. Homebrew reads the file (since Homebrew 6.0.15) when it writes the service definition, so run `brew services restart aeman` after editing it; it ignores the file if it is group- or world-writable. The service does not inherit your shell's environment: if it sets `AEMAN_TZ`, `GH_CONFIG_DIR`, `GLAB_CONFIG_DIR` or `XDG_CONFIG_HOME`, copy them into the same file.

Keep every credential out of that file: no token variable (`AEMAN_GIT_TOKEN` and its per-domain forms, `GH_TOKEN`, `GITHUB_TOKEN`, `GITLAB_TOKEN`), no GitHub App key (`AEMAN_GITHUB_APP_KEY`), and no token inside an `AEMAN_REPOS` URL. Homebrew copies every variable from it, as plain text, into the launchd plist and systemd unit it generates, including the copies it writes into the formula's prefix with mode 0644, which every user on the machine can read. Sign in with `aeman login`, which keeps the token in the OS keychain, or with `gh auth login` / `glab auth login` instead.

With aeman's own unit, install it from the Homebrew binary, so the unit refers to the path that survives upgrades:

```bash
"$(brew --prefix)/opt/aeman/bin/aeman" service install --repo board=https://github.com/OWNER/REPO.git
```

To switch from `aeman service` to `brew services`, run `aeman service uninstall` first. To switch back, run `brew services stop aeman` first.

## Upgrading

`brew upgrade aeman` replaces the binary, but a running daemon keeps the old one until it restarts:

```bash
# brew services
brew services restart aeman
# aeman service on macOS: launchd starts the daemon again after it drains and exits
launchctl kill SIGTERM "gui/$(id -u)/io.aenix.aeman"
# aeman service on Linux
systemctl --user restart aeman.service
```

## Updating a formula by hand

Needed until aenix-io/aeman releases with GoReleaser, and after that only when a release did not reach the tap. In that case re-run the failed Release workflow in aenix-io/aeman first: it replaces the assets it already uploaded and pushes the formula again. Otherwise:

1. In `Formula/aeman.rb` of the tapped checkout (`$(brew --repository aenix-io/tap)`), point every `url`, and `version` if the formula has one, at the new tag.
2. Set each `sha256`: for a release archive, copy it from `checksums.txt` of the same GitHub release; for a source tarball, use the output of `curl --silent --location <url> | shasum --algorithm 256`.
3. Check it with `brew install aenix-io/tap/aeman`, `brew test aeman` and `brew audit --strict --online aenix-io/tap/aeman`.
4. Open a pull request.

## License

Apache-2.0
