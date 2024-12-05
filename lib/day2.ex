defmodule Day2 do
  @test_path Path.join(~w(data day2 test.txt))
  @data_path Path.join(~w(data day2 input.txt))

  def solve_one(which_file) do
    which_file
    |> read_input()
    |> Enum.filter(&((all_decreasing?(&1) or all_increasing?(&1)) and safe_diff?(&1)))
    |> Enum.count()
  end

  def solve_two(which_file) do
    which_file
    |> read_input()
    |> Enum.map(&dampen/1)
    |> Enum.map(fn dampened_readings ->
      Enum.any?(dampened_readings, &vaild_reading?/1)
    end)
    |> Enum.count(& &1)
  end

  def read_input(which_file) do
    file_path =
      case which_file do
        :test -> @test_path
        :data -> @data_path
      end

    file_path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def vaild_reading?(reading) do
    (all_decreasing?(reading) or all_increasing?(reading)) and safe_diff?(reading)
  end

  def dampen(reading) do
    indexed = Enum.with_index(reading)

    with_deleted =
      for x <- indexed do
        indexed
        |> Enum.reject(&(&1 == x))
        |> Enum.map(fn {v, _i} -> v end)
      end

    [reading | with_deleted]
  end

  def safe_diff?(reading) do
    reading
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [l, r] -> abs(l - r) in 1..3 end)
  end

  def all_increasing?(reading) do
    reading
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [l, r] -> r > l end)
  end

  def all_decreasing?(reading) do
    reading
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [l, r] -> r < l end)
  end
end
