require_relative 'directable'

class Board
  extend Directable

  MOVE_MAPPINGS = { up_verticals: Directable::UP_VERTICALS,
                    down_verticals: Directable::DOWN_VERTICALS,
                    left_horizontals: Directable::LEFT_HORIZONTALS,
                    right_horizontals: Directable::RIGHT_HORIZONTALS,
                    up_left_diagonals: Directable::UP_LEFT_DIAGONALS,
                    up_right_diagonals: Directable::UP_RIGHT_DIAGONALS,
                    down_left_diagonals: Directable::DOWN_LEFT_DIAGONALS,
                    down_right_diagonals: Directable::DOWN_RIGHT_DIAGONALS }

  define_movement_methods(MOVE_MAPPINGS)

  attr_reader :size, :locations, :last_location_used

  def initialize(size: 8)
    @size = size
    @locations = generate_coords.flatten(1)
    @translated_coords = generate_translated_coords
    @pieces = {}
    @captured = []
  end

  def translate(coords)
    @translated_coords[coords]
  end

  def include?(location)
    locations.include? location
  end

  def occupy(target:, piece:)
    if occupied?(target)
      if piece_at(target).color == piece.color
        raise "You cannot occupy your own piece's spot"
      end
      capture(target)
    end
    migrate(piece, target)
    @last_location_used = target
  end

  def migrate(piece, target)
    vacate(piece.current_location)
    @pieces[target] = piece
  end

  def vacate(location)
    @pieces.delete(location)
  end

  def capture(target)
    @captured << piece_at(target)
    @pieces.delete(target)
  end

  def piece_at(location)
    @pieces[location]
  end

  def occupied?(location)
    !@pieces[location].nil?
  end

  def pieces(options = {})  
    return @pieces if options.empty? || !options.is_a?(Hash)

    criteria = options.inject([]) do |memo, (k, v)|
      memo << "piece.#{k} == #{v.is_a?(Symbol) ? ':' : ''}#{v}"
    end.join(" && ")  
    
    @pieces.select do |coord, piece| 
      eval(criteria)
    end
  end

  def captured_pieces(color = nil)
    return @captured if color.nil?
    @captured.select { |piece| piece.color == color }
  end

  def movable_pieces(color = nil)
    pieces(color: color).select do |coord, piece|
      piece.available_moves.count > 0 || piece.special_moves.count > 0
    end
  end

  def path_blocked?(locations)
    locations.each do |location|
      return true if occupied? location
    end
    false
  end

  def path_between(origin, target)
    orientation = get_orientation(origin, target)
    return nil if orientation.nil?

    path = self.send(orientation, origin, target)
    path.tap { |me| me.push(origin) }.sort!
    path.reverse! if (target <=> origin) == -1
    path.rotate!(path.index(origin))
    
    result = ((path.index(origin) + 1)...path.index(target)).inject([]) do |memo, i|
      memo << path[i]
      memo
    end

    result
  end

  def get_orientation(origin, target)
    return :same_row if same_row(origin).include? target
    return :same_column if same_column(origin).include? target
    return :same_diagonal unless same_diagonal(origin, target).nil?
  end

  def same_row(origin, target = nil)
    offsets = self.class.left_horizontals(8) + self.class.right_horizontals(8)
    row = offsets.map(&self.class.all_possible(origin))
           .select(&self.class.all_inboard(self))
           .sort
    return nil if !target.nil? && !row.include?(target)
    row
  end

  def same_column(origin, target = nil)
    offsets = self.class.up_verticals(8) + self.class.down_verticals(8)
    column = offsets.map(&self.class.all_possible(origin))
           .select(&self.class.all_inboard(self))
           .sort
    return nil if !target.nil? && !column.include?(target)
    column
  end

  def same_diagonal(origin, target = nil)
    offsets_list = [self.class.up_left_diagonals(8) + self.class.down_right_diagonals(8),
                    self.class.up_right_diagonals(8) + self.class.down_left_diagonals(8)]
    diagonals = offsets_list.inject([]) do |memo, offsets|
      memo << offsets.map(&self.class.all_possible(origin))
                     .select(&self.class.all_inboard(self))
                     .sort
      memo
    end
    return diagonals if target.nil?

    retval = nil
    diagonals.each do |diagonal|
      retval = diagonal if diagonal.include? target
    end
    retval
  end

  def setup(configs)
    configs.each_with_index do |(color, pieces), i|
      pieces.each_with_index do |row, y|
        y += 6 if i == 1  # Move down 6 squares for next set
        row.each_with_index do |klass, x|
          klass.new(board: self, color: color, start_pos: [x, y])
        end
      end
    end
    self
  end

  def castlingables(piece)
    return nil if piece.class != King || !piece.unmoved?
    row = same_row(piece.current_location)
    rooks = [piece_at(row.first), piece_at(row.last)]
  
    castling = rooks.inject({}) do |memo, rook|
      if rook && rook.unmoved?
        path = path_between(piece.current_location, rook.current_location)
        if !path_blocked?(path) && 
           !threatened?(path[1], piece.opposite_color) && 
           !threatened?(piece.current_location, piece.opposite_color)
          memo[path[1]] = [rook, path[0]]
        end
      end
      memo
    end
    return nil if castling.empty?
    castling
  end

  def threatened?(location, color)
    return true if !threats(location, color).to_h.empty?
  end

  # TODO: Refactor this
  def threats(location, color = nil)
    non_pawns = @pieces.reject { |k, v| v.class == Pawn }
    a_threats = non_pawns.inject({}) do |memo, (k, v)|
      memo[k] = v if v.regular_moves.include?(location)
      memo
    end

    pawns = @pieces.select { |k, v| v.class == Pawn }
    b_threats = pawns.inject({}) do |memo, (k, v)|
      memo[k] = v if v.capture_areas.include?(location)
      memo
    end

    threats = a_threats.merge(b_threats)

    if color
      threats.select! { |k, v| v.color == color }
    end
    threats
  end

  private

  def generate_coords
    coordinates = @size.times.map do |x|
                    @size.times.map { |y| [x,y] }
                  end
  end

  def generate_translated_coords
    translation = {}
    numbers = [*(1..@size)].reverse
    letters = [*( 97.chr...(97 + @size).chr )]
    coordinates = generate_coords

    numbers.each_with_index do |num, x|
      letters.each_with_index do |ltr, y|
        translation["#{ltr}#{num}"] = coordinates[y][x]
        translation[[y,x]] = "#{ltr}#{num}"
      end
    end
    return translation
  end
end


