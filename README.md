# aenix-io Homebrew tap

Homebrew formulas for tools published by aenix. Formulas build from the source tarball of a release tag.

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

## Updating a formula

Formulas are updated by hand when a new tag is released upstream. To bump `aeman`:

1. Set `url` in `Formula/aeman.rb` to the new tag tarball.
2. Update `sha256` with the output of `curl --silent --location <url> | shasum --algorithm 256`.
3. Check the build with `brew install --build-from-source aenix-io/tap/aeman`, `brew test aeman` and `brew audit --strict --online aenix-io/tap/aeman`.
4. Open a pull request.

## License

Apache-2.0
