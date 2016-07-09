require_relative 'piece'

class King < Piece

  AVATARS = { white: "\u2654", black: "\u265A"}
  
  MOVE_MAPPINGS = { up_verticals: Directable::UP_VERTICALS,
                    down_verticals: Directable::DOWN_VERTICALS,
                    left_horizontals: Directable::LEFT_HORIZONTALS,
                    right_horizontals: Directable::RIGHT_HORIZONTALS,
                    up_left_diagonals: Directable::UP_LEFT_DIAGONALS,
                    up_right_diagonals: Directable::UP_RIGHT_DIAGONALS,
                    down_left_diagonals: Directable::DOWN_LEFT_DIAGONALS,
                    down_right_diagonals: Directable::DOWN_RIGHT_DIAGONALS }

  define_movement_methods(MOVE_MAPPINGS)

  def initialize(board:, color:, start_pos:)
    super
    @position = start_pos[1] == 0 ? :top : :bottom
  end

  def available_moves
    moves = regular_moves.reject do |move|
     @board.threatened?(move, opposite_color) || threat_vectors.include?(move)
    end.to_a
    moves + special_moves
  end

  def regular_moves
    super(1)
  end

  def capture_areas
    super(levels: 1)
  end

  def special_moves
    @board.castlingables(self).to_h.keys 
  end

  def in_check?
    return true unless threats.empty?
  end

  def threats
    @board.threats(current_location, opposite_color)
  end

  def threat_vectors
    paths = threats.keys.inject([]) do |memo1, threat|

      # Exclude Pawn, Knight and King because they don't have long-range vectors
      next memo1 if [Pawn, Knight, King].include?(@board.piece_at(threat).class)
      
      path = @board.path_through(threat, current_location).inject([]) do |memo2, p|
        next memo2 if p == threat
        break memo2 if @board.occupied?(p) && @board.piece_at(p).color == opposite_color
        memo2 << p
        memo2
      end
      memo1 += path
      memo1
    end
    paths
  end

end