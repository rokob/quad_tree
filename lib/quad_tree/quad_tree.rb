require_relative 'bounding_box'

module QuadTree
  class QuadTree

    def initialize(min_x=0, min_y=0, max_x=100, max_y=100)
      size_difference = (max_x - min_x) - (max_y - min_y)
      unless size_difference == 0
        max_y += size_difference if size_difference > 0
        max_x -= size_difference if size_difference < 0
      end
      center_x = (max_x - min_x) / 2.0
      center_y = (max_y - min_y) / 2.0
      half_width = max_x - center_x
      @root = Node.new(BoundingBox.new(center_x, center_y, half_width))
      @nodes = []
    end

    def element_at_point(x_coord, y_coord)
      node = @nodes.find { |n| n.at?(x_coord, y_coord) }
      node ? node.element : nil
    end

    def elements_in_box(box)
      @nodes.select do |node|
        box.contains_point? node.point.x, node.point.y
      end
    end

    def add_element(x_coord, y_coord, element)
      @nodes << NodeData.new(x_coord, y_coord, element)
    end

  end

  class Point
    attr_accessor :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end

    def ==(other)
      return @x == other.x && @y == other.y
    end
  end

  class NodeData
    attr_reader :point, :element
    def initialize(x, y, element)
      @point = Point.new(x, y)
      @element = element
    end

    def at?(x, y)
      return @point.x == x && @point.y == y
    end

    def ==(other)
      return true if self.equal?(other)
      return false unless other.instance_of?(self.class)
      return @point == other.point && @element == other.element
    end
  end

  class Node
    attr_reader :data, :bounding_box
    attr_accessor :ne, :nw, :se, :sw
    attr_accessor :capacity

    DEFAULT_CAPACITY = 4

    def initialize(bounding_box)
      @bounding_box = bounding_box
      @data = []
      @capacity = DEFAULT_CAPACITY
      @ne = @nw = @se = @sw = nil
    end

    def contains_location?(x, y)
      @bounding_box.contains_point?(x, y)
    end

    def insert(node_data)
      return false unless contains_location?(node_data.point.x, node_data.point.y)
      if @data.count < @capacity
        @data << node_data
      else
        subdivide_if_needed
        insert_in_subnode(node_data)
      end
    end

    def insert_in_subnode(node_data)
      return true if @ne.insert(node_data)
      return true if @nw.insert(node_data)
      return true if @se.insert(node_data)
      return true if @sw.insert(node_data)
      false
    end

    def subdivide_if_needed
      subdivide if @ne.nil?
    end

    def subdivide
      new_half_width = @bounding_box.half_width / 2.0
      center_east_x = @bounding_box.center.x + new_half_width
      center_north_y = @bounding_box.center.y - new_half_width
      center_west_x = @bounding_box.center.x - new_half_width
      center_south_y = @bounding_box.center.y + new_half_width
      @ne = Node.new(BoundingBox.new(center_east_x, center_north_y, new_half_width))
      @nw = Node.new(BoundingBox.new(center_west_x, center_north_y, new_half_width))
      @se = Node.new(BoundingBox.new(center_east_x, center_south_y, new_half_width))
      @sw = Node.new(BoundingBox.new(center_west_x, center_south_y, new_half_width))
    end
  end

end
