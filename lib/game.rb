  classes = %w{ board piece pawn rook knight bishop queen king 
                config display move input dumb_ai player human }
  classes.each { |i| require_relative "#{i}" }

  require 'pry'

class Game

  def play
    color_not = { black: :white, white: :black }

    display = Display.new
    display.welcome

    color = Input.new(display.get_color).color
    board = Board.new.setup(Config::SETTINGS[color])
    ai = DumbAi.new(color: color_not[color], interface: display, board: board)
    human = Human.new(color: color, interface: display, board: board)

    display.board = board
    display.show

    players = { color => human, color_not[color] => ai }
    current_color = :white
    loop do
      player = players[current_color]
      input = player.input
      break if input.to_s.empty?
      if input.valid? && board.occupied?(board.translate(input.origin))
        move = Move.new(board: board, origin: input.origin, target: input.target)
        if move.legal?
          move.proceed 
          current_color = color_not[current_color]
        end
      end

      display.show(move.result)
    end

  end

end