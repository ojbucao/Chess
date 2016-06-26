require_relative 'piece'

class Rook < Piece

  AVATARS = { white: "\u2656", black: "\u265C"}
  
  MOVE_MAPPINGS = { left_horizontals:       '[-x, 0]', 
                    right_horizontals:      '[ x, 0]',
                    down_verticals:         '[ 0,-x]', 
                    up_verticals:           '[ 0, x]' }

  define_movement_methods(MOVE_MAPPINGS)

end