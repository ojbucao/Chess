require_relative 'piece'

class Pawn < Piece

  AVATARS = { white: "\u2659", black: "\u265F"}
  
  MOVE_MAPPINGS = { white: { down_verticals: '[ 0,-x]' },
                    black: { up_verticals:   '[ 0, x]' } }

  SPECIAL_MAPPINGS = { black: { down_left_diagonals:  '[-x, x]', 
                                down_right_diagonals: '[ x, x]' },
                       white: { up_left_diagonals:    '[-x,-x]', 
                                up_right_diagonals:   '[ x,-x]' } }

  def initialize(board:, color:, start_pos:)
    super
    self.class.define_movement_methods(MOVE_MAPPINGS[color])
    self.class.define_movement_methods(SPECIAL_MAPPINGS[color])
  end

  def available_moves
    moves = get_available_moves(mappings: MOVE_MAPPINGS[color], levels: 2) do |memo|
      toggle_first_move(memo)
    end
  end

  def special_moves
    moves = get_available_moves(mappings: SPECIAL_MAPPINGS[color], levels: 1) do |memo|
      remove_unoccupied(memo)
    end
  end

  def toggle_first_move(moves)
    locations = reorient_locations(moves)
    locations.pop if move_count > 0 && locations.count > 1
    locations
  end

end