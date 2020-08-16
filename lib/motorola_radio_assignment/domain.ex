defmodule MotorolaRadioAssignment.Domain do

  use Ecto.Repo,
    otp_app: :motorola_radio_assignment,
    adapter: Ecto.Adapters.Postgres

    alias MotorolaRadioAssignment.{Radio, Repo}

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

  def get_radio_location(id) when is_integer(id) do
    Repo.get!(Radio, id).location
  end

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
