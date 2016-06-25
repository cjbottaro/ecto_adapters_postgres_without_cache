# EctoAdaptersPostgresWithoutCache

This is (should be) the exact same as Ecto.Adapters.Postgres, but with the
query cache disabled.

Reasoning is [here](https://elixirforum.com/t/disable-query-cache/927) and
[here](https://elixirforum.com/t/info-on-implementing-custom-ecto-pool/854).

## Installation

```elixir
def deps do
  [{:ecto_adapters_postgres_without_cache, github: "cjbottaro/ecto_adapters_postgres_without_cache"}]
end
```
