require_relative 'piece'

class Knight < Piece

  AVATARS = { white: "\u2658", black: "\u265E"}

  MOVE_MAPPINGS = {} # Not used for Knight

  def available_moves
    regular_moves
  end

  def regular_moves
    moves = remove_occupied(all_possible_moves)
  end

  def capture_areas
    all_possible_moves
  end

  private

  def all_possible_moves
    offsets = [-2, -1, 1, 2]

    movements = offsets.permutation.to_a(2).reject { |x| x[0].abs == x[1].abs }.sort
    moves = movements.map(&self.class.all_possible(@current_location))
                     .select(&self.class.all_inboard(@board))
  end

  def remove_occupied(moves)
    moves.reject do |location|
      !@board.piece_at(location).nil? && @board.piece_at(location).color == self.color
    end
  end

end