class Move

  attr_reader :origin, :target, :piece

  def initialize(board:, origin:, target: nil)
    @board = board
    if origin.is_a?(String) || target.is_a?(String)
      origin = board.translate(origin)
      target = board.translate(target)
    end
    @origin = origin
    @target = target
    @piece = @board.piece_at(origin)
  end

  def legal?
    @piece.available_moves.include? target
  end

  def proceed
    do_castling if castling?
    @piece.move_to(target)
  end

  def possible
    @piece.available_moves_formatted
  end

  def latest_move
    @piece.current_location_formatted
  end

  def castling?
    @castlingable = @board.castlingables(piece)
    return true if @castlingable && @castlingable.keys.include?(@target)
    return false
  end

  def do_castling
    rook = @castlingable[target][0]
    kings_side = @castlingable[target][1]
    rook.move_to(kings_side)
  end

  private

  def sanitize(origin, target)
    # TODO
  end
end
