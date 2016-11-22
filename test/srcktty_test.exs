defmodule SrckttyTest do
  use ExUnit.Case
  doctest Srcktty

  test "get_contents returns some contents" do
    assert Srcktty.get_contents != ""
  end

  test "parse_contents returns a list" do
    assert (Srcktty.get_contents |> Srcktty.parse_contents |> is_list)
  end

  test "find_node_for_filename returns a node when a filename matches" do
    sample_node1 = %{"filename1.txt" => "value1"}
    sample_node2 = %{"filename2.txt" => "value2"}
    sample_nodes = [sample_node1, sample_node2]
    sample_node = Srcktty.find_node_for_filename(sample_nodes, "2.txt")
    assert sample_node == sample_node2
  end

  test "find_node_for_filename returns a node when no filename matches" do
    sample_node1 = %{"filename1.txt" => "value1"}
    sample_node2 = %{"filename2.txt" => "value2"}
    sample_nodes = [sample_node1, sample_node2]
    sample_node = Srcktty.find_node_for_filename(sample_nodes, "3.txt")
    assert sample_node == nil
  end

  test "get_values_from_root_node returns the node values" do
    sample_root_node = %{"filename1.txt" => "value1"}
    values = Srcktty.get_values_from_root_node(sample_root_node)
    assert values == "value1"
  end

  test "value_has_comment? returns true when the map contains a key named key.doc.comment" do
    sample_values = %{
      "key.doc.whatsup" => "Bugs",
      "key.doc.word" => "Microsoft",
      "key.doc.comment" => "No comment"
    }
    assert Srcktty.value_has_comment?(sample_values)
  end

  test "value_has_comment? returns false when the map does not contain a key named key.doc.comment" do
    sample_values = %{
      "key.doc.whatsup" => "Bugs",
      "key.doc.word" => "Microsoft"
    }
    assert !Srcktty.value_has_comment?(sample_values)
  end

  test "filename_ends_with? returns true when the suffix matches" do
    sample_node = %{"filename.txt" => "value1", "key2" => "value2"}
    assert Srcktty.filename_ends_with?(sample_node, "e.txt")
  end

  test "filename_ends_with? returns false when the suffix does not match" do
    sample_node = %{"filename.txt" => "value1", "key2" => "value2"}
    assert !Srcktty.filename_ends_with?(sample_node, "e.text")
  end

  test "filename_ends_with? returns false when the sample_node is invalid" do
    sample_node = ["filename.txt"]
    assert !Srcktty.filename_ends_with?(sample_node, "e.text")
  end
end
