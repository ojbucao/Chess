require_relative 'piece'

class Rook < Piece

  AVATARS = { white: "\u2656", black: "\u265C"}
  
  MOVE_MAPPINGS = { up_verticals: UP_VERTICALS,
                    down_verticals: DOWN_VERTICALS,
                    left_horizontals: LEFT_HORIZONTALS,
                    right_horizontals: RIGHT_HORIZONTALS }

  define_movement_methods(MOVE_MAPPINGS)

end