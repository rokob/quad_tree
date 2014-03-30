require_relative 'point'

module QuadTree
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
end
