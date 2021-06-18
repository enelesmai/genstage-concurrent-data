defmodule Tasks.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table (:tasks) do
      add :payload, :binary
      add :status, :string
    end
  end
end
