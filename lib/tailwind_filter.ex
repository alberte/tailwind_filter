defmodule TailwindFilter do
  use Memoize
  @moduledoc """
  Documentation for `TailwindFilter`.
  """
  defmemo filter(class_string) when is_binary(class_string) do
    class_string
    |> String.split()
    |> Enum.reverse()
    |> filter_classes("")
    |> String.trim()

  end

  defp filter_classes([], resulting_classes) do
    resulting_classes
  end

  defp filter_classes([head | []], resulting_classes) do
    "#{head} #{resulting_classes}"
  end

  defp filter_classes([head | tail], resulting_classes) do
    group = find_group(head)
    tail = Enum.filter(tail, &is_different_group(&1, group))
    filter_classes(tail, "#{head} #{resulting_classes}")
  end

  defp find_group(class) do
    group =
      Enum.find(TailwindFilter.ClassGroups.class_groups(), nil, fn class_group ->
        String.match?(class, class_group)
      end)

    if group do
      %{"pre" => pre} = Regex.named_captures(group, class)

      group
      |> Regex.source()
      |> String.replace(TailwindFilter.ClassGroups.pre_pattern(), pre)
      |> Regex.compile!()
    else
      nil
    end
  end

  defp is_different_group(_class, nil) do
    true
  end

  defp is_different_group(class, group) do
    !String.match?(class, group)
  end
end
