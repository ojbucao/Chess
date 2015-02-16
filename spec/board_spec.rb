require 'spec_helper.rb'

describe Board do
  
  before :each do
    @board = Board.new(4);
  end

  describe "#new" do
    it "returns a new board object" do
      expect(@board).to be_an_instance_of Board
    end
  end

  describe "#size" do
    it "returns the correct size" do
      expect(@board.size).to eql(4)
    end

    context 'when NOT given a size' do
      it "has a default value of 8" do
        board = Board.new
        expect(board.size).to eql(8)
      end
    end
  end

  describe "#all_coordinates" do
    it "returns an array of coordinates" do
      expect(@board.all_coordinates).to be_an_instance_of Array
    end

    it "returns an array of array of coordinates" do
      expect(@board.all_coordinates[0]).to be_an_instance_of Array
    end

    it "returns the correct number of coordinates: (size)**2" do
      size = 4
      board = Board.new(size)
      expect(board.all_coordinates.size).to eql(size**2)
    end
  end

  describe "#occupy" do
    it "adds coordinates to occupied set and returns true" do
      @board.occupy [2,2]
      expect(@board.occupied? [2,2]).to be(true)
    end

    context "when coord is already occupied" do
      it "return false" do
        @board.occupy [2,2]
        expect(@board.occupy [2,2]).to be(false)
      end
    end

    context "when coord is empty" do
      it "throws and exception" do
        expect { @board.occupy [] }.to raise_error "malformed coordinates"
      end
    end

    context "when coord is not a pair" do
      it "throws and exception" do
        expect { @board.occupy [2] }.to raise_error "malformed coordinates"
      end
    end
  end

  describe "#occupied?" do
    it "returns true/false if given coords is occupied" do
      @board.occupy [2,2]
      expect(@board.occupied? [2,2]).to be(true)
    end
  end

  describe "#unoccupy" do
    it "removes coordinates from occupied set and returns true" do
      @board.occupy [2,2]
      expect(@board.unoccupy [2,2]).to be(true)
    end

    context "when coord is already vacant" do
      it "return false" do
        expect(@board.unoccupy [2,2]).to be(false)
      end
    end

    context "when coord is empty" do
      it "throws and exception" do
        expect { @board.unoccupy [] }.to raise_error "malformed coordinates"
      end
    end

    context "when coord is not a pair" do
      it "throws and exception" do
        expect { @board.unoccupy [2] }.to raise_error "malformed coordinates"
      end
    end
  end

  describe "#translate_coords" do
    it "returns rank/column notations for a given coordinates" do
      board = Board.new(8)
      expect(board.translate_coords([0,0])).to eql("a8")
      expect(board.translate_coords([2,2])).to eql("c6")
      expect(board.translate_coords([6,6])).to eql("g2")
    end
  end
end