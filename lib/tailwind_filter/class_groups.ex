defmodule TailwindFilter.ClassGroups do
  @tw_class_pattern ~r"(?<pre>[!]?([a-z:]+:)?)(?<prop>.+)"

  @doc """
  A map of tailwind class groups.
  Each group is a tuple consisting of two elements:
  1. the regex for matching the group itself
  2. a list of keys of other groups which are overwritten by the group as well.
  """
  def class_groups do
    %{
      margin: {~r"m-[[:digit:]]+", [:margin_x, :margin_y]},
      margin_x: {~r"mx-[[:digit:]]+", []},
      margin_y: {~r"my-[[:digit:]]+", []},
      bg_color: {~r"bg-[a-z]+-[[:digit:]]+", []}
    }
  end

  def find_group(class) do
    {_key, group} =
      Enum.find(class_groups(), {nil, nil}, fn {_key, {regex, _}} ->
        Regex.match?(regex, class)
      end)

    group
  end

  @doc """
    returns a tuple containing the prefix (before the ":") and the tailwind property itself (e.g. "bg-red-200")
  """
  def parse(class) do
    %{"pre" => pre, "prop" => prop} = Regex.named_captures(@tw_class_pattern, class)
    {pre, prop}
  end
end
