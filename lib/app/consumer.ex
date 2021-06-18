defmodule App.Consumer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :whatever)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [{App.Producer, min_demand: 50, max_demand: 100} ]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect({self(), event})
      %{id: id, payload: payload} = event
      {module, function, args} = :erlang.binary_to_term(payload)
      Kernel.apply(module, function, args)
    end

    # As a consumer we never emit events
    {:noreply, [], state}
  end
end