module QuadTree
  class BoundingBox
    attr_reader :center, :half_width

    def initialize(center_x, center_y, half_width)
      @center = Point.new(center_x, center_y)
      @half_width = half_width
    end

    def contains_location?(x, y)
      (@center.x - x).abs <= @half_width && (@center.y - y).abs <= @half_width
    end

    def contains_point?(point)
      contains_location?(point.x, point.y)
    end

    def to_s
      "<#{super.to_s}::center=#{@center.x}, #{@center.y}), half_width=#{@half_width}>"
    end

    def intersects?(other)
      return false if (@center.x - other.center.x).abs > @half_width + other.half_width
      return false if (@center.y - other.center.y).abs > @half_width + other.half_width
      true
    end
  end
end
