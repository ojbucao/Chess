require_relative 'piece'

class Bishop < Piece

  AVATARS = { white: "\u2657", black: "\u265D"}
  
  MOVE_MAPPINGS = { up_left_diagonals:    '[-x, x]', 
                    up_right_diagonals:   '[ x, x]',
                    down_left_diagonals:  '[-x,-x]', 
                    down_right_diagonals: '[ x,-x]' }

  define_movement_methods(MOVE_MAPPINGS)

end