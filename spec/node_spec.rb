require 'spec_helper'

describe QuadTree::Node do

  before(:each) do
    @box = Box.new(50, 50, 50)
    @node = Node.new(@box)
  end

  describe "subdivide" do
    context "negative" do
      it "should not subdivide if it already has leaves" do
        @node.ne = ne = Node.new(@box)
        @node.nw = nw = Node.new(@box)
        @node.se = se = Node.new(@box)
        @node.sw = sw = Node.new(@box)
        @node.subdivide_if_needed
        @node.ne.equal?(ne).should be_true
        @node.nw.equal?(nw).should be_true
        @node.se.equal?(se).should be_true
        @node.sw.equal?(sw).should be_true
      end
    end

    context "positive" do
      before(:each) do
        @node.subdivide
      end

      it "should subdivide the north east correctly" do
        @node.ne.bounding_box.center.should == Point.new(75, 25)
      end
    
      it "should subdivide the north west correctly" do
        @node.nw.bounding_box.center.should == Point.new(25, 25)
      end
    
      it "should subdivide the south east correctly" do
        @node.se.bounding_box.center.should == Point.new(75, 75)
      end
    
      it "should subdivide the south west correctly" do
        @node.sw.bounding_box.center.should == Point.new(25, 75)
      end
    end
  end

  describe "add one element" do
    before(:each) do
      @data = NodeData.new(50, 50, "x")
    end

    it "should work if not at capacity" do
      @node.insert(@data).should be_true
    end
  
    it "should actually work if not at capacity" do
      @node.insert(@data)
      @node.data.include?(@data).should be_true
    end
  
    it "should increment the count" do
      initial_count = @node.data.count
      @node.insert(@data)
      @node.data.count.should == initial_count.succ
    end
  end
  
  it "should subdivide if more than capacity elements are added" do
    capacity = Node::DEFAULT_CAPACITY
    @node.should_receive(:subdivide).and_call_original
    (1..capacity+1).each do |n|
      data = NodeData.new(45+n, 45+n, 45+n) # this is not special, just inside the box
      @node.insert(data).should be_true
    end
  end

  describe "add many elements" do
    def data_with_center(x, y, distance, count)
      ax,bx = (distance - x) / (count > 1 ? count - 1.0 : 1.0), x
      ay,by = (distance - y) / (count > 1 ? count - 1.0 : 1.0), y
      (0...count).map do |i|
        NodeData.new(ax*i+bx, ay*i+by, ax*i+bx)
      end
    end

    def finds_data_object(node_data, node)
      point = node_data.point
      node.find(point.x, point.y).should == node_data.element
    end

    def finds_first_and_last(nodes, node)
      nodes.each do |n|
        finds_data_object(n.first, node)
        finds_data_object(n.last, node)
      end
    end

    it "should add elements in all directions" do
      ne_data = data_with_center(75, 25, 10, 6)
      nw_data = data_with_center(25, 25, 10, 3)
      se_data = data_with_center(75, 75, 10, 3)
      sw_data = data_with_center(25, 75, 10, 3)
      [ne_data, nw_data, se_data, sw_data].flatten.each do |d|
        @node.insert(d).should be_true
      end
    end

    it "should be able to look up elements in all directions" do
      ne_data = data_with_center(75, 25, 10, 6)
      nw_data = data_with_center(25, 25, 10, 3)
      se_data = data_with_center(75, 75, 10, 3)
      sw_data = data_with_center(25, 75, 10, 3)
      all_data = [ne_data, nw_data, se_data, sw_data]
      all_data.flatten.each do |d|
        @node.insert(d).should be_true
      end

      finds_first_and_last(all_data, @node)
    end
  end

  describe "outside the world" do
    it "should not add an element outside of the root box" do
      @node.insert(NodeData.new(200, 200, "nope")).should be_false
    end
  end

end

describe QuadTree::NodeData do
  let (:node) { NodeData.new(1, 2, "x") }

  subject { node }

  it { should be_at_point Point.new(1,2) }
  it { should be_at(1,2) }
  specify { node.element.should == "x" }
end
