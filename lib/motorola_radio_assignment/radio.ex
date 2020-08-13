defmodule MotorolaRadioAssignment.Radio do
  use Ecto.Schema
  import Ecto.Changeset

  schema "radios" do
    field :alias, :string
    field :allowed_locations, {:array, :string}
    field :location, :string

    timestamps()
  end

  @doc false
  def changeset(radio, attrs) do
    radio
    |> cast(attrs, [:alias, :allowed_locations, :location])
    |> validate_required([:alias, :allowed_locations])
  end
end
