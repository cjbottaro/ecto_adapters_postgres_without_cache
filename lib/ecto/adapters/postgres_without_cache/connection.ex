# The general idea here is to use Ecto.Adapters.Postgres, but "override"
# two functions:
#   prepare_execute/5
#   execute/4
# The way Ecto works is that the first time you do a query, it calls
# prepare_execute/5 which generates some metadata which is returned in
# the %Postgrex.Query{} struct and Ecto caches somewhere. Then subsequent
# calls bypass the prepare phase and just use that cached metadata.
#
# The idea here is to trash that metadata; simply have prepare_execute/5
# not return it (so it can't be stored/cached). Then force all queries to
# always do the prepare step before executing. In otherwords, always do
# prepare_execute/5, and never return the metadata it generates.
#
# The downside is that now we're generating that metadata for every query.
defmodule Ecto.Adapters.PostgresAdapterWithoutCache.Connection do
  @behaviour Ecto.Adapters.SQL.Connection

  defdelegate all(a1),                    to: Ecto.Adapters.Postgres.Connection
  defdelegate child_spec(a1),             to: Ecto.Adapters.Postgres.Connection
  defdelegate delete(a1, a2, a3, a4),     to: Ecto.Adapters.Postgres.Connection
  defdelegate delete_all(a1),             to: Ecto.Adapters.Postgres.Connection
  defdelegate execute_ddl(a1),            to: Ecto.Adapters.Postgres.Connection
  defdelegate insert(a1, a2, a3, a4, a5), to: Ecto.Adapters.Postgres.Connection
  defdelegate to_constraints(a1),         to: Ecto.Adapters.Postgres.Connection
  defdelegate update(a1, a2, a3, a4, a5), to: Ecto.Adapters.Postgres.Connection
  defdelegate update_all(a1),             to: Ecto.Adapters.Postgres.Connection

  def prepare_execute(conn, name, sql, params, opts) do
    query = %Postgrex.Query{name: "", statement: sql}
    { :ok, result } = execute(conn, query, params, opts)
    { :ok, query, result }
  end

  def execute(conn, sql, params, opts) when is_binary(sql) do
    query = %Postgrex.Query{name: "", statement: sql}
    execute(conn, query, params, opts)
  end

  def execute(conn, %{} = query, params, opts) do
    { :ok, _query, result } = DBConnection.prepare_execute(conn, query, params, opts)
    { :ok, result }
  end
end
