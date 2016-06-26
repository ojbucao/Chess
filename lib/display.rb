class Display

  def initialize(board:)
    @board = board
  end

  def setup_display_board
    @display_board = Array.new(@board.size) { Array.new(@board.size)}
    @board.pieces.each do |location, piece|
      @display_board[location[1]][location[0]] = piece.avatar
    end
  end

  def show
    setup_display_board
    system "clear"
    puts "     0  1  2  3  4  5  6  7"
    @display_board.each_with_index do |row, y|
      print "  #{y} "
      row.each_with_index do |cell, x|
        bg = "\e[106m"
        bg = "\e[107m" if y % 2 == 0 && x % 2 == 0
        bg = "\e[107m" if y % 2 == 1 && x % 2 == 1
        bf = "\e[30m"

        print "#{bg}#{bf} #{cell ? cell : ' '} "
      end
      print "\e[0m"
      print " #{y} "
      puts
    end
    puts "     0  1  2  3  4  5  6  7"
    puts
  end

end