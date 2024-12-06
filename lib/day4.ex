defmodule Day4 do
  @test_path Path.join(~w(data day4 test.txt))
  @data_path Path.join(~w(data day4 input.txt))

  def solve_one(file_type) do
    file_type
    |> read_input()
    |> create_grid()
    |> star_vals(3)
    |> filter_winners("XMAS")
    |> Enum.count()
  end

  def solve_two(file_type) do
    file_type
    |> read_input()
    |> create_grid()
    |> x_vals(1)
    |> filter_winners_two("MAS")
    |> Enum.count()
  end

  def read_input(file_type) do
    file_name =
      case file_type do
        :test -> @test_path
        :data -> @data_path
      end

    File.read!(file_name)
    |> String.split("\n", trim: true)
  end

  def create_grid(list) do
    list
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_num} ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, col} ->
        {{row_num, col}, char}
      end)
    end)
    |> Enum.into(%{})
  end

  def filter_winners(list, winning_value) do
    list
    |> Enum.filter(&(&1 == winning_value))
  end

  def filter_winners_two(list, winning_value) do
    list
    |> Enum.chunk_every(2)
    |> Enum.filter(fn [d1, d2] ->
      (d1 == winning_value or String.reverse(d1) == winning_value) and
        (d2 == winning_value or String.reverse(d2) == winning_value)
    end)
  end

  def star_vals(board, length) do
    board
    |> Map.keys()
    |> Enum.flat_map(&star_coords(&1, length, fn coord -> !Map.has_key?(board, coord) end))
    |> Enum.map(fn coords ->
      Enum.map_join(coords, &Map.get(board, &1))
    end)
  end

  def x_vals(board, length) do
    board
    |> Enum.flat_map(fn {k, v} ->
      if v == "A", do: [k], else: []
    end)
    |> Enum.flat_map(&diag_coords(&1, length, fn coord -> !Map.has_key?(board, coord) end))
    |> Enum.map(fn coords ->
      Enum.map_join(coords, &Map.get(board, &1))
    end)
  end

  def star_coords(center, length, oob_func \\ fn _ -> false end) do
    vecs = for x <- -1..1, y <- -1..1, x != 0 or y != 0, do: {x, y}

    for vec <- vecs,
        step <- 0..length,
        pot_coord = add_coord(center, mult_coord(vec, step)) do
      pot_coord
    end
    |> Enum.chunk_every(length + 1)
    |> Enum.reject(fn coord_list ->
      Enum.any?(coord_list, oob_func)
    end)
  end

  def diag_coords(center, length, oob_func \\ fn _ -> false end) do
    vecs = [{1, 1}, {1, -1}]

    for vec <- vecs,
        step <- -1..length,
        pot_coord = add_coord(center, mult_coord(vec, step)) do
      pot_coord
    end
    |> Enum.chunk_every(length + 2)
    |> Enum.reject(fn coord_list ->
      Enum.any?(coord_list, oob_func)
    end)
  end

  def add_coord({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  def mult_coord({x1, y1}, scalar), do: {scalar * x1, scalar * y1}
end
