require_relative 'directable'

class Piece
  extend Directable

  attr_reader :start_pos, :color, :move_count, :current_location, :points

  def initialize(board:, color:, start_pos:)
    @board = board
    @start_pos = start_pos
    @current_location = start_pos
    @color = color
    @move_count = 0
    @board.occupy(target: start_pos, piece: self)
    @color_not = { black: :white, white: :black }
    @points = self.class::POINTS
  end

  def opposite_color
    @color_not[color]
  end

  def king
    @board.pieces(class: King, color: color).values.first
  end

  def enemy_king
    @board.pieces(class: King, color: @color_not[color]).values.first
  end

  def available_moves
    regular_moves
  end

  def regular_moves(levels = 8)
    moves = get_available_moves(mappings: self.class::MOVE_MAPPINGS, levels: levels)
  end

  def special_moves
    []
  end

  def capture_areas(mappings: self.class::MOVE_MAPPINGS, levels: 8)
    moves = mappings.keys.inject([]) do |memo, method|
      m = all_possible_moves(eval("self.class.#{method}(levels)"), @current_location)
      memo += remove_blocked(m)
      memo
    end
  end

  def threats
    @board.threats(current_location, opposite_color)
  end

  def defended?
    @board.pieces(color: color).each do |location, piece|
      return true if piece.available_moves.include?(current_location)
    end
  end

  def move_to(target)
    return "You didn't move!" if current_location == target
    
    message = @board.occupy(target: target, piece: self)
    @current_location = target
    @move_count += 1
    message
  end

  def avatar
    self.class::AVATARS[color]
  end

  def unmoved?
    move_count == 0 ? true : false
  end

  private

  def all_possible_moves(offsets, location = nil)
    location = @current_location if location.nil?
    moves = offsets.map(&self.class.all_possible(location))
                   .select(&self.class.all_inboard(@board))
  end

  def get_available_moves(mappings:, levels: 8, location: nil, &block)
    location = @current_location if location.nil?
    moves = mappings.keys.inject([]) do |memo, method|
      m = all_possible_moves(eval("self.class.#{method}(levels)"), location)
      memo += remove_blocked(m) do |loc, blocking_piece|
        loc.pop if blocking_piece.color == self.color
      end
      memo = block.call(memo) if block_given?
      memo
    end
  end

  def remove_blocked(moves, &block)
    locations = reorient_locations(moves)

    locations.inject([]) do |memo, location|
      memo << location
      blocking_piece = @board.piece_at(location)
      unless blocking_piece.nil?
        block.call(memo, blocking_piece) if block_given?
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
