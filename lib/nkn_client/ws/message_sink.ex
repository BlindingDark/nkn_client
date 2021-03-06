defmodule NknClient.WS.MessageSink do
  use GenStage
  require Logger

  def start_link([]) do
    GenStage.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def handle(msg) do
    GenStage.cast(__MODULE__, {:handle, msg})
  end

  def init(nil) do
    {:producer, {:queue.new, 0}, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_cast({:handle, msg}, {queue, demand}) do
    dispatch_events(:queue.in(msg, queue), demand, [])
  end

  def handle_demand(incoming_demand, {queue, demand}) do
    dispatch_events(queue, incoming_demand + demand, [])
  end

  defp dispatch_events(queue, demand, events) do
    with d when d > 0 <- demand,
    {{:value, event}, queue} <- :queue.out(queue) do
      dispatch_events(queue, demand - 1, [event | events])
    else
      _ -> {:noreply, Enum.reverse(events), {queue, demand}}      
    end
  end
end
