require 'piece'
require 'board'

describe Piece do

  before :each do
    mappings = { right_horizontals:      '[ x, 0]',
                 up_left_diagonals:      '[-x, x]' }

    stub_const("Piece::MOVE_MAPPINGS", mappings)
    stub_const("Piece::AVATARS", { white: "WQ", black: "BQ"} )
    described_class.define_movement_methods(described_class::MOVE_MAPPINGS)
  end
  
  let!(:board) { Board.new(size: 8) }

  describe '.define_movement_methods' do
    it 'takes an offset hash and creates methods from it' do
      offsets = described_class.right_horizontals(1)
      expect(offsets).to contain_exactly([1, 0])
    end
  end

  describe '#all_possible_moves' do
    it 'returns an array of all possible moves from a location given a list of offsets' do
      piece = described_class.new(board: board, color: :white, start_pos: [3, 3])
      offsets = piece.send(:all_possible_moves, described_class.right_horizontals(8))
      expect(offsets).to contain_exactly([4, 3], [5, 3], [6, 3], [7, 3])
    end    
  end

  describe '#remove_occupied' do
    before :each do 
      @piece = described_class.new(board: board, color: :white, start_pos: [3, 3])
    end

    context 'when a possible locations is blocked an opponent' do
      it 'returns an array of locations including the blocked location' do
        opponent = described_class.new(board: board, color: :black, start_pos: [6,3])

        offsets = @piece.send(:all_possible_moves, described_class.right_horizontals(8))
        moves = @piece.send(:remove_occupied, offsets)

        expect(moves).to contain_exactly([4, 3], [5, 3], [6, 3])
      end    
    end

    context 'when a possible locations is blocked a teammate' do
      it 'returns an array of locations excluding the blocked location' do
        opponent = Piece.new(board: board, color: :white, start_pos: [6, 3])

        offsets = @piece.send(:all_possible_moves, described_class.right_horizontals(8))
        moves = @piece.send(:remove_occupied, offsets)
        
        expect(moves).to contain_exactly([4, 3], [5, 3])
      end    
    end
  end

  describe '#available_moves' do
    it 'returns an array of only the available moves excluding occupied locations' do
      @piece = described_class.new(board: board, color: :white, start_pos: [3, 3])
      opponent = described_class.new(board: board, color: :black, start_pos: [6,3])
      opponent = Piece.new(board: board, color: :white, start_pos: [0, 6])

      moves = @piece.available_moves
      expect(moves).to contain_exactly([4, 3], [5, 3], [6, 3], [2, 4], [1, 5])
    end
  end

  describe '#move' do
    it 'moves the current piece to the target location'
    it "it increments the piece's move count"
  end

  describe '#avatar' do
    it 'returns the correct avatar for the white color' do
      piece = described_class.new(board: board, color: :white, start_pos: [3, 3])
      expect(piece.avatar).to eq("WQ")
    end
    it 'returns the correct avatar for the black color' do
      piece = described_class.new(board: board, color: :black, start_pos: [3, 3])
      expect(piece.avatar).to eq("BQ")
    end
  end


end