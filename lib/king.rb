require_relative 'piece'

class King < Piece

  AVATARS = { white: "\u2654", black: "\u265A"}
  
  MOVE_MAPPINGS = { up_left_diagonals:    '[-x, x]', 
                    up_right_diagonals:   '[ x, x]',
                    down_left_diagonals:  '[-x,-x]', 
                    down_right_diagonals: '[ x,-x]',
                    left_horizontals:     '[-x, 0]', 
                    right_horizontals:    '[ x, 0]',
                    down_verticals:       '[ 0,-x]', 
                    up_verticals:         '[ 0, x]' }

  define_movement_methods(MOVE_MAPPINGS)

  def available_moves
    super(levels: 1)
  end

end