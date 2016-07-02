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
    super(1)
  end

end