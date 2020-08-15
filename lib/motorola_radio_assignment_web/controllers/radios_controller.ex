defmodule MotorolaRadioAssignmentWeb.RadiosController do
  use MotorolaRadioAssignmentWeb, :controller

  alias MotorolaRadioAssignment.{Radio, Repo}

  def insert(conn, %{"id" => id, "alias" => radio_alias, "allowed_locations" => allowed_locations})
      when is_list(allowed_locations) do
    try do
      Repo.insert(%Radio{
          "id": elem(Integer.parse(id), 0),
          "alias": radio_alias,
          "allowed_locations": allowed_locations
      })
      conn |> send_resp(:ok, "")
    rescue
        Ecto.ConstraintError -> conn |> send_resp(:conflict, "The radio could not be created because a constraint was violated. Possibly the ID already exists.")
    end
  end

  def get_location(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {id, ""} ->
        try do
          radio = Repo.get!(Radio, id)
          case radio.location do
            location when not is_nil(location) ->
              json(conn, %{"location": radio.location})
            _ ->
              conn |> send_resp(:not_found, "")
          end
        rescue
          Ecto.NoResultsError ->
            conn |> send_resp(:not_found, "")
        end
      _ ->
        conn |> send_resp(:not_found, "")
    end
  end

  def post_location(conn, %{"id" => id}) do
    conn |> send_resp(:not_found, "")
  end

end
