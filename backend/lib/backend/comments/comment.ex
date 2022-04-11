defmodule Backend.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Accounts.User
  alias Backend.Tasks.Task

  schema "comments" do
    field :content, :string
    belongs_to :created_by_user, User, foreign_key: :created_by_id
    belongs_to :task, Task
    timestamps()
  end

  @fields ~w(id content created_by_id task_id)a

  @doc false
  def changeset(comment, attrs) do
    fields = ~w(content created_by_id task_id)a
    comment
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
