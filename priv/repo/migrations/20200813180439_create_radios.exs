defmodule MotorolaRadioAssignment.Repo.Migrations.CreateRadios do
  use Ecto.Migration

  def change do
    create table(:radios) do
      add :alias, :string
      add :allowed_locations, {:array, :string}
      add :location, :string

      timestamps()
    end

  end
end
