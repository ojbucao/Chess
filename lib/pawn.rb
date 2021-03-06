require_relative 'piece'

class Pawn < Piece

  AVATARS = { white: "\u2659", black: "\u265F"}

  POINTS = 1

  MOVE_MAPPINGS = { facing_down: { down_verticals: Directable::DOWN_VERTICALS },
                    facing_up: { up_verticals: Directable::UP_VERTICALS } }

  SPECIAL_MAPPINGS = { facing_down: { down_left_diagonals: Directable::DOWN_LEFT_DIAGONALS,
                                      down_right_diagonals: Directable::DOWN_RIGHT_DIAGONALS },
                       facing_up: { up_left_diagonals: Directable::UP_LEFT_DIAGONALS,
                                    up_right_diagonals: Directable::UP_RIGHT_DIAGONALS } }

  def initialize(board:, color:, start_pos:)
    super
    @orientation = start_pos[1] <= 3 ? :facing_down : :facing_up
    self.class.define_movement_methods(MOVE_MAPPINGS[@orientation])
    self.class.define_movement_methods(SPECIAL_MAPPINGS[@orientation])
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

  def capture_areas
    super(mappings: SPECIAL_MAPPINGS[@orientation], levels: 1)
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
      side_piece = @board.piece_at(side)
      if side_piece && side_piece.move_count == 1 && side == @board.last_location_used
        memo[target] = side_piece
      end
      memo
    end
    return nil if enpassant.empty?
    enpassant
  end

end
