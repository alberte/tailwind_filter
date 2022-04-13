# TailwindFilter

This package filters a string containing tailwind classes to prevent conflicting classes from happening. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tailwind_filter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tailwind_filter, "~> 0.1.0"}
  ]
end
```

## Usage

```bash
iex> TailwindFilter.filter("p-2 bg-red-200 hover:bg-red-100 m-2 bg-blue-100 hover:bg-blue-50")
"p-2 m-2 bg-blue-100 hover:bg-blue-50"
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tailwind_filter>.

