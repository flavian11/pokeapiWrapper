defmodule PokeapiWrapper.Client do
  @base_url "https://pokeapi.co/api/v2"

  def pokemon(name_or_id) do
    case PokeapiWrapper.Cache.get_pokemon(name_or_id) do
      {:ok, pokemon_data} ->
        {:ok, pokemon_basic_info(pokemon_data)}

      {:error, :not_found} ->
        res =
          name_or_id
          |> build_req("pokemon")
          |> exec_req()

        case res do
          {:ok, data} ->
            PokeapiWrapper.Cache.cache_poke(name_or_id, data)
            data |> pokemon_basic_info()

          res ->
            res
        end
    end
  end

  def get_pokemon_species(name_or_id) do
    name_or_id
    |> build_req("pokemon-species")
    |> exec_req()
  end

  def get_type(name_or_id) do
    name_or_id
    |> build_req("type")
    |> exec_req()
  end

  def get_ability(name_or_id) do
    name_or_id
    |> build_req("ability")
    |> exec_req()
  end

  def get_move(name_or_id) do
    name_or_id
    |> build_req("move")
    |> exec_req()
  end

  def get_generation(name_or_id) do
    name_or_id
    |> build_req("generation")
    |> exec_req()
  end

  def get_region(name_or_id) do
    name_or_id
    |> build_req("region")
    |> exec_req()
  end

  def list_pokemon(limit \\ 20, offset \\ 0) do
    build_req("pokemon?limit=#{limit}&offset=#{offset}")
    |> exec_req()
  end

  def list_types() do
    build_req("type")
    |> exec_req()
  end

  def list_abilities(limit \\ 20, offset \\ 0) do
    build_req("ability?limit=#{limit}&offset=#{offset}")
    |> exec_req()
  end

  defp build_req(param \\ "", endpoint) do
    "#{@base_url}/#{endpoint}/#{param}"
  end

  defp exec_req(url) do
    headers = [{"Content-Type", "application/json"}]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} ->
            {:ok, data}

          {:error, _reason} ->
            # Logger.error("Failed to decode JSON: #{inspect(reason)}")
            {:error, :invalid_json}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :not_found}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        # Logger.error("HTTP error #{status_code}")
        {:error, {:http_error, status_code}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        # Logger.error("Request failed: #{inspect(reason)}")
        {:error, {:request_failed, reason}}
    end
  end

  defp pokemon_basic_info(data) do
    %{
      id: data["id"],
      name: data["name"],
      height: data["height"],
      weight: data["weight"],
      types: Enum.map(data["types"], fn t -> t["type"]["name"] end),
      abilities: Enum.map(data["abilities"], fn a -> a["ability"]["name"] end),
      stats:
        Enum.map(data["stats"], fn s ->
          %{name: s["stat"]["name"], value: s["base_stat"]}
        end)
    }
  end
end
