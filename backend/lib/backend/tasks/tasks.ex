defmodule Backend.Tasks.Tasks do

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Tasks.Item
  alias Backend.Tasks.List

  def list_tasks do
    Repo.all(Item)
  end

  def get_item!(id), do: Repo.get!(Item, id)

  def all_list_tasks(list_id) do
    query =
      from l in Item,
        where: l.list_id == ^list_id
    Repo.all(query)

  end

  def all_board_tasks(board_id, preload) do
    query =
      from t in Item,
        where: t.board_id == ^board_id,
        preload: ^preload
    Repo.all(query)
    |> Repo.preload(preload)
  end

  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

end
