defmodule MotorolaRadioAssignmentWeb.RadiosTest do
  use MotorolaRadioAssignmentWeb.ConnCase

  alias MotorolaRadioAssignment.{Radio, Repo}
  import Ecto.Query

  def get_max_id() do
    case Repo.one(from r in Radio, select: max(r.id)) do
      nil -> 1
      {id} -> id
    end
  end

  test "Post radio with used ID", %{conn: conn} do
    max_id = get_max_id()

    conn = post(conn, "/radios/#{max_id+1}", [alias: "Radio100", allowed_locations: ["CPH-1", "CPH-3"]])
    assert response(conn, 200) =~ ""

    conn = post(conn, "/radios/#{max_id+1}", [alias: "Radio100", allowed_locations: ["CPH-1", "CPH-3"]])
    assert response(conn, 409) =~ ""

    conn = post(conn, "/radios/#{max_id+1}", [alias: "Radio101", allowed_locations: ["CPH-1", "CPH-2", "CPH-3"]])
    assert response(conn, 409) =~ ""
  end

  test "Post radio with invalid ID", %{conn: conn} do
    conn = post(conn, "/radios/invalid", [alias: "Radio100", allowed_locations: ["CPH-1", "CPH-3"]])
    assert response(conn, 404) =~ ""
  end

  test "Post radio with missing data", %{conn: conn} do
    max_id = get_max_id()

    conn = post(conn, "/radios/#{max_id+1}", [allowed_locations: ["CPH-1", "CPH-3"]])
    assert response(conn, 400) =~ ""

    conn = post(conn, "/radios/#{max_id+2}", [alias: "Radio100"])
    assert response(conn, 400) =~ ""

    conn = post(conn, "/radios/#{max_id+3}", [])
    assert response(conn, 400) =~ ""
  end

end
