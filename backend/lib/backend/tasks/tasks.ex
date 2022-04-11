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
    case Map.pop(attrs, "list_id")  do
      {list_id, _} when not is_nil(list_id) ->
        position = get_last_position(list_id)
        %Item{}
        |> Item.changeset(Map.merge(attrs, %{"position" => position}))
        |> Repo.insert()

      _ ->
        %Item{}
        |> Item.changeset(attrs)
        |> Changeset.apply_changes
    end
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

  def get_last_position(list_id) do
    query =
      from t in Item,
        where: t.list_id == ^list_id,
        select: max(t.position)

    Repo.one(query)
    |> Kernel.||(0)
    |> Decimal.add(1)
  end

end
