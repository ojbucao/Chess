require_relative 'player'

class DumbAi < Player

  def input
    @interface.ai_thinking
    Input.new(get_move)
  end

  def get_move
    sleep 1
    if !pieces_threatened(pieces).empty?
      piece = pieces_threatened(pieces).shift
      if piece.class == King
        move = block(piece)|| evade(piece) || fight(piece)
      else
        move = fight(piece) || evade(piece) unless piece.defended?
      end
    end

    if !pieces_threatened(enemy_pieces).empty?
      piece = pieces_threatened(enemy_pieces).shift
      move = capture(piece)
    end

    if move.nil?
      piece = movable_pieces[movable_pieces.to_a.sample.first]
      origin = piece.current_location
      target = piece.available_moves.sample
      move = [origin, target]
    end
    move.map { |m| @board.translate(m) }.join if move
  end

  def movable_pieces
    @board.movable_pieces(@color)
  end

  def pieces
    @board.pieces(color: @color)
  end

  def enemy_pieces
    @board.pieces(color: king.opposite_color)
  end

  def king
    @board.pieces(class: King, color: @color).values.first
  end

  def evade(piece)
    move = piece.available_moves.sample
    return [piece.current_location, move] unless move.nil?
    false
  end

  def block(piece)
    threat = piece.threats.values.first
    path = @board.path_between(piece.current_location, threat.current_location)
    pieces.each do |location, piece|
      piece.available_moves.each do |move|
        return [piece.current_location, move] if path && path.include?(move)
      end
    end
    false
  end

  def fight(piece)
    threat = piece.threats.values.first
    pieces.each do |location, piece|
      piece.available_moves.each do |move|
        return [piece.current_location, move] if move == threat.current_location
      end
    end
    false
  end

  def capture(piece)
    threat = piece.threats.values.first
    return [threat.current_location, piece.current_location]
  end

  def pieces_threatened(pieces)
    pieces_sorted_by_points(pieces).inject([]) do |memo, (location, piece)|
      memo << piece if @board.threatened?(piece.current_location, piece.opposite_color)
      memo
    end
  end

  def pieces_sorted_by_points(pieces)
    pieces.sort_by { |location, piece| piece.points }.reverse.to_h
  end

end