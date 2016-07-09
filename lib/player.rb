require_relative 'input'

class Player

  def initialize(color:, interface:, board:)
    @color = color
    @board = board
    @interface = interface
  end

end