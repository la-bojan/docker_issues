defmodule Backend.Tasks.Item do
  use Ecto.Schema
  import Ecto.Changeset


  alias Backend.Comments.Comment

  schema "tasks" do
    field :description, :string
    field :title, :string
    field :list_id, :id
    field :position, :decimal

    has_many :tasks, Comment

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description,:list_id,:position])
    |> validate_required([:title, :description])
  end
end
