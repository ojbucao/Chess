require 'knight'

describe Knight do
  describe 'MOVEMENTS constant' do
    it 'contains the correct coordinates' do
      m = described_class::MOVEMENTS
      expect(m).to contain_exactly([-2, -1], [-2, 1], [-1, -2], [-1, 2], 
                                   [1, -2], [1, 2], [2, -1], [2, 1])
    end
  end

  describe '#possible_moves' do
    context 'when current_location is [0, 0] and board size is 3' do
      it 'has 2 possible moves' do
        b = Board.new(size: 3)
        k = described_class.new(board: b)
        moves = k.possible_moves
        expect(moves).to eq([[1, 2], [2, 1]])
      end
    end
  end

end