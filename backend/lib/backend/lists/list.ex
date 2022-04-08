defmodule Backend.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Tasks.Item

  schema "lists" do
    field :title, :string
    field :board_id, :id

    has_many :tasks, Item

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title,:board_id])
    |> cast_assoc(:tasks, with: &Item.changeset/2)
    |> validate_required([:title])
  end
end
