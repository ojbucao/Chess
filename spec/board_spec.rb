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

    it "removes a piece from previous location" do
      expect(board.occupied? [0, 0]).to be true
      board.occupy(target: [2, 2], piece: piece)
      expect(board.occupied? [0, 0]).to be false
    end

    it "raises an error if location is already occupied by same color" do
      expect(board.occupied? [0, 0]).to be true
      expect { Knight.new(board: board, color: :white, start_pos: [0,0]) }.to raise_error
      expect(board.captured_pieces.count).to eq 0
    end

    it "captures the opponents piece if it's occupying the location" do
      expect(board.occupied? [0, 0]).to be true
      expect(board.captured_pieces.count).to eq 0
      k = Knight.new(board: board, color: :black, start_pos: [0,0])
      expect(board.captured_pieces.count).to eq 1
    end

  end

  describe "#translate_coords" do
    it "returns rank/column notations for a given coordinates" do
      board = Board.new(size: 8)
      expect(board.translate("a8")).to eq([0,0])
      expect(board.translate("c6")).to eq([2,2])
      expect(board.translate("g2")).to eq([6,6])
      expect(board.translate("a1")).to eq([0,7])
      expect(board.translate("h1")).to eq([7,7])
      expect(board.translate("h8")).to eq([7,0])
      expect(board.translate("e4")).to eq([4,4])
      expect(board.translate([0,0])).to eq("a8")
      expect(board.translate([2,2])).to eq("c6")
      expect(board.translate([6,6])).to eq("g2")
      expect(board.translate([0,7])).to eq("a1")
      expect(board.translate([7,7])).to eq("h1")
      expect(board.translate([7,0])).to eq("h8")
      expect(board.translate([4,4])).to eq("e4")
    end
  end
end