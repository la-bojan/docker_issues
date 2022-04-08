defmodule FrontendWeb.Api.Users do
  alias Ecto.Changeset

  alias FrontendWeb.Schemas.User

  @success_codes 200..399

  def all_users(params) do
    url = "/api/users"


    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- User.query_changeset(%User.Query{}, params),
         query =
           changeset
           |> Changeset.apply_changes()
           |> Map.from_struct(),
           client = client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
         Tesla.get(client, url, body: query) do
      {:ok, Enum.map(body, &from_response/1)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end


  def get_user(params) do
    url = "/api/users/:id"


    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- User.query_changeset(%User.Query{}, params),
         user = Changeset.apply_changes(changeset),
         query =
           changeset
           |> Changeset.apply_changes()
           |> Map.from_struct(),
          client = client(access_token),
          path_params = Map.take(query, [:id]),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
         Tesla.get(client, url, query: query,opts: [path_params: path_params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def create_user(params) do
    url = "/api/users/signup"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- User.create_changeset(%User{}, params),
         user <- Changeset.apply_changes(changeset),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.post(client, url, user) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end


  def signin_user(params) do
    url = "/api/users/signin"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- User.create_changeset(%User{}, params),
         user <- Changeset.apply_changes(changeset),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.post(client, url, user) do
      {:ok, body}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end



  def delete_user(params) do
    url = "/api/users/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- User.delete_changeset(%User{}, params),
         user = Changeset.apply_changes(changeset),
         client = client(access_token),
         path_params = Map.take(user, [:id]),
         {:ok, %{status: status}} when status in @success_codes <-
           Tesla.delete(client, url, opts: [path_params: path_params]) do
      {:ok, nil}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end


  def update_user(user, params, attrs \\ nil) do
    url = "/api/users/:id"
    {access_token, params} = Map.pop(params, "access_token")
    attrs = attrs || User.update_attrs()

    with %{valid?: true} <- User.update_changeset(user, params, attrs),
         path_params <- Map.take(user, [:id]),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.patch(client, url, params, opts: [path_params: path_params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp client(access_token) do
    url = "http://backend:4001"

    middlewares = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON,
      Tesla.Middleware.PathParams,
      Tesla.Middleware.Logger
    ]

    Tesla.client(middlewares)
  end

  defp from_response(response),
    do: %User{} |> User.changeset(response) |> Changeset.apply_changes()
end
