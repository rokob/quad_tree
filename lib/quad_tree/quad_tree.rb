require_relative 'bounding_box'
require_relative 'node'
require_relative 'node_data'

module QuadTree
  ##
  # A tree that efficiently represents spatial data
  #
  class QuadTree

    ##
    # The tree is assumed to be orientied with (min_x, min_y) in the upper-left
    # corner if the region is viewed on the plane. The (max_x, max_y)
    # coordinate is thus the lower-right corner.
    # --
    # The input values will be converted to a square region, I am not
    # sure if this is the best thing to do, but whatever it doesn't
    # functionally alter the tree from the outside.
    #
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

    ##
    # Given an x and y coordinate, return the element that is stored in the tree
    # at that point, otherwise return nil
    #
    def element_at_point(x_coord, y_coord)
      @root.find(x_coord, y_coord)
    end

    ##
    # Given a bounding box, yield each node in the tree that falls within that region
    # to the supplied block
    #
    def nodes_in_box(box, &block) # :yields: node
      @root.nodes_in_box(box, &block)
    end

    ##
    # Add an element to the tree at the given coordinates
    #
    def add_element(x_coord, y_coord, element)
      @root.insert(NodeData.new(x_coord, y_coord, element))
    end

  end
end
