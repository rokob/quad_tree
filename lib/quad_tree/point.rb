module QuadTree
  ##
  # A simple representation of a two-dimensional coordinate 
  #
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
end
