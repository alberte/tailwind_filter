defmodule TailwindFilter do
  use Memoize
  alias TailwindFilter.ClassGroups

  @moduledoc """
  Documentation for `TailwindFilter`.
  """
  @doc """
  takes a class string (space seperated) and outputs it filtered for tailwind property duplications

  ## Example
  iex> TailwindFilter.filter("bg-red-200 p-2 hover:bg-blue-100 hover:p-3 hover:bg-yellow-800")
  "bg-red-200 p-2 hover:p-3 hover:bg-yellow-800"
  iex> TailwindFilter.filter("mx-2 m-3")
  "m-3"
  iex> TailwindFilter.filter("m-3 mx-2")
  "m-3 mx-2"
  """
  defmemo filter(class_string) when is_binary(class_string) do
    class_string
    |> String.split()
    |> Enum.reverse()
    |> filter_classes([])
    |> Enum.join(" ")

    # |> String.trim()
  end

  @doc """
  ## Examples
  iex> TailwindFilter.filter_classes([], [])
  []
  iex> TailwindFilter.filter_classes(["bg-red-200", "hover:m-2", "hover:m-3", "m-4", "bg-blue-200"], [])
  [ "m-4", "hover:m-2", "bg-red-200" ]
  """

  def filter_classes([], resulting_classes) do
    resulting_classes
  end

  def filter_classes([head | tail], resulting_classes) do
    {prefix, property} = ClassGroups.parse(head)
    group = ClassGroups.find_group(property)
    tail = Enum.filter(tail, &is_different_group(&1, {prefix, group}))
    filter_classes(tail, [head | resulting_classes])
  end

  @doc """
  ## Examples
  iex> TailwindFilter.is_different_group("m-2", {"hover:", nil})
  true
  iex> TailwindFilter.is_different_group("m-2", {"hover:", {~r"m-[[:digit:]]+", []}})
  true
  iex> TailwindFilter.is_different_group("m-2", {"", {~r"m-[[:digit:]]+", []}})
  false
  iex> TailwindFilter.is_different_group("m-2", {"hover:", {~r"p-[[:digit:]]+", []}})
  true
  iex> TailwindFilter.is_different_group("m-2", {"", {~r"p-[[:digit:]]+", []}})
  true
  """

  def is_different_group(_class, {_, nil}) do
    true
  end

  require Logger

  def is_different_group(class, {original_prefix, {original_regex, overrides}}) do
    {prefix, prop} = ClassGroups.parse(class)

    !(prefix == original_prefix &&
        (String.match?(prop, original_regex) ||
           Enum.any?(overrides, fn override ->
             {override_regex, _} = ClassGroups.class_groups()[override]
             String.match?(prop, override_regex)
           end)))
  end
end
