defmodule App.Consumer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :whatever)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [App.Producer]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect({self(), event})
    end

    # As a consumer we never emit events
    {:noreply, [], state}
  end
end