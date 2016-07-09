require_relative 'player'

class Human < Player

  def input
    loop do
      input = Input.new(@interface.get_input)
      origin = @board.translate(input.origin)
      break input if @board.occupied?(origin) && @board.piece_at(origin).color == @color
      @interface.show
    end
  end

end