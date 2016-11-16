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

  test '.get_temperature' do
    assert Metex.Worker.get_temperature("Sydney") != nil
  end

  test '.get_stats' do
    assert Metex.Worker.get_stats == %{}

    Metex.Worker.get_temperature("Sydney")
    assert Metex.Worker.get_stats == %{"Sydney" => 1}

    Metex.Worker.get_temperature("Sydney")
    assert Metex.Worker.get_stats == %{"Sydney" => 2}

    Metex.Worker.get_temperature("Singapore")
    assert Metex.Worker.get_stats == %{"Sydney" => 2, "Singapore" => 1}
  end

  test '.stop', state do
    assert true == Process.alive?(state[:server_pid])
    Metex.Worker.stop

    # can't test because stop is async
    # assert false == Process.alive?(state[:server_pid])
  end
end