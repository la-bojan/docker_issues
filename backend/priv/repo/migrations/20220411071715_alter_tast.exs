defmodule Backend.Repo.Migrations.AlterTast do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add(:position, :decimal)
    end
  end
end
