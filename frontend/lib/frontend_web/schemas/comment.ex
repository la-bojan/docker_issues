defmodule FrontendWeb.Schemas.Comment do
  use Ecto.Schema

  import Ecto.Changeset
  alias FrontendWeb.Schemas.User

  @derive {Jason.Encoder,
  only: [
    :id,
    :created_by_id,
    :task_id,
    :content,
    :inserted_at,
    :deleted_at,
    :updated_at
  ]}

  @primary_key false
  schema "comments" do
    field(:id, :integer, primary_key: true)
    field(:task_id, :integer)
    field(:content, :string)

    belongs_to :user, User, foreign_key: :created_by_id, type: :integer

    timestamps(type: :utc_datetime_usec)
    field(:deleted_at, :utc_datetime_usec)


  end

  @schema_fields [
    :id,
    :created_by_id,
    :task_id,
    :content,
    :inserted_at,
    :deleted_at,
    :updated_at
  ]

  def schema_fields, do: @schema_fields


  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @schema_fields)
    |> cast_assoc(:user)
  end


  defmodule Query do
    defstruct []
  end

  def query_changeset(struct, params \\ %{}) do
    types = %{
      content: :string,
      task_id: :integer
    }
    {struct, types}
    |> cast(params, Map.keys(types))
  end

  def create_changeset(struct, params \\ %{}) do
    required = [:content,:created_by_id,:task_id]

    struct
    |> cast(params, required)
    |> validate_required(required)
  end


  @delete_attrs [
    :id
  ]

  def delete_attrs, do: @delete_attrs

  def delete_changeset(struct, params \\ %{}, _update_attrs \\ @delete_attrs) do
    types = %{
      id: :integer
    }

    {struct, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:id])
  end


end
