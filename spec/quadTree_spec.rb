require 'spec_helper'

describe QuadTree do

  before(:each) do
    @tree = QuadTree::QuadTree.new
  end

  it "returns falsey if tree is empty" do
    @tree.element_at_point(0, 0).should be_false
  end

  it "should allow an element to be added" do
    @tree.add_element(0, 0, "x")
  end

  it "should return the right element for an element that is added" do
    @tree.add_element(0, 0, "x")
    element = @tree.element_at_point(0, 0)
    element.should == "x"
  end

  it "should return falsey for an element not added" do
    @tree.add_element(1, 1, "x")
    @tree.element_at_point(0, 0).should be_false
  end

  it "should return the right nodes for a given range" do
    @tree.add_element(10, 10, "x")
    @tree.add_element(20, 20, "y")
    box = Box.new(7, 7, 4)
    nodes = []
    @tree.nodes_in_box(box) do |node|
      nodes << node
    end
    nodes.include?(NodeData.new(10, 10, "x")).should be_true
    nodes.include?(NodeData.new(20, 20, "y")).should be_false
  end

  it "should return the right nodes for a range when many have been added" do
    (1..10).each do |x|
      @tree.add_element(x, x, x)
    end
    box = Box.new(5, 5, 1)
    nodes = []
    @tree.nodes_in_box(box) do |node|
      nodes << node
    end
    (4..6).each do |x|
      nodes.include?(NodeData.new(x, x, x)).should be_true
    end
    (1..10).each do |x|
      nodes.include?(NodeData.new(x, x, x)).should be_false unless (4..6).include? x
    end
  end

end
