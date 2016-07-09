require_relative 'player'

class DumbAi < Player

  def initialize(color:, interface:, board:)
    super(color: color, interface: interface)
    @board = board
  end

  def input
    @interface.ai_thinking
    Input.new(get_move)
  end

  def get_move
    sleep 2
    piece = pieces[pieces.to_a.sample.first]
    origin = piece.current_location
    target = piece.available_moves.sample
    [@board.translate(origin), @board.translate(target)].join
  end

  def pieces
    @board.movable_pieces(@color)
  end

  def king
    @board.pieces(class: King, color: @color).values.first
  end


  # check king if in check
  # if in check, get threat
  # get path between threat and king
  # try to capture threat
  # try to block path
  # try to move king away
end