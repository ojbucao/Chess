require_relative 'player'

class DumbAi < Player

  def input
    @interface.ai_thinking
    Input.new(get_move)
  end

  def get_move
    sleep 2
    if king.in_check?
      move = block || defend || evade
    else
      piece = pieces[pieces.to_a.sample.first]
      origin = piece.current_location
      target = piece.available_moves.sample
      move = [origin, target]
    end
    move.map { |m| @board.translate(m) }.join if move
  end

  def pieces
    @board.movable_pieces(@color)
  end

  def king
    @board.pieces(class: King, color: @color).values.first
  end

  def evade
    move = king.available_moves.sample
    return [king.current_location, move] unless move.nil?
    false
  end

  def block
    threat = king.threats.values.first
    path = @board.path_between(king.current_location, threat.current_location)
    pieces.each do |location, piece|
      piece.available_moves.each do |move|
        return [piece.current_location, move] if path && path.include?(move)
      end
    end
    false
  end

  def defend
    threat = king.threats.values.first
    pieces.each do |location, piece|
      piece.available_moves.each do |move|
        return [piece.current_location, move] if move == threat.current_location
      end
    end
    false
  end

  # check king if in check
  # if in check, get threat
  # get path between threat and king
  # try to capture threat
  # try to block path
  # try to move king away
end