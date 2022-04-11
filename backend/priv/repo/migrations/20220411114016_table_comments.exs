defmodule Backend.Repo.Migrations.TableComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :task_id, references(:tasks, on_delete: :delete_all)
      add :created_by_id, references(:users, on_delete: :nothing)

      timestamps()
      end

    create index(:comments, [:task_id])
    create index(:comments, [:created_by_id])
  end
end
