defmodule Day1 do
  @test_path Path.join(~w(data day1 test.txt))
  @data_path Path.join(~w(data day1 input.txt))

  def solve_one(which_file) do
    which_file
    |> read_data()
    |> sort_lists()
    |> abs_diff()
    |> Enum.sum()
  end

  def solve_two(which_file) do
    {l1, l2} = read_data(which_file)

    multiplier_lookup =
      Enum.reduce(l2, %{}, fn e, acc ->
        Map.update(acc, e, 1, &(&1 + 1))
      end)

    Enum.reduce(l1, 0, fn e, acc ->
      acc + e * Map.get(multiplier_lookup, e, 0)
    end)
  end

  def read_data(which_file) do
    file_path =
      case which_file do
        :test -> @test_path
        :data -> @data_path
      end

    file_path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn string_in ->
      string_in
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.unzip()
  end

  def sort_lists({l1, l2}) do
    {Enum.sort(l1), Enum.sort(l2)}
  end

  def abs_diff(data) do
    data
    |> Tuple.to_list()
    |> Enum.zip_with(fn [x, y] ->
      abs(x - y)
    end)
  end
end
