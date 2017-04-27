defmodule Metex.WorkerTest do
  use ExUnit.Case, async: true
  import Metex.Worker, only: [get_temperature: 1, get_stats: 0, start_link: 1, stop: 0, handle_call: 3]

  setup do
    {status, pid} = start_link([])
    # Note: setup expects to return {:ok, state}
    {:ok, server_pid: pid, status: status}
  end

  test '.start_link', state do
    assert state[:status] == :ok
  end

  test '.get_temperature' do
    assert get_temperature("Sydney") != nil
  end

  test '.get_stats' do
    assert get_stats() == %{}

    get_temperature("Sydney")
    assert get_stats() == %{"Sydney" => 1}

    get_temperature("Sydney")
    assert get_stats() == %{"Sydney" => 2}

    get_temperature("Singapore")
    assert get_stats() == %{"Sydney" => 2, "Singapore" => 1}
  end

  test '.stop', state do
    assert true == Process.alive?(state[:server_pid])
    stop()

    # can't test because stop is async
    # assert false == Process.alive?(state[:server_pid])
  end

  # these tests do not require the server, compare with the tests that
  # require start link above
  test 'handle get_stats' do
    {:reply, _stats, stats} = handle_call(:get_stats, 1, %{})
    assert stats == %{}

    {:reply, _stats, stats} = handle_call(:get_stats, 1, %{"Sydney" => 1})
    assert stats == %{"Sydney" => 1}

  end

  test 'handle location' do
    {:reply, _temp, stats} = handle_call({:location, "Sydney"}, nil, %{})
    assert stats == %{"Sydney" => 1}

    {:reply, _temp, stats} = handle_call({:location, "Sydney"}, nil, %{"Sydney" => 1, "Kuala Lumpur" => 1})
    assert stats == %{"Sydney" => 2, "Kuala Lumpur" => 1}
  end
end