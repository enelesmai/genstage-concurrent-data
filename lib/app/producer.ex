defmodule App.Producer do
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    #0..4 => 0, 1, 2, 3, 4 => 5
    #5..9 => 5, 6, 7, 8, 9 => 5
    events = Enum.to_list(state..(state + demand - 1))
    {:noreply, events, state + demand}
  end
end