require_relative 'directable'

class Piece
  extend Directable

  attr_reader :start_pos, :color, :move_count, :current_location

  def initialize(board:, color:, start_pos:)
    @board = board
    @start_pos = start_pos
    @current_location = start_pos
    @color = color
    @move_count = 0
    @board.occupy(target: start_pos, piece: self)
    @color_not = { black: :white, white: :black }
  end

  def opposite_color
    @color_not[color]
  end

  def available_moves
    regular_moves
  end

  def regular_moves(levels = 8)
    moves = get_available_moves(mappings: self.class::MOVE_MAPPINGS, levels: levels)
  end

  def available_moves_formatted
    format = available_moves.inject({}) do |memo, move|
      memo[move] = "\e[43m"
      memo
    end
    format[@current_location] = "\e[101m"
    format
  end

  def current_location_formatted
    format = {}
    format[@current_location] = "\e[101m"
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
    moves = offsets.map(&self.class.all_possible(@current_location))
                   .select(&self.class.all_inboard(@board))
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
    moves.reject { |location| !@board.occupied?(location) }
  end

  def reorient_locations(moves)
    locations = (moves.unshift(current_location)).sort
    locations.reverse! if locations[0] != current_location
    locations.shift
    locations
  end

end
