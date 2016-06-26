require 'set'

class Board
  attr_reader :size, :locations, :pieces, :captured

  def initialize(size: 8)
    @size = size
    @locations = generate_coords.flatten(1)
    @translated_coords = generate_translated_coords
    @pieces = {}
    @captured = {}
  end

  def translate_coords(coords)
    @translated_coords[coords]
  end

  def include?(location)
    locations.include? location
  end

  def occupy(location:, piece:)
    if piece.current_location == location
      raise "You are already at that location"
    end

    unless piece_at(location).nil?
      if piece_at(location).color == piece.color
        raise "You cannot occupy a teammate's spot" 
      end

      @captured[location] = piece_at(location)
      @captured[location].current_location = nil
    end

    vacate(piece.current_location)

    @pieces[location] = piece
    piece.current_location = location
  end

  def vacate(location)
    unless piece_at(location).nil?
      piece_at(location).current_location = nil
      @pieces.delete(location)
    end
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
    @captured.select { |coord, piece| piece.color == :white }
  end

  def captured_black_pieces
    @captured.select { |coord, piece| piece.color == :black }
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


