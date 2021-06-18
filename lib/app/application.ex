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
      for id <- 1..(System.schedulers_online * 2) do
        worker(App.Consumer, [], id: id)
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children ++  consumers, opts)
  end
end
