module Sudoku
  class Board
    def initialize(values=nil)
      @quads = Array.new(9)
    end

    def quad(index)
      @quads[index] ||= Quad.new(self, index)
      @quads[index]
    end

    def [](x, y)
      q = ((y / 3) * 3) + (x % 3))
    end
  end

  class Quad
    def initialize(board, index)
      @cells = Array.new(9)
      @board = board
      @index = index
    end

    def [](x,y)
      @cells[y*3+x] ||= Cell.new(self, x, y, 0)
      @cells[y*3+x]
    end

    def []=(x,y,value)
    end
  end

  class Cell
    def initialize(quad, x, y, value)
      @quad = quad
      @x = x
      @y = y
      @value = value
    end

    def to_s
      @value
    end
  end
end
