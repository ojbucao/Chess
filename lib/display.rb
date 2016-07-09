class Display

  def board=(board)
    @board = board
  end

  def setup_display_board
    @display_board = Array.new(@board.size) { Array.new(@board.size)}
    @board.pieces.each do |location, piece|
      @display_board[location[1]][location[0]] = piece.avatar
    end
  end

  def get_input
    print "Your move: "
    input = gets.chomp
  end

  def get_color
    puts "What color do you want to play as? (white or black)"
    color = gets.chomp
  end

  def welcome
    system "clear"
    puts "Welcome to EZ Chess!"
    puts
  end

  def show(args={})
    setup_display_board
    system "clear"
    puts "     a  b  c  d  e  f  g  h"
    @display_board.each_with_index do |row, y|
      print "  #{(y - 8).abs} "
      row.each_with_index do |cell, x|
        bg = "\e[106m"
        bg = "\e[47m" if y % 2 == 0 && x % 2 == 0
        bg = "\e[47m" if y % 2 == 1 && x % 2 == 1
        bg = ( args[:format] ? args[:format][[x,y]] : nil ) || bg
        bf = "\e[90m"

        print "#{bg}#{bf} #{cell ? cell : ' '} "
      end
      print "\e[0m"
      print " #{(y - 8).abs} "
      puts
    end
    puts "     a  b  c  d  e  f  g  h"
    puts "     \e[33m#{args[:message]}\e[0m" unless args[:message].to_s.strip.empty?
    puts
  end

end
