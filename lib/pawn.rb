require_relative 'piece'

class Pawn < Piece

  AVATARS = { white: "\u2659", black: "\u265F"}

  MOVE_MAPPINGS = { facing_down: { down_verticals: Directable::DOWN_VERTICALS },
                    facing_up: { up_verticals: Directable::UP_VERTICALS } }

  SPECIAL_MAPPINGS = { facing_down: { down_left_diagonals: Directable::DOWN_LEFT_DIAGONALS,
                                      down_right_diagonals: Directable::DOWN_RIGHT_DIAGONALS },
                       facing_up: { up_left_diagonals: Directable::UP_LEFT_DIAGONALS,
                                    up_right_diagonals: Directable::UP_RIGHT_DIAGONALS } }

  SIDE_MAPPINGS =  { left_side: Directable::LEFT_HORIZONTALS, 
                     right_side: Directable::RIGHT_HORIZONTALS }

  def initialize(board:, color:, start_pos:)
    super
    @orientation = start_pos[1] <= 3 ? :facing_down : :facing_up
    self.class.define_movement_methods(MOVE_MAPPINGS[@orientation])
    self.class.define_movement_methods(SPECIAL_MAPPINGS[@orientation])
    self.class.define_movement_methods(SIDE_MAPPINGS)
  end

  def available_moves
    regular_moves + special_moves
  end

  def regular_moves
    moves = get_available_moves(mappings: MOVE_MAPPINGS[@orientation], levels: 2) do |memo|
      toggle_first_move(memo)
    end
    moves.reject! { |move| @board.occupied? move }
    moves
  end

  def special_moves
    moves = get_available_moves(mappings: SPECIAL_MAPPINGS[@orientation], levels: 1) do |memo|
      memo = remove_unoccupied(memo)
    end
    moves + enpassantables.to_h.keys
  end

  def toggle_first_move(moves)
    locations = reorient_locations(moves)
    locations.pop if move_count > 0 && locations.count > 1
    locations
  end

  def enpassantables
    targets = get_available_moves(mappings: SPECIAL_MAPPINGS[@orientation], levels: 1)

    enpassant = targets.inject({}) do |memo, target|
      side = [target[0],current_location[1]]
      if side == @board.last_location_used && @board.piece_at(side).move_count == 1
        memo[target] = @board.piece_at(side)
      end
      memo
    end
    return nil if enpassant.empty?
    enpassant
  end

end
