defmodule Srcktty do
  def get_values_for_filename(filename) do
    get_root_node_for_filename(filename)
    |> get_values_from_root_node
  end

  def get_root_node_for_filename(filename) do
    get_contents
    |> parse_contents
    |> find_node_for_filename(filename)
  end

  def get_contents do
    case File.read("test/fixtures/sourcekitty.json") do
      { :ok, contents } -> contents
      _ -> ""
    end
  end

  def parse_contents(contents) do
    Poison.Parser.parse!(contents)
  end

  def find_node_for_filename(nodes, filename) do
    nodes
    |> Enum.find(&filename_ends_with?(&1, filename))
  end

  def filename_ends_with?(node, suffix) do
    case node do
      node when not is_map(node) -> false
      _ ->
        node
        |> Map.keys
        |> List.first
        |> String.ends_with?(suffix)
    end
  end

  def value_has_comment?(value) do
    comment = value["key.doc.comment"]
    case comment do
      nil -> false
      _ -> String.length(comment) > 0
    end
  end

  def get_values_from_root_node(root_node) do
    root_node |> Map.values |> List.first
  end

  def recurse(values) do
      #UNDOC << node unless hasComment?(node)
    if value_has_comment?(values) do
      IO.puts(values)
    end

    if values["key.substructure"] do
      Enum.map(values["key.substructure"], &(recurse &1))
    end
  end

end
