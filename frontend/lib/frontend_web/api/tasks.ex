defmodule FrontendWeb.Api.Tasks do
  alias Ecto.Changeset

  alias FrontendWeb.Schemas.Task

  @success_codes 200..399

  def all_tasks(params) do
    url = "/api/tasks"


    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Task.query_changeset(%Task.Query{}, params),
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


  def create_task(params) do
    url = "/api/tasks"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Task.create_changeset(%Task{}, params),
         task <- Changeset.apply_changes(changeset),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.post(client, url, task) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def get_task(params) do
    url = "/api/tasks/:id"


    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Task.query_changeset(%Task.Query{}, params),
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

  def delete_task!(params) do
    url = "/api/tasks/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Task.delete_changeset(%Task{}, params),
         task = Changeset.apply_changes(changeset),
         client = client(access_token),
         path_params = Map.take(task, [:id]),
         {:ok, %{status: status}} when status in @success_codes <-
           Tesla.delete(client, url, opts: [path_params: path_params]) do
      {:ok, nil}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end


  def update_task(task, params, attrs \\ nil) do
    url = "/api/tasks/:id"
    {access_token, params} = Map.pop(params, "access_token")
    attrs = attrs || Task.update_attrs()

    with %{valid?: true} <- Task.update_changeset(task, params, attrs),
         path_params <- Map.take(task, [:id]),
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
    do: %Task{} |> Task.changeset(response) |> Changeset.apply_changes()
end
