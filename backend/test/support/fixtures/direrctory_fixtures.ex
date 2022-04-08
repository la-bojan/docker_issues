defmodule Backend.DirerctoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Direrctory` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{
        descritprion: "some descritprion",
        name: "some name",
        tag: "some tag"
      })
      |> Backend.Direrctory.create_board()

    board
  end
end
