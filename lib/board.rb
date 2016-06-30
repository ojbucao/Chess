class Board
  attr_reader :size, :locations

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

  def pieces(color = nil)
    return @pieces if color.nil?
    @pieces.select { |coord, piece| piece.color == color }
  end

  def captured_pieces(color = nil)
    return @captured if color.nil?
    @captured.select { |piece| piece.color == color }
  end

  def available_pieces(color = nil)
    pieces(color).select do |coord, piece|
      piece.available_moves.count > 0 || piece.special_moves.count > 0
    end
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


