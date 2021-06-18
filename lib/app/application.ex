defmodule App.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    import Supervisor.Spec, warn: false
    # List all child processes to be supervised
    children = [
      Tasks.Repo,
      worker(App.Producer, []),
    ]

    consumers = 
      for id <- 1..1 do
        worker(App.Consumer, [], id: id)
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children ++  consumers, opts)
  end

  def start_later(module, function, args) do
    payload = {module, function, args} |> :erlang.term_to_binary
    Tasks.Repo.insert_all "tasks", [
      %{status: "waiting", payload: payload}
    ]
    send App.Producer, :yo_you_have_data
  end

end
