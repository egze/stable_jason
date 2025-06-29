defmodule StableJason.EncoderTest do
  use ExUnit.Case, async: true

  doctest StableJason.Encoder

  alias StableJason.Encoder

  describe "encode/2" do
    test "simple map" do
      input = %{c: 3, b: 2, a: 1}

      assert Encoder.encode(input) ==
               {:ok, %Jason.OrderedObject{values: [{"a", 1}, {"b", 2}, {"c", 3}]}}
    end

    test "nested map" do
      input = %{c: 3, b: %{d: 1, a: 1}, a: 1}

      assert Encoder.encode(input) ==
               {:ok,
                %Jason.OrderedObject{
                  values: [
                    {"a", 1},
                    {"b", %Jason.OrderedObject{values: [{"a", 1}, {"d", 1}]}},
                    {"c", 3}
                  ]
                }}
    end

    test "nested map with more complex data types" do
      input = %{c: 3, b: %{d: ~D[2024-01-18], a: 1.5}, a: 1}

      assert Encoder.encode(input) ==
               {:ok,
                %Jason.OrderedObject{
                  values: [
                    {"a", 1},
                    {"b", %Jason.OrderedObject{values: [{"a", 1.5}, {"d", "2024-01-18"}]}},
                    {"c", 3}
                  ]
                }}
    end

    test "simple list" do
      input = [3, 2, 1]

      assert Encoder.encode(input) == {:ok, [3, 2, 1]}
    end

    test "list with map" do
      input = [3, %{a: %{d: 2, f: 3}}, 1]

      assert Encoder.encode(input) ==
               {:ok,
                [
                  3,
                  %Jason.OrderedObject{
                    values: [{"a", %Jason.OrderedObject{values: [{"d", 2}, {"f", 3}]}}]
                  },
                  1
                ]}
    end

    test "using a sorter atom" do
      input = %{a: 5, aa: 4, b: 9, A: 12}

      assert Encoder.encode(input, :desc) ==
               {:ok, %Jason.OrderedObject{values: [{"b", 9}, {"aa", 4}, {"a", 5}, {"A", 12}]}}
    end

    test "using a sorter function" do
      input = %{a: 5, aa: 4, b: 9, A: 12}

      sorter = fn a, b ->
        if String.length(inspect(a)) == String.length(inspect(b)),
          do: a < b,
          else: String.length(inspect(a)) < String.length(inspect(b))
      end

      assert Encoder.encode(input, sorter) ==
               {:ok, %Jason.OrderedObject{values: [{"A", 12}, {"a", 5}, {"b", 9}, {"aa", 4}]}}
    end
  end
end
