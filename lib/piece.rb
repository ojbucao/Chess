class Piece
  
  attr_accessor :current_location
  attr_reader :start_pos, :color, :move_count

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
    @board.occupy(location: start_pos, piece: self)
    @current_location = start_pos
    @color = color
    @move_count = 0
  end

  def available_moves
    moves = self.class::MOVE_MAPPINGS.keys.inject([]) do |memo, method|
      m = all_possible_moves(eval("self.class.#{method}(8)"))
      memo += remove_occupied(m)
    end
  end

  def move(target)
    @board.occupy(target, self)
    @move_count += 1
  end

  def avatar
    AVATARS[color]
  end

  private

  def all_possible_moves(offsets)
    all_possible = lambda { |move| [@current_location[0] + move[0], @current_location[1] + move[1]] }
    all_inboard = lambda { |move| @board.include?(move) }

    moves = offsets.map(&all_possible).select(&all_inboard)
  end

  def remove_occupied(moves)
    locations = (moves.unshift(current_location)).sort
    locations.reverse! if locations[0] != current_location
    locations.shift

    moves_pruned = []
    locations.each do |location|
      moves_pruned << location
      blocking_piece = @board.piece_at(location)
      if blocking_piece
        moves_pruned.pop if blocking_piece.color == self.color
        break
      end
    end
    moves_pruned
  end

end