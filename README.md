# aenix-io Homebrew tap

Homebrew formulas for tools published by aenix. Formulas build from the source tarball of a release tag.

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

With `brew services`, put the board settings in `~/.homebrew/services/aeman.env` (`$HOMEBREW_USER_CONFIG_HOME/services/aeman.env`), one `AEMAN_*` variable per line, and start the service:

```bash
mkdir -p ~/.homebrew/services
echo 'AEMAN_REPOS=board=https://github.com/OWNER/REPO.git' >> ~/.homebrew/services/aeman.env
brew services start aeman
```

The service listens on `127.0.0.1:8766` unless the file sets `AEMAN_MCP_LISTEN`; logs go to `$(brew --prefix)/var/log/aeman.log`. Homebrew ignores the file if it is group- or world-writable.

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

## Updating a formula

A release tag in [aenix-io/aeman](https://github.com/aenix-io/aeman) opens a pull request here that points `Formula/aeman.rb` at the new tag tarball. CI on a pull request runs `brew style` and, for each changed formula, a strict online audit, a build from source and `brew test` on macOS and Linux.

To bump by hand instead, set `url` to the tag tarball, set `sha256` to the output of `curl --silent --location <url> | shasum --algorithm 256`, and open a pull request.

## License

Apache-2.0
