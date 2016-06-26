require_relative 'piece'

class Bishop < Piece

  AVATARS = { white: "WB", black: "BB"}
  
  MOVE_MAPPINGS = { up_left_diagonals:    '[-x, x]', 
                    up_right_diagonals:   '[ x, x]',
                    down_left_diagonals:  '[-x,-x]', 
                    down_right_diagonals: '[ x,-x]' }

  define_movement_methods(MOVE_MAPPINGS)

end