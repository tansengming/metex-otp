defmodule Metex.Worker do
  use GenServer

  # client
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  # server
  def init(:ok) do
    {:ok, %{}}
  end

  # where does stats come from??
  def handle_call({:location, location}, _from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp}C", new_stats}
      _ ->
        {:reply, :error, stats}
    end
  end

  # Helpers
  defp update_stats(stats, location) do
    stats |> Map.update(location, 1, &(&1 + 1))    
  end

  defp temperature_of(location) do
    url_for(location) |> HTTPoison.get |> parse_response
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey}"
  end

  defp apikey do
    "key"
  end
end