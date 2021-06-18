defmodule App.Producer do
  use GenStage

  import Ecto.Query, only: [from: 2]
  alias Tasks.Repo

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter) do
     {:producer, counter}
  end

  def handle_demand(demand, state) when demand > 0 do
    limit = demand - state
    {:ok, {count, events}} = take(limit)
    {:noreply, events, limit - count}
  end

  def handle_info(:yo_you_have_data, state) do
    limit = state
    {:ok, {count, events}} = take(limit)
    {:noreply, events, limit - count}
  end

  defp take(limit) do
    Repo.transaction fn -> 
      ids = Repo.all waiting(limit)
      {count, events} = Repo.update_all by_ids(ids),
            [set: [status: "running"]],
            [returning: [:id, :payload]]

      {count, events || []}
    end
  end

  defp by_ids(ids) do
    from t in "tasks", where: t.id in ^ids
  end

  defp waiting(limit) do
    from t in "tasks",
     where: t.status == "waiting",
     limit: ^limit,
     select: t.id,
     lock: "FOR UPDATE SKIP LOCKED"
  end

end