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

  def insert(conn, _) do
    conn |> send_resp(:bad_request, "")
  end

  def get_location(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {id, ""} ->
        try do
          radio = Repo.get!(Radio, id)
          case radio.location do
            nil -> conn |> send_resp(:not_found, "")
            location -> json(conn, %{"location": radio.location})
          end
        rescue
          Ecto.NoResultsError ->
            conn |> send_resp(:not_found, "")
        end
      _ ->
        conn |> send_resp(:not_found, "")
    end
  end

  def post_location(conn, %{"id" => id, "location" => location}) do
    case Integer.parse(id) do
      {id, ""} ->
        try do
          case Repo.get!(Radio, id) do
            nil ->
              conn |> send_resp(:not_found, "")
            radio ->
              if location in radio.allowed_locations do
                change = Ecto.Changeset.change(radio, location: location)
                Repo.update(change)
                conn |> send_resp(:ok, "")
              else
                conn |> send_resp(:forbidden, "")
              end
          end
        rescue
          Ecto.NoResultsError ->
            conn |> send_resp(:not_found, "")
        end
      _ ->
        conn |> send_resp(:not_found, "")
    end
  end

  def post_location(conn, _) do
    conn |> send_resp(:bad_request, "")
  end

end
