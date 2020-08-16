defmodule MotorolaRadioAssignmentWeb.LocationTest do
  use MotorolaRadioAssignmentWeb.ConnCase

  alias MotorolaRadioAssignment.{Radio, Repo}
  import Ecto.Query

  def get_max_id() do
    case Repo.one(from r in Radio, select: max(r.id)) do
      nil -> 1
      {id} -> id
    end
  end

  test "Get/post location", %{conn: conn} do
    max_id = get_max_id()

    conn = post(conn, "/radios/#{max_id+1}", ["alias": "Radio100", allowed_locations: ["CPH-1", "CPH-3"]])
    assert response(conn, 200) =~ ""

    conn = post(conn, "/radios/#{max_id+1}/location", [location: "CPH-1"])
    assert response(conn, 200) =~ ""

    conn = get(conn, "/radios/#{max_id+1}/location")
    assert json_response(conn, 200)["location"] == "CPH-1"
  end

  test "Post an invalid location", %{conn: conn} do
    max_id = get_max_id()

    conn = post(conn, "/radios/#{max_id+1}", ["alias": "Radio100", allowed_locations: ["CPH-1", "CPH-3"]])
    assert response(conn, 200) =~ ""

    conn = post(conn, "/radios/#{max_id+1}/location", [location: "CPH-2"])
    assert response(conn, 403) =~ ""

    conn = get(conn, "/radios/#{max_id+1}/location")
    assert response(conn, 404) =~ ""
  end

  test "Get/post location for inexistent id", %{conn: conn} do
    max_id = get_max_id()

    conn = get(conn, "/radios/#{max_id+1}/location")
    assert response(conn, 404) =~ ""
  end

  test "Get/post location for invalid id", %{conn: conn} do
    conn = get(conn, "/radios/invalid/location")
    assert response(conn, 404) =~ ""
  end

  test "Post location with invalid payoff", %{conn: conn} do
    max_id = get_max_id()

    conn = post(conn, "/radios/#{max_id+1}", ["alias": "Radio100", allowed_locations: ["CPH-1", "CPH-3"]])
    assert response(conn, 200) =~ ""

    conn = post(conn, "/radios/#{max_id+1}/location", [])
    assert response(conn, 400) =~ ""
  end

end
