defmodule StableJason.Encoder do
  @moduledoc """
    Utilities for encoding Elixir values to a deterministic or stable JSON.
  """

  @doc """
  Generates stable JSON corresponding to `input` using `%Jason.OrderedObject{}` from `Jason`.

  ## Example

      iex> StableJason.Encoder.encode(%{c: 3, b: 2, a: 1})
      {:ok, %Jason.OrderedObject{values: [{"a", 1}, {"b", 2}, {"c", 3}]}}

      iex> StableJason.Encoder.encode(<<0::1>>)
      {:error,
        %Protocol.UndefinedError{
          protocol: Jason.Encoder,
          value: <<0::size(1)>>,
          description: "cannot encode a bitstring to JSON"
        }}
  """
  def encode(input, sorter \\ :asc) do
    case Jason.encode(input) do
      {:ok, result} -> {:ok, encode_stable(result, sorter)}
      {:error, error} -> {:error, error}
    end
  end

  defp encode_stable(input, sorter) when is_binary(input) do
    input
    |> Jason.decode!(%{objects: :ordered_objects})
    |> do_encode_stable(sorter)
  end

  defp do_encode_stable(%Jason.OrderedObject{} = ordered_object, sorter) do
    stable_values =
      for {k, v} <- List.keysort(ordered_object.values, 0, sorter) do
        {k, do_encode_stable(v, sorter)}
      end

    %Jason.OrderedObject{values: stable_values}
  end

  defp do_encode_stable(input, sorter) when is_list(input) do
    input
    |> Enum.map(fn i -> do_encode_stable(i, sorter) end)
  end

  defp do_encode_stable(input, _sorter), do: input
end
