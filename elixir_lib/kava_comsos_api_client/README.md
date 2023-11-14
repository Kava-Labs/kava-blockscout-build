# KavaComsosApiClient

Provides a low level client for making a subset of requests to a Kava Network's Node Cosmos JSON-RPC API.

## Installation

The package can be installed
by adding `kava_comsos_api_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
   {:kava_comsos_api_client, "~> 0.1.0", hex: :kavaCosmosApiClient}
  ]
end
```

## Publishing New Versions

1. [Create a hex user](https://hex.pm/docs/publish)
1. Build docs and publish package

```bash
mix local.hex --force
mix hex.publish
```

## Development

### Building

To compile the app / library for iterative development

```bash
make build
```

### Testing

To run all elixir tests

```bash
make test
```

### Iterative Development

To start a read-execute-print-loop shell with all source code compiled

```bash
# launch repl
make repl
# run code
iex> client = %KavaComsosApiClient{}
%KavaComsosApiClient{
    endpoint_url: "https://rpc.data.kava.io",
    read_timeout_seconds: 5,
    max_retries: 3
}
#....modify code

#recompile source code for use in repl shell
iex> recompile()
```
