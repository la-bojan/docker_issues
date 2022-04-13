defmodule Backend.Repo.Migrations.AddTaskAssignee do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :assignee_id, references(:users, on_delete: :nothing)
    end
  end
end
