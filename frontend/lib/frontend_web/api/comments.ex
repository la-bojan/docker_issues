defmodule FrontendWeb.Api.Lists do
  alias Ecto.Changeset

  alias FrontendWeb.Schemas.Comment

  @success_codes 200..399


  def get_comments(params) do
    url = "/api/tasks/:id/comments"


    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Comment.query_changeset(%Comment.Query{}, params),
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

  def create_comment(params) do
    url = "/api/comments"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Comment.create_changeset(%Comment{}, params),
         comment <- Changeset.apply_changes(changeset),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.post(client, url, comment) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def delete_comment(params) do
    url = "/api/comments/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Comment.delete_changeset(%Comment{}, params),
         comment = Changeset.apply_changes(changeset),
         client = client(access_token),
         path_params = Map.take(comment, [:id]),
         {:ok, %{status: status}} when status in @success_codes <-
           Tesla.delete(client, url, opts: [path_params: path_params]) do
      {:ok, nil}
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
    do: %Comment{} |> Comment.changeset(response) |> Changeset.apply_changes()
end
