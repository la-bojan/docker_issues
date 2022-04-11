defmodule Backend.Repo.Migrations.TableBoardPermmisions do
  use Ecto.Migration

  def change do
    create table(:board_permissions) do
      add :permission_type, :string
      add :board_id, references(:boards, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:board_permissions, [:board_id])
    create index(:board_permissions, [:user_id])
    create unique_index(:board_permissions, [:board_id, :user_id], name: :unique_user_permission)
  end
end
