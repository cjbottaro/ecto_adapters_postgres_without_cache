# Configuring an Ecto repo only allows us to specify an adapter (not an
# adapter's connection). So we have to make a whole new adapter just so
# we can use a modified connection. Here's why:
#   https://github.com/elixir-ecto/ecto/blob/7105a26fc72cbad83cdb81dd06dec01f33e41629/lib/ecto/adapters/sql.ex#L20
# See, we have no control over the connection, only the adapter, then a naming
# convention is used to specify the connetion.
defmodule Ecto.Adapters.PostgresWithoutCache do
  use Ecto.Adapters.SQL, :postgrex

  @behaviour Ecto.Adapter.Storage
  @behaviour Ecto.Adapter.Structure

  defdelegate dumpers(a1, a2),           to: Ecto.Adapters.Postgres
  defdelegate loaders(a1, a2),           to: Ecto.Adapters.Postgres
  defdelegate storage_down(a1),          to: Ecto.Adapters.Postgres
  defdelegate storage_up(a1),            to: Ecto.Adapters.Postgres
  defdelegate structure_dump(a1, a2),    to: Ecto.Adapters.Postgres
  defdelegate structure_load(a1, a2),    to: Ecto.Adapters.Postgres
  defdelegate supports_ddl_transaction?, to: Ecto.Adapters.Postgres
end
