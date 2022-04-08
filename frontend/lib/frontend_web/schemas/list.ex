defmodule FrontendWeb.Schemas.List do
  use Ecto.Schema

  import Ecto.Changeset

  alias FrontendWeb.Schemas.Task

  @derive {Jason.Encoder,
  only: [
    :id,
    :board_id,
    :title,
    :inserted_at,
    :deleted_at,
    :updated_at
  ]}

  @primary_key false
  schema "lists" do
    field(:id, :integer, primary_key: true)
    field(:board_id, :integer)
    field(:title, :string)

    has_many :tasks, Task, foreign_key: :list_id, references: :id

    timestamps(type: :utc_datetime_usec)
    field(:deleted_at, :utc_datetime_usec)


  end

  @schema_fields [
    :id,
    :board_id,
    :title,
    :inserted_at,
    :deleted_at,
    :updated_at
  ]

  def schema_fields, do: @schema_fields


  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @schema_fields)
    |> cast_assoc(:tasks)
  end


  defmodule Query do
    defstruct []
  end

  def query_changeset(struct, params \\ %{}) do
    types = %{
      board_id: :integer,
      title: :string
    }
    {struct, types}
    |> cast(params, Map.keys(types))
  end

  def create_changeset(struct, params \\ %{}) do
    required = [:title,:board_id]

    struct
    |> cast(params, required)
    |> validate_required(required)
  end

  @update_attrs [
    :board_id,
    :title
  ]

  def update_attrs, do: @update_attrs

  def update_changeset(struct, params \\ %{}, _update_attrs \\ @update_attrs) do
    types = %{
      title: :string,
      board_id: :integer
    }

    {struct, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:list_id])
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
