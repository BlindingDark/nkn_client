defmodule NknClient.WS.Client do
  use WebSockex
  require Logger

  def start_link(url) do
    WebSockex.start_link(url, __MODULE__, url, name: __MODULE__)
  end

  def send(msg) do
    Logger.debug("Sending: #{inspect(msg)}")
    WebSockex.send_frame(__MODULE__, msg)
  end

  def handle_connect(_conn, state) do
    Logger.info("Connected to #{state}")
    {:ok, state}
  end

  def handle_frame(msg, state) do
    Logger.debug("Msg: #{inspect(msg)}")
    {:ok, state}
  end

  def handle_disconnect(reason, state) do
    Logger.info("Disconnected: #{inspect(reason)}")
    {:ok, state}
  end
end
