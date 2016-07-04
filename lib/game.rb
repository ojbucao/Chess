  classes = %w{board piece pawn rook knight 
               bishop queen king config display 
               move input}
  classes.each { |i| require_relative "#{i}" }

  require 'pry'

class Game
  def play
    board = Board.new.setup(Config::SETTINGS[1])
    display = Display.new(board: board)
    display.show
    loop do
      raw_input = display.get_input
      input = Input.new(raw_input)
      if input.valid? && board.occupied?(board.translate(input.origin))
        move = Move.new(board: board, origin: input.origin, target: input.target)
        move.proceed if move.legal?
        display.show(move.formatted)
      else
        # display message
        display.show
      end
    end

  end

end