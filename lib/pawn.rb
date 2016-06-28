require_relative 'piece'

class Pawn < Piece

  AVATARS = { white: "\u2659", black: "\u265F"}
  
  MOVE_MAPPINGS = { top: { down_verticals: DOWN_VERTICALS },
                    bottom: { up_verticals: UP_VERTICALS } }

  SPECIAL_MAPPINGS = { top: { down_left_diagonals: DOWN_LEFT_DIAGONALS, 
                                down_right_diagonals: DOWN_RIGHT_DIAGONALS },
                       bottom: { up_left_diagonals: UP_LEFT_DIAGONALS, 
                                up_right_diagonals: UP_RIGHT_DIAGONALS } }

  def initialize(board:, color:, start_pos:)
    super
    position = start_pos[1] <= 3 ? :top : :bottom
    self.class.define_movement_methods(MOVE_MAPPINGS[position])
    self.class.define_movement_methods(SPECIAL_MAPPINGS[position])
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