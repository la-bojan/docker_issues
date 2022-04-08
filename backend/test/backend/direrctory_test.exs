defmodule Backend.DirerctoryTest do
  use Backend.DataCase

  alias Backend.Direrctory

  describe "boards" do
    alias Backend.Direrctory.Board

    import Backend.DirerctoryFixtures

    @invalid_attrs %{descritprion: nil, name: nil, tag: nil}

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Direrctory.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Direrctory.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      valid_attrs = %{descritprion: "some descritprion", name: "some name", tag: "some tag"}

      assert {:ok, %Board{} = board} = Direrctory.create_board(valid_attrs)
      assert board.descritprion == "some descritprion"
      assert board.name == "some name"
      assert board.tag == "some tag"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Direrctory.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      update_attrs = %{descritprion: "some updated descritprion", name: "some updated name", tag: "some updated tag"}

      assert {:ok, %Board{} = board} = Direrctory.update_board(board, update_attrs)
      assert board.descritprion == "some updated descritprion"
      assert board.name == "some updated name"
      assert board.tag == "some updated tag"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Direrctory.update_board(board, @invalid_attrs)
      assert board == Direrctory.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Direrctory.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Direrctory.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Direrctory.change_board(board)
    end
  end
end
