defmodule MotorolaRadioAssignment.Domain do
  @moduledoc """  
  This module encapsulates the business logic of the assignment.
  """

  use Ecto.Repo,
    otp_app: :motorola_radio_assignment,
    adapter: Ecto.Adapters.Postgres

    alias MotorolaRadioAssignment.{Radio, Repo}

  @doc """
  Add a radio to the database.

  Returns `:ok`: Transaction performed successfully.
  Returns `:constraint_violation`: Transaction not performed due to invalid constraint. Probably the ID already existed.
  """
  def insert_radio(id, radio_alias, allowed_locations) when is_integer(id) and
        is_bitstring(radio_alias) and is_list(allowed_locations) do
    try do
      Repo.insert(%Radio{
        id: id,
        alias: radio_alias,
        allowed_locations: allowed_locations
      })
      :ok
    rescue
      Ecto.ConstraintError -> :constraint_violation
    end

  end

  @doc """
  Get the location of a preexisting radio based on its id.

  Returns `{:ok, location}`: If successful.
  Returns `{:invalid_id, nil}`: If the radio does not exist.
  Returns `{:no_location, nil}`: If the radio does not have a location.
  """
  def get_radio_location(id) when is_integer(id) do
    case Repo.get(Radio, id) do
      nil ->
        {:invalid_id, nil}
      radio ->
        case radio.location do
          nil -> {:no_location, nil}
          location -> {:ok, location}
        end
    end
  end

  @doc """
  Set the location of a preexisting radio.

  Returns `:ok`: Transaction performed successfully.
  Returns `:invalid_id`: The ID did not correspond to any radio.
  Returns `:invalid_location`: The location is not in the allowed_locations list for the radio.
  """
  def set_radio_location(id, location) when is_integer(id) and is_bitstring(location) do
    case Repo.get(Radio, id) do
      nil ->
        :invalid_id
      radio ->
        if location in radio.allowed_locations do
          change = Ecto.Changeset.change(radio, location: location)
          Repo.update(change)
          :ok
        else
          :invalid_location
        end
    end
  end
end
