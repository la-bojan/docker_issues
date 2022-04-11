defmodule FrontendWeb.Schemas.Comment do
  use Ecto.Schema

  import Ecto.Changeset


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
    field(:created_by_id, :integer)
    field(:content, :string)


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
  end


  defmodule Query do
    defstruct []
  end

  def query_changeset(struct, params \\ %{}) do
    types = %{
      content: :string
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
