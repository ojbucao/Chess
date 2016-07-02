module Directable
  UP_VERTICALS = '[0, -x]'
  DOWN_VERTICALS = '[0, x]'
  LEFT_HORIZONTALS = '[-x, 0]'
  RIGHT_HORIZONTALS = '[x, 0]'
  UP_LEFT_DIAGONALS = '[-x, -x]'
  UP_RIGHT_DIAGONALS = '[x, -x]'
  DOWN_LEFT_DIAGONALS = '[-x, x]'
  DOWN_RIGHT_DIAGONALS = '[x, x]'

  def define_movement_methods(move_mappings)
    move_mappings.each do |name, offsets|
      define_singleton_method(name) do |upper_limit|
        range = (1..upper_limit)
        moves = range.map { |x| eval(offsets) }
        moves.sort
      end
    end
  end

  def all_possible(location)
    lambda { |move| [location[0] + move[0], location[1] + move[1]] }
  end

  def all_inboard(board)
    lambda { |move| board.include?(move) }
  end

end