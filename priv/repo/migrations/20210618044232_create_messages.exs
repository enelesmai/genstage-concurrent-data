defmodule Messages.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:message) do
      add :title, :string, null: false
      add :message, :string
    end
  end
end
