require_relative 'piece'

class Knight < Piece

  AVATARS = { white: "WKt", black: "BKt"}

  MOVE_MAPPINGS = {}

  def available_moves
    moves = remove_occupied(all_possible_moves)
  end

  private

  def all_possible_moves
    offsets = [-2, -1, 1, 2]
    all_inboard = lambda { |move| @board.include?(move) }

    all_possible = offsets.permutation.to_a(2).reject { |x| x[0].abs == x[1].abs }.sort
    all_possible.select!(&all_inboard)
  end

  def remove_occupied(moves)
    moves.reject do |location|
      @board.piece_at(location).color == self.color unless @board.piece_at(location).nil?
    end
  end

end