require_relative 'player'

class DumbAi < Player

  def input
    Input.new(get_move)
  end

  def get_move
    sleep 2
    piece = pieces[pieces.to_a.sample.first]
    origin = piece.current_location
    target = piece.available_moves.sample
    [@interface.translate(origin), @interface.translate(target)].join
  end

  def pieces
    @interface.movable_pieces(@color)
  end

  def king
    @interface.pieces(class: King, color: @color).values.first
  end


  # check king if in check
  # if in check, get threat
  # get path between threat and king
  # try to capture threat
  # try to block path
  # try to move king away
end