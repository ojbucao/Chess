class Piece

  UP_VERTICALS = '[0, -x]'
  DOWN_VERTICALS = '[0, x]'
  LEFT_HORIZONTALS = '[-x, 0]'
  RIGHT_HORIZONTALS = '[x, 0]'
  UP_LEFT_DIAGONALS = '[-x, -x]'
  UP_RIGHT_DIAGONALS = '[x, -x]'
  DOWN_LEFT_DIAGONALS = '[-x, x]'
  DOWN_RIGHT_DIAGONALS = '[x, x]'

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

  def available_moves(levels = 8)
    moves = get_available_moves(mappings: self.class::MOVE_MAPPINGS, levels: levels)
  end

  def available_moves_formatted
    format = available_moves.inject({}) do |memo, move|
      memo[move] = "\e[42m"
      memo
    end
    format[@current_location] = "\e[43m"
    format
  end

  def move_to(target)
    raise "You didn't move!" if current_location == target
    # raise "Invalid move" unless available_moves.include? target

    @board.occupy(target: target, piece: self)
    @current_location = target
    @move_count += 1
    true
  end

  def avatar
    self.class::AVATARS[color]
  end

  def unmoved?
    move_count == 0 ? true : false
  end

  private

  def all_possible_moves(offsets)
    moves = offsets.map(&all_possible).select(&all_inboard)
  end

  def get_available_moves(mappings:, levels: 8, &block)
    moves = mappings.keys.inject([]) do |memo, method|
      m = all_possible_moves(eval("self.class.#{method}(levels)"))
      memo += remove_blocked(m)
      memo = block.call(memo) if block_given?
      memo
    end
  end

  def remove_blocked(moves)
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

  def remove_unoccupied(moves)
    moves.reject { |e| @board.piece_at(e).nil? }
  end

  def reorient_locations(moves)
    locations = (moves.unshift(current_location)).sort
    locations.reverse! if locations[0] != current_location
    locations.shift
    locations
  end

  def all_possible
    lambda { |move| [@current_location[0] + move[0], @current_location[1] + move[1]] }
  end

  def all_inboard
    lambda { |move| @board.include?(move) }
  end

end
