  classes = %w{board piece pawn rook knight 
               bishop queen king config display 
               move }
  classes.each { |i| require_relative "#{i}" }

  require 'pry'

class Game
  def play
    board = Board.new.setup(Config::SETTINGS[1])
    display = Display.new(board: board)
    display.show
    loop do
      input = display.get_input
      origin = input.split("-")[0]
      target = input.split("-")[1]
      move = Move.new(board: board, origin: origin, target: target)
      
      if target.nil?
        display.show(move.possible)
      else
        move.proceed if move.legal?
        display.show(move.latest_move)
      end
    end

  end

end