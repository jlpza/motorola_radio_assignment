defmodule MotorolaRadioAssignmentWeb.RadiosController do
  use MotorolaRadioAssignmentWeb, :controller

  alias MotorolaRadioAssignment.Domain

  def insert(conn, %{"id" => id, "alias" => radio_alias, "allowed_locations" => allowed_locations})
      when is_list(allowed_locations) do
    case Integer.parse(id) do
      {id, ""} ->
        case Domain.insert_radio(id, radio_alias, allowed_locations) do
          :ok -> conn |> send_resp(:ok, "")
          :constraint_violation -> conn |> send_resp(:conflict, "A constraint was violated. Possibly the ID already exists.")
        end
      _ ->
        conn |> send_resp(:not_found, "")
    end
  end

  def insert(conn, _) do
    conn |> send_resp(:bad_request, "")
  end

  def get_location(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {id, ""} ->
        case Domain.get_radio_location(id) do
          {:ok, location} -> json(conn, %{location: location})
          {:invalid_id, _} -> conn |> send_resp(:not_found, "")
          {:no_location, _} -> conn |> send_resp(:not_found, "")
        end
      _ ->
        conn |> send_resp(:not_found, "")
    end
  end

  def get_location(conn, _) do
    conn |> send_resp(:bad_request, "")
  end

  def post_location(conn, %{"id" => id, "location" => location}) do
    case Integer.parse(id) do
      {id, ""} ->
        case Domain.set_radio_location(id, location) do
          :ok -> conn |> send_resp(:ok, "")
          :invalid_id -> conn |> send_resp(:not_found, "")
          :invalid_location -> conn |> send_resp(:forbidden, "")
        end
      _ ->
        conn |> send_resp(:not_found, "")
    end
  end

  def post_location(conn, _) do
    conn |> send_resp(:bad_request, "")
  end

end
