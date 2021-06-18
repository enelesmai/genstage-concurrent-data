defmodule Tasks.Task do
  use Ecto.Schema

  schema "task" do
    field :payload, :binary
    field :status, :string
  end
end