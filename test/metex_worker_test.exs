defmodule Metex.WorkerTest do
  use ExUnit.Case

  setup_all do
    {status, pid} = Metex.Worker.start_link([])
    {:ok, server_pid: pid, status: status}
  end

  test '.start_link', state do
    assert state[:status] == :ok
  end

  test '.get_temperature', state do
    assert Metex.Worker.get_temperature(state[:server_pid], "Sydney") != nil
  end

  test '.get_stats', state do
    assert Metex.Worker.get_stats(state[:server_pid]) != nil
  end

  # test '.stop' do
  #   {:ok, server_pid} = Metex.Worker.start_link([])
  # end
end