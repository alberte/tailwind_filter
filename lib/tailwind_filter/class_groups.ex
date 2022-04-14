defmodule TailwindFilter.ClassGroups do
  @arbitrary "\\[.*\\]"
  @tw_class_pattern ~r"(?<pre>[!]?([a-z:]+:)?)(?<prop>.+)"

  @doc """
  A map of tailwind class groups.
  Each group is a tuple consisting of two elements:
  1. the regex for matching the group itself
  2. a list of keys of other groups which are overwritten by the group as well.
  """

  # TODO: Write class groups
  def class_groups do
    %{
      aspect_ratio: {~r"aspect-(auto|square|video|#{@arbitrary})", []},
      container: {~r"container", []},
      columns: {~r"columns-.+", []},
      break_after: {~r"break-after-[[:alpha:]-]+", []},
      break_before: {~r"break-before-[[:alpha:]-]+", []},
      break_inside: {~r"break-inside-[[:alpha:]-]+", []},
      box_decoration_break: {~r"box-decoration-(clone|slice)", []},
      box_sizing: {~r"box-(border|content)", []},
      display:
        {~r"(block|inline-block|inline|flex|inline-flex|table|inline-table|table-caption|table-cell|table-column|table-column-group|table-footer-group|table-header-group|table-row-group|table-row-group|table-row|flow-root|grid|inline-grid|contents|list-item|hidden)",
         []},
      floats: {~r"float-(right|left|none)", []},
      clear: {~r"clear-(left|right|both|none)", []},
      isolation: {~r"isolate(-auto)?", []},
      object_fit: {~r"object-(contain|cover|fill|none|scale-down)", []},
      object_position:
        {~r"object-(bottom|center|left|left-bottom|left-top|right|right-bottom|right-top|top)",
         []},
      overflow: {~r"overflow-(auto|hidden|clip|visible|scroll)", [:overflow_x, :overflow_y]},
      overflow_x: {~r"overflow-x-(auto|hidden|clip|visible|scroll)", []},
      overflow_y: {~r"overflow-y-(auto|hidden|clip|visible|scroll)", []},
      overscroll: {~r"overscroll-(auto|contain|none)", [:overscroll_x, :overscroll_y]},
      overscroll_x: {~r"overscroll-x-(auto|contain|none)", []},
      overscroll_y: {~r"overscroll-y-(auto|contain|none)", []},
      position: {~r"(static|fixed|absolute|relative|sticky)", []},
      top: {~r"top-(px|auto|full|[[:digit]\./]+|#{@arbitrary})", []},
      bottom: {~r"bottom-(px|auto|full|[[:digit]\./]+|#{@arbitrary})", []},
      left: {~r"left-(px|auto|full|[[:digit]\./]+|#{@arbitrary})", []},
      right: {~r"right-(px|auto|full|[[:digit]\./]+|#{@arbitrary})", []},
      inset:
        {~r"inset-(px|auto|full|[[:digit]\./]+|#{@arbitrary})",
         [:inset_x, :inset_y, :top, :left, :bottom, :right]},
      inset_x: {~r"inset-x-(px|auto|full|[[:digit]\./]+|#{@arbitrary})", [:left, :right]},
      inset_y: {~r"inset-y-(px|auto|full|[[:digit]\./]+|#{@arbitrary})", [:top, :bottom]},
      visibility: {~r"(in)?visible", []},
      z_index: {~r"z-(auto|\d+|#{@arbitrary})", []},
      flex_basis: {~r"basis-(px|auto|full|[0-9/\.]+|#{@arbitrary})", []},
      flex_direction: {~r"flex-(row|col)(-reverse)?", []},
      flex_wrap: {~r"flex-(no)?wrap(-reverse)?", []},
      flex: {~r"flex-(auto|initial|none|\d+|#{@arbitrary})", []},
      flex_grow: {~r"grow(-(\d+|#{@arbitrary}))?", []},
      flex_shrink: {~r"shrink(-(\d+|#{@arbitrary}))?", []},
      order: {~r"order-(first|last|none|\d+|#{@arbitrary})", []},
      grid_template_columns: {~r"grid-cols-(none|\d+|#{@arbitrary})", []},
      grid_column_auto: {~r"col-auto", [:grid_column_start, :grid_column_end, :grid_column_span]},
      grid_column_start: {~r"col-start-(auto|\d+|#{@arbitrary})", []},
      grid_column_end: {~r"col-end-(auto|\d+|#{@arbitrary})", []},
      grid_column_span: {~r"col-span-(full|\d+|#{@arbitrary})", []},
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
