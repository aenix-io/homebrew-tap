# aenix-io Homebrew tap

Homebrew formulas for tools published by aenix. Once aenix-io/aeman releases with GoReleaser, each release tag publishes the `aeman` formula here: prebuilt binaries for macOS and Linux go to the GitHub release and the new formula is committed to `main`, so `brew upgrade` picks up every release; pre-release tags (`v1.2.3-rc1`) leave it alone. Until then the formula builds from the source tarball and is updated by hand (see below).

## Installation

```bash
brew install aenix-io/tap/aeman
```

Or tap once and install by name:

```bash
brew tap aenix-org/tap
brew install aeman
```

## Formulas

| Formula | Description | Source |
| --- | --- | --- |
| `aeman` | Short-term planning for engineering teams with web UI and MCP server | [aenix-io/aeman](https://github.com/aenix-io/aeman) |

## Using aeman as an MCP server

`aeman mcp` starts the MCP server on stdio for AI agents; see [docs/api.md](https://github.com/aenix-io/aeman/blob/main/docs/api.md) for the tools and flags.

## Updating a formula by hand

Needed until aenix-io/aeman releases with GoReleaser, and after that only when a release did not reach the tap. In that case re-run the failed Release workflow in aenix-io/aeman first: it replaces the assets it already uploaded and pushes the formula again. Otherwise:

1. In `Formula/aeman.rb` of the tapped checkout (`$(brew --repository aenix-io/tap)`), point every `url`, and `version` if the formula has one, at the new tag.
2. Set each `sha256`: for a release archive, copy it from `checksums.txt` of the same GitHub release; for a source tarball, use the output of `curl --silent --location <url> | shasum --algorithm 256`.
3. Check it with `brew install aenix-io/tap/aeman`, `brew test aeman` and `brew audit --strict --online aenix-io/tap/aeman`.
4. Open a pull request.

## License

Apache-2.0
