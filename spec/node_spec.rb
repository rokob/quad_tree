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
        @node.subdivide_if_needed
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

end
