defmodule StableJason do
  @moduledoc """
  Encoder of Elixir values to a stable JSON.
  """

  alias StableJason.Encoder

  @doc """
  Generates stable JSON corresponding to `input`.

  `opts` are the same as `Jason.encode/2`.

  ## Example

      iex> StableJason.encode(%{c: 3, b: 2, a: 1})
      {:ok, ~S|{"a":1,"b":2,"c":3}|}

      iex> StableJason.encode(<<0::1>>)
      {:error,
        %Protocol.UndefinedError{
          protocol: Jason.Encoder,
          value: <<0::size(1)>>,
          description: "cannot encode a bitstring to JSON"
        }}
  """
  def encode(input, opts \\ []) do
    case Encoder.encode(input) do
      {:ok, result} -> Jason.encode(result, opts)
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Generates stable JSON corresponding to `input`.

  Similar to `encode/2` except it will unwrap the error tuple and raise
  in case of errors.

  ## Examples

      iex> StableJason.encode!(%{a: 1})
      ~S|{"a":1}|

      iex> StableJason.encode!("\\xFF")
      ** (Jason.EncodeError) invalid byte 0xFF in <<255>>

  """
  def encode!(input, opts \\ []) do
    case Encoder.encode(input) do
      {:ok, result} -> Jason.encode!(result, opts)
      {:error, error} -> raise error
    end
  end
end
