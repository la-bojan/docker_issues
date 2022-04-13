defmodule FrontendWeb.Schemas.Board do
  use Ecto.Schema

  import Ecto.Changeset

  alias FrontendWeb.Schemas.List
  alias FrontendWeb.Schemas.BoardPermission

  @derive {Jason.Encoder,
  only: [
    :id,
    :user_id,
    :name,
    :inserted_at,
    :deleted_at,
    :updated_at
  ]}

  @primary_key false
  schema "boards" do
    field(:id, :integer, primary_key: true)
    field(:user_id, :integer)
    field(:name, :string)

    has_many :lists, List, foreign_key: :board_id, references: :id
    has_many :board_permissions, BoardPermission, foreign_key: :board_id, references: :id

    timestamps(type: :utc_datetime_usec)
    field(:deleted_at, :utc_datetime_usec)


  end

  @schema_fields [
    :id,
    :user_id,
    :name,
    :inserted_at,
    :deleted_at,
    :updated_at
  ]

  def schema_fields, do: @schema_fields


  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @schema_fields)
    |> cast_assoc(:lists)
    |> cast_assoc(:board_permissions)
  end


  defmodule Query do
    defstruct []
  end

  def query_changeset(struct, params \\ %{}) do
    types = %{
      id: :integer,
      user_id: :integer,
      name: :string
    }
    {struct, types}
    |> cast(params, Map.keys(types))
  end

  def create_changeset(struct, params \\ %{}) do
    required = [:name,:user_id]

    struct
    |> cast(params, required)
    |> validate_required(required)
  end

  @update_attrs [
    :id,
    :name
  ]

  def update_attrs, do: @update_attrs

  def update_changeset(struct, params \\ %{}, _update_attrs \\ @update_attrs) do
    types = %{
      name: :string,
      user_id: :integer
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
