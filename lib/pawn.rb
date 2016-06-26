require_relative 'piece'

class Pawn < Piece

  AVATARS = { white: "WP", black: "BP"}
  
  MOVE_MAPPINGS = { white: { up_verticals:           '[ 0, x]' },
                    black: { down_verticals:         '[ 0,-x]' } }

  SPECIAL_MAPPINGS = { white: { up_left_diagonals:      '[-x, x]', 
                                up_right_diagonals:     '[ x, x]' },
                       black: { down_left_diagonals:    '[-x,-x]', 
                                down_right_diagonals:   '[ x,-x]' } }

  def initialize(board:, color:, start_pos:)
    super
    self.class.define_movement_methods(self.class::MOVE_MAPPINGS[color])
    self.class.define_movement_methods(self.class::SPECIAL_MAPPINGS[color])
  end

  def available_moves
    moves = self.class::MOVE_MAPPINGS[color].keys.inject([]) do |memo, method|
      m = all_possible_moves(eval("self.class.#{method}(2)"))
      memo += remove_occupied(m)
      toggle_first_move(memo)
    end
  end

  def special_moves
    moves = self.class::SPECIAL_MAPPINGS[color].keys.inject([]) do |memo, method|
      m = all_possible_moves(eval("self.class.#{method}(1)"))
      memo += remove_occupied(m)
    end
  end

  def toggle_first_move(moves)
    locations = process_locations(moves)

    locations.pop if move_count > 0 && locations.count > 1
    locations
  end

end