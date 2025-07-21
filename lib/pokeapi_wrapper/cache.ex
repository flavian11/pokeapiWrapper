defmodule PokeapiWrapper.Cache do
  use GenServer
  require Logger

  def start_link(table_name) do
    GenServer.start_link(__MODULE__, table_name, name: :pokeapi_cache)
  end

  def get_pokemon(name_or_id) do
    GenServer.call(:pokeapi_cache, {:get_pokemon, name_or_id})
  end

  def cache_poke(name_or_id, pokemon_data) do
    GenServer.cast(:pokeapi_cache, {:cache_pokemon, name_or_id, pokemon_data})
  end

  defp key(name_or_id) when is_integer(name_or_id) do
    {:id, "pokemon_id_#{name_or_id}"}
  end

  defp key(name_or_id) when is_binary(name_or_id) do
    {:name, "pokemon_name_#{String.downcase(name_or_id)}"}
  end

  @impl true
  def init(table_name) do
    Logger.info("Starting pokemon cache on table #{table_name}")

    {:ok, :ets.new(table_name, [:named_table, :set, read_concurrency: true])}
  end

  @impl true
  def handle_call({:get_pokemon, name_or_id}, _, table_name) do
    {_, cache_key} = key(name_or_id)

    case :ets.lookup(table_name, cache_key) do
      [{^cache_key, pokemon_data}] ->
        Logger.info("Pokemon get from cache: #{name_or_id}")
        {:reply, {:ok, pokemon_data}, table_name}

      [] ->
        {:reply, {:error, :not_found}, table_name}
    end
  end

  # We want to save pokemon data with both key so we can instantly retrieve it by name if we cache it with id
  @impl true
  def handle_cast({:cache_pokemon, name_or_id, pokemon_data}, table_name) do
    Logger.info("Cache Pokemon: #{name_or_id}")

    case key(name_or_id) do
      {:name, cache_key} ->
        :ets.insert(table_name, {cache_key, pokemon_data})
        {_, id_key} = key(pokemon_data["id"])
        :ets.insert(table_name, {id_key, pokemon_data})

      {:id, cache_key} ->
        :ets.insert(table_name, {cache_key, pokemon_data})
        {_, name_key} = key(pokemon_data["name"])
        :ets.insert(table_name, {name_key, pokemon_data})
    end

    {:noreply, table_name}
  end
end
