defmodule Day4 do
  @test_path Path.join(~w(data day4 test.txt))
  @data_path Path.join(~w(data day4 input.txt))

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
    cols = Enum.take(list, 1) |> Enum.count() |> Kernel.-(1)

    list
    |> Enum.with_index()
    |> Enum.map(fn {row, row_num} ->
      Enum.zip(String.split(row, "", trim: true), 1..cols)
      |> Enum.map(fn {item, col_num} ->
        {{row_num, col_num}, item}
      end)
    end)
  end
end
