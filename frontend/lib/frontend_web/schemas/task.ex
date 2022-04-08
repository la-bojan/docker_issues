defmodule FrontendWeb.Schemas.Task do
  use Ecto.Schema

  alias FrontendWeb.Schemas.List

  import Ecto.Changeset

  @derive {Jason.Encoder,
  only: [
    :id,
    :title,
    :description,
    :list_id,
    :inserted_at,
    :updated_at
  ]}

  @primary_key false
  schema "tasks" do
    field(:id, :integer, primary_key: true)
    field(:title, :string)
    field(:description, :string)

    belongs_to :list, List, type: :integer

    timestamps(type: :utc_datetime_usec)
  end

  @schema_fields [
    :id,
    :title,
    :description,
    :list_id,
    :inserted_at,
    :updated_at
  ]

  def schema_fields, do: @schema_fields

  def changeset(struct, params \\ %{}), do: cast(struct, params, @schema_fields)

  defmodule Query do
    defstruct []
  end

  def query_changeset(struct, params \\ %{}) do
    types = %{
      id: :integer,
      list_id: :integer
    }
    {struct, types}
    |> cast(params, Map.keys(types))
  end

  def create_changeset(struct, params \\ %{}) do
    required = [:title,:list_id]
    optional = [:description]

    struct
    |> cast(params, required ++ optional)
    |> validate_required(required)
  end

  @update_attrs [
    :title,
    :description,
    :list_id
  ]

  def update_attrs, do: @update_attrs

  def update_changeset(struct, params \\ %{}, _update_attrs \\ @update_attrs) do
    types = %{
      title: :string,
      list_id: :integer,
      id: :integer,
      description: :boolean
    }

    {struct, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:id])
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
