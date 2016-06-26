require 'set'

class Board
  attr_reader :size, :locations, :pieces, :captured

  def initialize(size: 8)
    @size = size
    @locations = generate_coords.flatten(1)
    @translated_coords = generate_translated_coords
    @pieces = {}
    @captured = []
  end

  def translate_coords(coords)
    @translated_coords[coords]
  end

  def include?(location)
    locations.include? location
  end

  def occupy(target:, piece:)
    unless piece_at(target).nil?
      if piece_at(target).color == piece.color
        raise "You cannot occupy your own piece's spot" 
      end
      @captured << piece_at(target)
    end

    @pieces[target] = piece
  end

  def vacate(location)
    @pieces.delete(location)
  end

  def capture(piece)
  end

  def piece_at(location)
    @pieces[location]
  end

  def occupied?(location)
    !@pieces[location].nil?
  end

  def white_pieces
    @pieces.select { |coord, piece| piece.color == :white }
  end

  def black_pieces
    @pieces.select { |coord, piece| piece.color == :black }
  end

  def captured_white_pieces
    @captured.select { |piece| piece.color == :white }
  end

  def captured_black_pieces
    @captured.select { |piece| piece.color == :black }
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
        translation[coordinates[x][y]] = "#{ltr}#{num}"
      end
    end
    return translation
  end
end


