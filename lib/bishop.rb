require_relative 'piece'

class Bishop < Piece

  AVATARS = { white: "\u2657", black: "\u265D"}
  
  MOVE_MAPPINGS = { up_left_diagonals: Directable::UP_LEFT_DIAGONALS,
                    up_right_diagonals: Directable::UP_RIGHT_DIAGONALS,
                    down_left_diagonals: Directable::DOWN_LEFT_DIAGONALS,
                    down_right_diagonals: Directable::DOWN_RIGHT_DIAGONALS }

  define_movement_methods(MOVE_MAPPINGS)

end