class Board
  def initialize(board=nil)
    if board
      @board = board
    else
      @board = Array.new(81, 0)
    end
  end

  def twod(x,y)
    @board[y*9+x]
  end

  def [](x,y,z)
    dy = (z / 3) * 3
    dx = (z % 3) * 3
    @board[(y+dy)*9+(x+dx)]
  end

  def []=(x,y,z,value)
    dy = (z / 3) * 3
    dx = (z % 3) * 3
    @board[(y+dy)*9+(x+dx)] = value
  end

  def solved?
    for i in 0..80
      if @board[i] == 0
        return false
      end
    end
    true
  end

  def solve_one
    for cy in 0..2
      for cx in 0..2
        for cz in 0..8
          p = possible(cx,cy,cz)
          # Not already solved
          if p
            # One solution
            if p.length == 1
              #puts "(#{cx}, #{cy}, #{cz}) #{p.inspect}"
              self[cx,cy,cz] = p.first
            end
          end
        end
      end
    end
  end

  def possible(x,y,z)
    if self[x,y,z] != 0
      #self[x,y,z]
      nil
    else
      p = [1,2,3,4,5,6,7,8,9]
      # Remove this cells numbers
      for cy in 0..2
        for cx in 0..2
          p.reject! {|v| v == self[cx,cy,z]}
        end
      end
      # Remove this columns numbers
      for cy in 0..8
        p.reject! {|v| v == twod((x+((z % 3)*3)),cy)}
      end
      # Remove this rows numbers
      for cx in 0..8
        p.reject! {|v| v == twod(cx,(y+((z / 3)*3)))}
      end
      p
    end
  end

  def to_s
    r = "+-------+-------+-------+\n"
    for y in 0..8
      r << "+-------+-------+-------+\n" if y % 3 == 0 && y > 0
      r << "| "
      for x in 0..8
        r << "| " if x % 3 == 0 && x > 0
        if @board[y*9+x] > 0
          r << @board[y*9+x].to_s << " "
        else
          r << ". "
        end
      end
      r << "|"
      r << "\n"
    end
    r << "+-------+-------+-------+\n"

    r
  end
end

board = Board.new([
  7, 4, 0,  0, 1, 3,  5, 0, 0,
  0, 0, 0,  6, 0, 0,  0, 0, 8,
  3, 6, 0,  7, 5, 8,  2, 0, 0,

  0, 0, 0,  4, 2, 0,  0, 8, 5,
  0, 0, 0,  3, 0, 9,  0, 0, 0,
  4, 8, 0,  0, 6, 5,  0, 0, 0,

  0, 0, 5,  8, 4, 1,  0, 7, 2,
  2, 0, 0,  0, 0, 6,  0, 0, 0,
  0, 0, 1,  5, 7, 0,  0, 6, 9,
])

while true
  p board
  break if board.solved?
  board.solve_one
  gets
end
