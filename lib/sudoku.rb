class Board
  def initialize(board=nil)
    if board
      @board = board
    else
      @board = Array.new(81, 0)
    end
  end

  def self.load(file)
    File.open(file, "r") {|f| return self.new(eval(f.read)) }
  end

  def save(file)
    File.open(file, "w") {|f| f.write(@board) }
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
    for cz in 0..8
      for cy in 0..2
        for cx in 0..2
          p = possible(cx,cy,cz)
          # Not already solved
          if p.length != 0
            #puts "(#{cx}, #{cy}, #{cz}) #{p.inspect}"

            # One solution
            if p.length == 1
              self[cx,cy,cz] = p.first
            else
              # Check if it's not possible elsewhere in this cell
              # Medium skill move
              p.each do |v|
                elsewhere = false
                for px in 0..2
                  for py in 0..2
                    if px != cx or py != cy
                      elsewhere = true if possible(px, py, cz).include? v
                    end
                  end
                end
                self[cx,cy,cz] = v if elsewhere == false
              end
            end
          end
        end
      end
    end
  end

  def possible(x,y,z)
    if self[x,y,z] != 0
      # Solved nothing possible
      []
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

board = Board.load(ARGV[0])
while true
  p board
  break if board.solved?
  board.solve_one
  STDIN.gets
end
