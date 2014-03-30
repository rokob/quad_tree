module QuadTree
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
      @bounding_box.contains_location?(x, y)
    end

    def contains_point?(point)
      @bounding_box.contains_point?(point)
    end

    def find(x, y)
      return nil unless contains_location?(x, y)
      node = @data.find { |n| n.at?(x,y) }
      return node.element if node
      return nil unless @ne
      @ne.find(x, y) || @nw.find(x, y) || @se.find(x,y) || @sw.find(x,y)
    end

    def nodes_in_box(box, &block)
      return unless block and @bounding_box.intersects?(box)
      @data.each do |node|
        block.call(node) if box.contains_point?(node.point)
      end
      return unless @ne
      @ne.nodes_in_box(box, &block)
      @nw.nodes_in_box(box, &block)
      @se.nodes_in_box(box, &block)
      @sw.nodes_in_box(box, &block)
    end

    def insert(node_data)
      return false unless contains_point?(node_data.point)
      if @data.count < @capacity
        @data << node_data
      else
        subdivide_if_needed
        insert_in_subnode(node_data)
      end
    end

    def subdivide_if_needed
      subdivide unless @ne
    end

    def insert_in_subnode(node_data)
      return true if @ne.insert(node_data)
      return true if @nw.insert(node_data)
      return true if @se.insert(node_data)
      return true if @sw.insert(node_data)
      false
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
