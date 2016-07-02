require_relative 'piece'

class Queen < Piece

  AVATARS = { white: "\u2655", black: "\u265B"}
  
  MOVE_MAPPINGS = { up_verticals: Directable::UP_VERTICALS,
                    down_verticals: Directable::DOWN_VERTICALS,
                    left_horizontals: Directable::LEFT_HORIZONTALS,
                    right_horizontals: Directable::RIGHT_HORIZONTALS,
                    up_left_diagonals: Directable::UP_LEFT_DIAGONALS,
                    up_right_diagonals: Directable::UP_RIGHT_DIAGONALS,
                    down_left_diagonals: Directable::DOWN_LEFT_DIAGONALS,
                    down_right_diagonals: Directable::DOWN_RIGHT_DIAGONALS }

  define_movement_methods(MOVE_MAPPINGS)

end