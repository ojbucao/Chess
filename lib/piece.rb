class Piece
  
  attr_reader :start_pos, :color, :move_count, :current_location

  def self.define_movement_methods(move_mappings)
    move_mappings.each do |name, offsets|
      define_singleton_method(name) do |upper_limit|
        range = (1..upper_limit)
        moves = range.map { |x| eval(offsets) }
        moves.sort
      end
    end
  end

  def initialize(board:, color:, start_pos:)
    @board = board
    @start_pos = start_pos
    @board.occupy(target: start_pos, piece: self)
    @current_location = start_pos
    @color = color
    @move_count = 0
  end

  def available_moves(num=8)
    moves = MOVE_MAPPINGS.keys.inject([]) do |memo, method|
      m = all_possible_moves(eval("self.class.#{method}(num)"))
      memo += remove_occupied(m)
    end
  end

  def move(target)
    if piece.current_location == target
      raise "You didn't move!"
    end

    @board.vacate(target)
    @board.occupy(target: target, piece: self)
    current_location = target
    @move_count += 1
    true
  end

  def avatar
    AVATARS[color]
  end

  def unmoved?
    move_count == 0 ? true : false
  end

  private

  def all_possible_moves(offsets)
    all_possible = lambda { |move| [@current_location[0] + move[0], @current_location[1] + move[1]] }
    all_inboard = lambda { |move| @board.include?(move) }

    moves = offsets.map(&all_possible).select(&all_inboard)
  end

  def remove_occupied(moves)
    locations = reorient_locations(moves)

    locations.inject([]) do |memo, location|
      memo << location
      blocking_piece = @board.piece_at(location)
      unless blocking_piece.nil?
        memo.pop if blocking_piece.color == self.color
        break memo
      end
      memo
    end
  end

  def reorient_locations(moves)
    locations = (moves.unshift(current_location)).sort
    locations.reverse! if locations[0] != current_location
    locations.shift
    locations
  end

end