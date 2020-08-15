defmodule MotorolaRadioAssignmentWeb.PageControllerTest do
  use MotorolaRadioAssignmentWeb.ConnCase

  alias MotorolaRadioAssignment.{Radio, Repo}
  import Ecto.Query

  def get_max_id() do
    case Repo.one(from r in Radio, select: max(r.id)) do
      nil -> 1
      {id} -> id
    end
  end

  test "Scenario 1", %{conn: conn} do
    max_id = get_max_id()

    conn = post(conn, "/radios/#{max_id+1}", ["alias": "Radio100", allowed_locations: ["CPH-1", "CPH-2"]])
    assert response(conn, 200) =~ ""

    conn = post(conn, "/radios/#{max_id+2}", ["alias": "Radio101", allowed_locations: ["CPH-1", "CPH-2", "CPH-3"]])
    assert response(conn, 200) =~ ""

    conn = post(conn, "/radios/#{max_id+1}/location", [location: "CPH-1"])
    assert response(conn, 200) =~ ""

    conn = post(conn, "/radios/#{max_id+2}/location", [location: "CPH-3"])
    assert response(conn, 200) =~ ""

    conn = post(conn, "/radios/#{max_id+1}/location", [location: "CPH-3"])
    assert response(conn, 403) =~ ""

    conn = get(conn, "/radios/#{max_id+2}/location")
    assert json_response(conn, 200)["location"] == "CPH-3"

    conn = get(conn, "/radios/#{max_id+1}/location")
    assert json_response(conn, 200)["location"] == "CPH-1"
  end

  test "Scenario 2", %{conn: conn} do
    max_id = get_max_id()

    conn = post(conn, "/radios/#{max_id+1}", ["alias": "Radio102", allowed_locations: ["CPH-1", "CPH-3"]])
    assert response(conn, 200) =~ ""

    conn = get(conn, "/radios/#{max_id+1}/location")
    assert response(conn, 404) == ""
  end

end
