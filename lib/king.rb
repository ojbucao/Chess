require_relative 'piece'

class King < Piece

  AVATARS = { white: "\u2654", black: "\u265A"}
  
  MOVE_MAPPINGS = { up_verticals: UP_VERTICALS,
                    down_verticals: DOWN_VERTICALS,
                    left_horizontals: LEFT_HORIZONTALS,
                    right_horizontals: RIGHT_HORIZONTALS,
                    up_left_diagonals: UP_LEFT_DIAGONALS,
                    up_right_diagonals: UP_RIGHT_DIAGONALS,
                    down_left_diagonals: DOWN_LEFT_DIAGONALS,
                    down_right_diagonals: DOWN_RIGHT_DIAGONALS }

  define_movement_methods(MOVE_MAPPINGS)

  def available_moves
    super(1)
  end

end