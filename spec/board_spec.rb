require 'board'
require 'knight'

describe Board do
  
  let!(:board) { Board.new(size: 4) }
  let!(:piece) { Knight.new(board: board, color: :white, start_pos: [0, 0]) }

  # before :each do
  #   board.occupy(location: piece.start_pos, piece: piece)
  # end

  describe "#size" do
    it "returns the correct size" do
      expect(board.size).to eql(4)
    end

    context 'when NOT given a size' do
      it "has a default value of 8" do
        board = Board.new
        expect(board.size).to eql(8)
      end
    end
  end

  describe '#include?' do
    it 'returns true if a location is found in the board' do
      expect(board.include? [0, 0]).to be true
    end

    it 'returns false if a location is found in the board' do
      expect(board.include? [9, 9]).to be false
    end
  end

  describe "#locations" do
    it "returns an array of coordinates" do
      expect(board.locations).to be_an Array
    end

    it "returns an array of array of coordinates" do
      expect(board.locations[0]).to be_an Array
    end

    it "returns the correct number of coordinates: (size)**2" do
      size = 4
      board = Board.new(size: size)
      expect(board.locations.size).to eql(size**2)
    end
  end

  describe "#pieces" do
    it "returns a hash of all the pieces in play" do
      expect(board.pieces).to be_a Hash
      expect(board.pieces).not_to be_empty
    end
  end

  describe "#piece_at" do
    it "returns the piece at a specific location" do
      expect(board.piece_at([0, 0])).to be_a Knight
      expect(board.piece_at([2, 2])).to be_nil
    end
  end

  describe '#white_pieces' do
    it 'returns a hash of all white pieces'
  end

  describe '#black_pieces' do
    it 'returns a hash of all black pieces'
  end

  describe '#captured_white_pieces' do
    it 'returns a hash of all captured white pieces'
  end

  describe '#captured black pieces' do
    it 'returns a hash of call captured black pieces'
  end

  describe "#occupy" do
    it "places a piece at a certain location" do
      expect(board.occupied? [2, 2]).to be false
      board.occupy(target: [2, 2], piece: piece)
      expect(board.occupied? [2, 2]).to be true
    end

    # it "removes a piece from previous location" do
    #   expect(board.occupied? [0, 0]).to be true
    #   board.occupy(target: [2, 2], piece: piece)
    #   expect(board.occupied? [0, 0]).to be false
    # end

    # it "sets the piece's current location to the new location" do
    #   expect(piece.current_location).to eq([0, 0])
    #   board.occupy(target: [2, 2], piece: piece)
    #   expect(piece.current_location).to eq([2, 2])
    # end
  end

  describe "#translate_coords" do
    it "returns rank/column notations for a given coordinates" do
      board = Board.new(size: 8)
      expect(board.translate_coords("a8")).to eq([0,0])
      expect(board.translate_coords("c6")).to eq([2,2])
      expect(board.translate_coords("g2")).to eq([6,6])
      expect(board.translate_coords("a1")).to eq([0,7])
      expect(board.translate_coords("h1")).to eq([7,7])
      expect(board.translate_coords("h8")).to eq([7,0])
      expect(board.translate_coords("e4")).to eq([4,4])
    end
  end
end