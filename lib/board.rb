require 'set'

class Board
  attr_reader :size, :locations

  def initialize(size: 8)
    @size = size
    @locations = generate_all_coords.flatten(1)
    @translated_coords = generate_translated_coords
    @occupied = Set.new
  end

  def occupy(coords)
    raise "malformed coordinates" if coords.size != 2
    return false if self.occupied?(coords)
    return true if @occupied.add(coords)
    return false
  end

  def unoccupy(coords)
    raise "malformed coordinates" if coords.size != 2
    return false if !self.occupied?(coords)
    return true if @occupied.delete coords
    return false
  end

  def occupied?(coords)
    @occupied.include? coords
  end

  def translate_coords(coords)
    @translated_coords[coords]
  end

  def include?(location)
    locations.include? location
  end

  private

  def generate_all_coords
    coordinates = @size.times.map do |x|
                    @size.times.map { |y| [x,y] }
                  end
  end

  def generate_translated_coords
    translation = {}
    numbers = [*(1..@size)].reverse
    letters = [*( 97.chr...(97 + @size).chr )]
    coordinates = generate_all_coords

    numbers.each_with_index do |num, x|
      letters.each_with_index do |ltr, y|
        translation[coordinates[x][y]] = "#{ltr}#{num}"
      end
    end
    return translation
  end
end


