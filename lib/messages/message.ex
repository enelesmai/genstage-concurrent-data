defmodule Messages.Message do
  use Ecto.Schema

  schema "message" do
    field :title, :string
    field :message, :string
  end
end