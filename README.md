# StableJason

[Online Documentation](https://hexdocs.pm/stable_jason).

`StableJason` is a library for encoding Elixir values to a stable JSON with deterministic sorting for keys.

It works similar like [OJSON](https://hex.pm/packages/ojson) but can output a pretty JSON string, using [Jason](https://hex.pm/packages/jason) as the underlying JSON encoder.

 The initial use-case for this library is to display a diff between two JSON files. The problem with JSON is that the order of keys is not guaranteed, so a diff between two JSON files can be very noisy. By using `StableJason` to encode the JSON files, the order of keys is deterministic, so the diff will be much more readable.

## Examples

```elixir
StableJason.encode(%{c: 3, b: 2, a: 1})
{:ok, ~S|{"a":1,"b":2,"c":3}|}

StableJason.encode(%{c: 3, b: 2, a: 1}, pretty: true)
{:ok, "{\n  \"a\": 1,\n  \"b\": 2,\n  \"c\": 3\n}"}

StableJason.encode!(%{c: 3, b: 2, a: 1})
"{\"a\":1,\"b\":2,\"c\":3}"

StableJason.encode!(%{c: 3, b: 2, a: 1}, pretty: true)
"{\n  \"a\": 1,\n  \"b\": 2,\n  \"c\": 3\n}"
```

## Installation

Add `stable_jason` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:stable_jason, "~> 1.0.0"}
  ]
end
```

## License

StableJason is released under the Apache License 2.0 - see the [LICENSE](LICENSE) file.
