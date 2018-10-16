defmodule NknClient.RPC.Client do
  alias JSONRPC2.Clients.HTTP

  #@default_url "http://testnet-node-0001.nkn.org:30003"
  @default_url "http://sia.anoncat.com:30003"

  def get_ws_address() do
    case Application.get_env(:nkn_client, :rpc_url) do
      nil -> get_host(@default_url)
      url -> get_host(url)
    end
  end

  defp get_host(url) do
        {:ok, host} = HTTP.call(url, "getwsaddr",
                                %{"address" => "#{NknClient.Crypto.address()}"})
        host
  end
end
