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
    @piece.move_to(target)
  end

  def possible
    @piece.available_moves_formatted
  end

  def latest_move
    @piece.current_location_formatted
  end

  private

  def sanitize(origin, target)
    # TODO
  end
end
