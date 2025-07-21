defmodule PokeapiWrapper do
  @moduledoc """
  Documentation for `PokeapiWrapper`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PokeapiWrapper.hello()
      :world

  """

  def pokemon(name_or_id), do: PokeapiWrapper.Client.pokemon(name_or_id)
  def get_pokemon_species(name_or_id), do: PokeapiWrapper.Client.get_pokemon_species(name_or_id)

  def get_type(name_or_id), do: PokeapiWrapper.Client.get_type(name_or_id)

  def get_ability(name_or_id), do: PokeapiWrapper.Client.get_ability(name_or_id)

  def get_move(name_or_id), do: PokeapiWrapper.Client.get_move(name_or_id)

  def get_generation(name_or_id), do: PokeapiWrapper.Client.get_generation(name_or_id)

  def get_region(name_or_id), do: PokeapiWrapper.get_region(name_or_id)

  def list_pokemon(), do: PokeapiWrapper.Client.list_pokemon()
  def list_pokemon(limit), do: PokeapiWrapper.Client.list_pokemon(limit)
  def list_pokemon(limit, offset), do: PokeapiWrapper.Client.list_pokemon(limit, offset)

  def list_types(), do: PokeapiWrapper.Client.list_types()

  def list_abilities(), do: PokeapiWrapper.Client.list_abilities()
  def list_abilities(limit), do: PokeapiWrapper.Client.list_abilities(limit)
  def list_abilities(limit, offset), do: PokeapiWrapper.Client.list_abilities(limit, offset)
end
