require_relative 'piece'

class Queen < Piece

  AVATARS = { white: "\u2655", black: "\u265B"}
  
  MOVE_MAPPINGS = { up_verticals: UP_VERTICALS,
                    down_verticals: DOWN_VERTICALS,
                    left_horizontals: LEFT_HORIZONTALS,
                    right_horizontals: RIGHT_HORIZONTALS,
                    up_left_diagonals: UP_LEFT_DIAGONALS,
                    up_right_diagonals: UP_RIGHT_DIAGONALS,
                    down_left_diagonals: DOWN_LEFT_DIAGONALS,
                    down_right_diagonals: DOWN_RIGHT_DIAGONALS }

  define_movement_methods(MOVE_MAPPINGS)

end