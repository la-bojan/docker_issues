defmodule FrontendWeb.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias FrontendWeb.Schemas.Board
  alias FrontendWeb.Schemas.Task

  @derive {Jason.Encoder,
  only: [
    :id,
    :email,
    :password,
    :inserted_at,
    :deleted_at,
    :updated_at
  ]}

  @primary_key false
  schema "users" do
    field(:id, :integer, primary_key: true)
    field(:email, :string)
    field(:password, :string)

    has_many :boards, Board, foreign_key: :user_id, references: :id
    has_many :assigned_tasks, Task, foreign_key: :assignee_id, references: :id

    timestamps(type: :utc_datetime_usec)
    field(:deleted_at, :utc_datetime_usec)


  end

  @schema_fields [
    :id,
    :email,
    :password,
    :inserted_at,
    :deleted_at,
    :updated_at
  ]

  def schema_fields, do: @schema_fields


  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @schema_fields)
    |> cast_assoc(:boards)
  end


  defmodule Query do
    defstruct []
  end

  def query_changeset(struct, params \\ %{}) do
    types = %{
      id: :integer,
      email: :string
    }
    {struct, types}
    |> cast(params, Map.keys(types))
  end

  def create_changeset(struct, params \\ %{}) do
    required = [:email,:password]

    struct
    |> cast(params, required)
    |> validate_required(required)
  end

  @update_attrs [
    :id,
    :email
  ]

  def update_attrs, do: @update_attrs

  def update_changeset(struct, params \\ %{}, _update_attrs \\ @update_attrs) do
    types = %{
      email: :string,
      board_id: :integer
    }

    {struct, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:id])
  end


end
