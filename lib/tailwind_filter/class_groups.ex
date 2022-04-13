defmodule TailwindFilter.ClassGroups do


  def class_groups do
    [
      ~r"#{beginning_pattern()}#{pre_pattern()}bg-[a-z]+-\d+",
      ~r"#{beginning_pattern()}#{pre_pattern()}m-\d+"
    ]
  end

  def pre_pattern do
    "(?<pre>([a-z:]+:)?)"
  end

  def beginning_pattern do
    "(^|\s+)"
  end
end
