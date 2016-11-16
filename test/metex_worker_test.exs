defmodule Metex.WorkerTest do
  use ExUnit.Case, async: true

  setup do
    {status, pid} = Metex.Worker.start_link([])
    # Note: setup expects to return {:ok, state}
    {:ok, server_pid: pid, status: status}
  end

  test '.start_link', state do
    assert state[:status] == :ok
  end

  test '.get_temperature', state do
    assert Metex.Worker.get_temperature(state[:server_pid], "Sydney") != nil
  end

  test '.get_stats', state do
    assert Metex.Worker.get_stats(state[:server_pid]) == %{}

    Metex.Worker.get_temperature(state[:server_pid], "Sydney")
    assert Metex.Worker.get_stats(state[:server_pid]) == %{"Sydney" => 1}

    Metex.Worker.get_temperature(state[:server_pid], "Sydney")
    assert Metex.Worker.get_stats(state[:server_pid]) == %{"Sydney" => 2}

    Metex.Worker.get_temperature(state[:server_pid], "Singapore")
    assert Metex.Worker.get_stats(state[:server_pid]) == %{"Sydney" => 2, "Singapore" => 1}
  end

  # test '.stop' do
  #   {:ok, server_pid} = Metex.Worker.start_link([])
  # end
end