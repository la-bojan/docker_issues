defmodule Backend.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :text
      add :list_id, references(:lists, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:list_id])
  end
end
