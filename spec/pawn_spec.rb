require 'pawn'
require 'board'

describe Pawn do
  before :each do 
    @b = Board.new
    @pb1 = Pawn.new(board: @b, color: :black, start_pos: [1,1])
    @pw1 = Pawn.new(board: @b, color: :white, start_pos: [1,6])
  end

  it 'sets the AVATARS constant'

  context 'when the color is black' do
    it 'moves down the board [positive offset]' do
      expect(@pb1.current_location).to eq([1,1])
      expect(@pb1.available_moves).to contain_exactly([1,2], [1,3])
    end

    it 'capture locations do not show up when no opponent' do
      expect(@pb1.special_moves).to eq([])
    end

    it 'capture locations show up when opponent on said locations' do
      o1 = Pawn.new(board: @b, color: :white, start_pos: [0,2])
      o2 = Pawn.new(board: @b, color: :white, start_pos: [2,2])
      expect(@pb1.special_moves).to contain_exactly([0,2],[2,2])
    end

    it 'capture locations do not show up when same color on said locations' do
      s1 = Pawn.new(board: @b, color: :black, start_pos: [0,2])
      s2 = Pawn.new(board: @b, color: :black, start_pos: [2,2])
      expect(@pb1.special_moves).to eq([])

      s2.move_to([2,3])
      expect(@b.piece_at([2,2])).to be_nil
      expect(s2.current_location).to eq([2,3])
      expect(@pb1.special_moves).to eq([])
      s3 = Pawn.new(board: @b, color: :white, start_pos: [2,2])
      expect(@pb1.special_moves).to contain_exactly([2,2])
    end
  end

  context 'when the color is white' do
    it 'moves up the board [negative offset]' do
      expect(@pw1.current_location).to eq([1,6])
      expect(@pw1.available_moves).to contain_exactly([1,5], [1,4])
    end

    it 'capture locations do not show up when no opponent' do
      expect(@pw1.special_moves).to eq([])
    end

    it 'capture locations show up when opponent on said locations' do
      o1 = Pawn.new(board: @b, color: :black, start_pos: [0,5])
      o2 = Pawn.new(board: @b, color: :black, start_pos: [2,5])
      expect(@pw1.special_moves).to contain_exactly([0,5],[2,5])
    end

    it 'capture locations do not show up when same color on said locations' do
      s1 = Pawn.new(board: @b, color: :white, start_pos: [0,5])
      s2 = Pawn.new(board: @b, color: :white, start_pos: [2,5])
      expect(@pw1.special_moves).to eq([])

      s2.move_to([2,6])
      expect(@b.piece_at([2,5])).to be_nil
      expect(s2.current_location).to eq([2,6])
      expect(@pw1.special_moves).to eq([])
      s3 = Pawn.new(board: @b, color: :black, start_pos: [2,5])
      expect(@pw1.special_moves).to contain_exactly([2,5])
    end
  end

end