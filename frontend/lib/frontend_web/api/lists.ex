defmodule FrontendWeb.Api.Lists do
  alias Ecto.Changeset

  alias FrontendWeb.Schemas.List

  @success_codes 200..399

  def all_lists(params) do
    url = "/api/lists"


    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- List.query_changeset(%List.Query{}, params),
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


  def create_list(params) do
    url = "/api/lists"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- List.create_changeset(%List{}, params),
         list <- Changeset.apply_changes(changeset),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.post(client, url, list) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def delete_list(params) do
    url = "/api/lists/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- List.delete_changeset(%List{}, params),
         list = Changeset.apply_changes(changeset),
         client = client(access_token),
         path_params = Map.take(list, [:id]),
         {:ok, %{status: status}} when status in @success_codes <-
           Tesla.delete(client, url, opts: [path_params: path_params]) do
      {:ok, nil}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end


  def update_list(list, params, attrs \\ nil) do
    url = "/api/lists/:id"
    {access_token, params} = Map.pop(params, "access_token")
    attrs = attrs || List.update_attrs()

    with %{valid?: true} <- List.update_changeset(list, params, attrs),
         path_params <- Map.take(list, [:id]),
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
    do: %List{} |> List.changeset(response) |> Changeset.apply_changes()
end
