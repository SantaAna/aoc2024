defmodule Day3 do
  @test_path Path.join(~w(data day3 test.txt))
  @data_path Path.join(~w(data day3 input.txt))

  def solve_part_one(file_type) do
    stream_input(file_type)
    |> extract_operations()
    |> Enum.sum()
  end

  def solve_part_two(file_type) do
    stream_input(file_type)
    |> extract_ops_and_stops()
    |> sum_with_stops()
  end

  def stream_input(file_type) do
    file_name =
      case file_type do
        :test -> @test_path
        :data -> @data_path
      end

    File.stream!(file_name)
  end

  def extract_operations(stream) do
    stream
    |> Stream.flat_map(fn line ->
      Regex.scan(~r/(mul\((\d+),(\d+)\))|(do\(\))|(don't\(\))/, line)
      |> Enum.map(fn [_, x, y] ->
        String.to_integer(x) * String.to_integer(y)
      end)
    end)
  end

  def extract_ops_and_stops(stream) do
    stream
    |> Stream.flat_map(fn line ->
      Regex.scan(
        ~r/(mul\((\d+),(\d+)\))|(do\(\))|(don't\(\))/,
        line
      )
      |> Enum.map(fn match ->
        case match do
          [_, _, x, y] ->
            String.to_integer(x) * String.to_integer(y)

          ["don't()", _, _, _, _, _] ->
            :stop

          ["do()", _, _, _, _] ->
            :start
        end
      end)
    end)
  end

  def sum_with_stops(input_list) do
    Enum.reduce(input_list, {0, :start}, fn
      :start, {sum, :stop} -> {sum, :start}
      :stop, {sum, :start} -> {sum, :stop}
      x, {sum, :stop} when is_integer(x) -> {sum, :stop}
      x, {sum, :start} when is_integer(x) -> {x + sum, :start}
      _, acc -> acc
    end)
    |> elem(0)
  end
end
