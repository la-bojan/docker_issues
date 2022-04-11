defmodule Backend.Repo.Migrations.AlterListAddPosition do
  use Ecto.Migration

  def change do
    alter table("lists") do
      add(:position, :decimal)
    end
  end
end
