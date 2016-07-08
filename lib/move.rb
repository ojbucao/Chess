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
    return false if target.nil?
    check_for_checked
    try && @piece.available_moves.include?(target)
  end

  def proceed
    do_castling if castling?
    do_enpassant if enpassant?
    @piece.move_to(target)
    check_for_checked
  end

  def formatted
    if target.nil?
      highlight_possible
    elsif !try || @checked
      highlight_check
    elsif target == @piece.current_location
      highlight_latest_move
    else
      highlight_illegal
    end
  end

  def highlight_check
    if whos_in_check == :friend
      king_location = @piece.king.current_location
      threat_locations = @potential_threat || @board.threats(king_location, @piece.opposite_color).keys
    elsif whos_in_check == :enemy
      king_location = @piece.enemy_king.current_location
      threat_locations = @board.threats(king_location, @piece.color).keys
    else
      return {}
    end

    format = threat_locations.inject({}) do |memo, threat_location|
      memo[threat_location] = "\e[41m"
      memo
    end
    format[king_location] = "\e[41m" if @piece.class != King
    format[target] = "\e[41m" if @piece.class == King
    format      
  end

  def highlight_possible
    format = @piece.available_moves.inject({}) do |memo, move|
      memo[move] = "\e[43m"
      memo
    end
    format[@piece.current_location] = "\e[42m"
    format
  end

  def highlight_latest_move
    format = {}
    format[@piece.current_location] = "\e[42m"
    format
  end

  def highlight_illegal
    format = {}
    format[@piece.current_location] = "\e[101m"
    format
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
    if enpassant?
      target_piece = @enpassantable[target]
    else
      target_piece = @board.piece_at(target)
    end

    cached_piece_location = @piece.current_location
    cached_target_location = target_piece.current_location if target_piece

    @board.vacate(@piece.current_location)
    @board.pieces.delete(target_piece.current_location) if target_piece
    @board.pieces[target] = @piece
    @piece.instance_variable_set(:@current_location, target) 
    
    @checked = @piece.king if @piece.king.in_check?
    @potential_threat = @board.threats(@piece.king.current_location, @piece.opposite_color).keys
    return true unless @piece.king.in_check?
  ensure
    @board.pieces.delete(target)
    @board.pieces[cached_target_location] = target_piece if target_piece
    @board.pieces[cached_piece_location] = @piece
    @piece.instance_variable_set(:@current_location, cached_piece_location)
  end

  def classify_color(color)
    case color
    when @piece.color
      :friend
    when @piece.opposite_color
      :enemy
    end
  end

  def whos_in_check
    classify_color(@checked.color) if @checked
  end

  def check_for_checked
    @checked = nil
    [@piece.king, @piece.enemy_king].each do |king|
      @checked = king if king.in_check?
    end
  end

end