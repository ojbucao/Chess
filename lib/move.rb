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
    try && @piece.available_moves.include?(target)
  end

  def proceed
    do_castling if castling?
    do_enpassant if enpassant?
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
    return true if @castlingable.to_h.keys.include?(@target)
    false
  end

  def enpassant?
    return false if @piece.class != Pawn
    @enpassantable = @piece.enpassantables
    return true if @enpassantable.to_h.keys.include?(@target)
    false
  end

  def do_castling
    rook = @castlingable[target][0]
    kings_side = @castlingable[target][1]
    rook.move_to(kings_side)
  end

  def do_enpassant
    pawn = @enpassantable[target]
    @board.capture(pawn.current_location)
  end

  def try
    original_location = @piece.current_location
    @board.vacate(@piece.current_location)
    return true unless @piece.king.in_check?
  ensure
    @board.pieces[original_location] = @piece
  end

  private

  def sanitize(origin, target)
    # TODO
  end
end
