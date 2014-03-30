require 'spec_helper'

describe QuadTree::BoundingBox do

  it "should contain a point at its center" do
    box = Box.new(50, 50, 10)
    box.contains_point?(50, 50).should be_true
  end

  it "should not contain a point outside its bounds" do
    box = Box.new(50, 50, 10)
    box.contains_point?(0, 0).should be_false
  end

  it "should contain a point on an edge" do
    box = Box.new(50, 50, 10)
    box.contains_point?(50, 40).should be_true
  end

  it "should correctly know it intersects a subregion" do
    box = Box.new(50, 50, 10)
    subbox = Box.new(50, 50, 5)
    box.intersects?(subbox).should be_true
  end

  it "should correctly know it intersects a superregion" do
    superbox = Box.new(50, 50, 10)
    box = Box.new(50, 50, 5)
    box.intersects?(superbox).should be_true
  end

  it "should correctly know it intersects an overlapping box" do
    box1 = Box.new(50, 50, 10)
    box2 = Box.new(55, 57, 8)
    box1.intersects?(box2).should be_true
    box2.intersects?(box1).should be_true
  end

  it "should know it does not intersect a box somewhere else" do
    box1 = Box.new(50, 50, 10)
    box2 = Box.new(20, 20, 10)
    box1.intersects?(box2).should be_false
    box2.intersects?(box1).should be_false
  end

  it "should know it intersects something just on an edge" do
    box1 = Box.new(50, 50, 10)
    box2 = Box.new(30, 50, 10)
    box1.intersects?(box2).should be_true
    box2.intersects?(box1).should be_true
  end

  it "should know it intersects something just at a corner" do
    box1 = Box.new(50, 50, 10)
    box2 = Box.new(30, 30, 10)
    box1.intersects?(box2).should be_true
    box2.intersects?(box1).should be_true
  end

end
