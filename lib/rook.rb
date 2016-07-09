require_relative 'piece'

class Rook < Piece

  AVATARS = { white: "\u2656", black: "\u265C"}

  POINTS = 5
  
  MOVE_MAPPINGS = { up_verticals: Directable::UP_VERTICALS,
                    down_verticals: Directable::DOWN_VERTICALS,
                    left_horizontals: Directable::LEFT_HORIZONTALS,
                    right_horizontals: Directable::RIGHT_HORIZONTALS }

  define_movement_methods(MOVE_MAPPINGS)

end