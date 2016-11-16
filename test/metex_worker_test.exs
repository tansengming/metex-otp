defmodule Metex.WorkerTest do
  use ExUnit.Case

  test '.start_link' do
    {status, _pid} = Metex.Worker.start_link([])

    assert status == :ok
  end

  test '.get_temperature' do
    {:ok, server_pid} = Metex.Worker.start_link([])
    {status, _pid}    = Metex.Worker.get_temperature(server_pid, "Sydney")

    assert status == :reply
  end
end