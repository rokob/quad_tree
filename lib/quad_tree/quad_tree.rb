require_relative 'bounding_box'
require_relative 'node'
require_relative 'node_data'

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
    end

    def element_at_point(x_coord, y_coord)
      @root.find(x_coord, y_coord)
    end

    def nodes_in_box(box, &block)
      @root.nodes_in_box(box, &block)
    end

    def add_element(x_coord, y_coord, element)
      @root.insert(NodeData.new(x_coord, y_coord, element))
    end

  end
end
